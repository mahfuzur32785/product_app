import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:product_app/getX/product_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../api/api_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController serchController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final productController = Get.put(ProductController());

  /*final ScrollController scrollController = new ScrollController();
  int offset = 1;
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    var limit = productController.productList.value.data?.products?.count;

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        productController.getAllProduct(limit: limit, offset: offset++, search: searchValue);
      }
    });
  }*/

  final PagingController<int, dynamic> _pagingController = PagingController(
    firstPageKey: 0,
  );

  int offset = 1;
  int limit = 10;
  String searchValue = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    productController.getAllProduct(limit: limit, offset: offset, search: searchValue);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey: pageKey +1);
      print("pageKey is $pageKey");
    });
  }

  Future<void> _fetchPage({int? pageKey}) async {
    try {
      var newItems = await ApiHttpService().getAllProduct(
        searchValue: searchValue,
        offset: offset,
        limit: limit,
      );
      // productController.productList.value = newItems.data?.products?.results;

      productController.productList.addAll(newItems.data!.products!.results!.toList());

      final isLastPage = newItems.data!.products!.results!.length < limit;
      if (isLastPage) {
        _pagingController
            .appendLastPage(newItems.data?.products?.results as List);
      } else {
        final nextPageKey = pageKey; // newItems.length;
        _pagingController.appendPage(
            newItems.data?.products?.results as List, nextPageKey);
      }
    } catch (error) {
      // _pagingController.error = error;
      print("Error is ${error}");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Color(0xFFE5E5E5),
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: serchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  suffixIconColor: Color(0xFFA7A7A7),
                ),
                cursorColor: Colors.black,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    productController.getAllProduct();
                  },
                  child: GetX<ProductController>(
                    builder: (controller) {
                      if (productController.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      }
                      return PagedGridView(
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, item, index) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Image(
                                    image: NetworkImage(
                                        "${controller.productList[index].image}"),
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text(
                                      "${controller.productList[index].brand!.name}")
                                ],
                              ),
                            );
                          },
                        ),
                        gridDelegate: SliverQuiltedGridDelegate(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            pattern: List.generate(
                              controller.productList.length,
                              (index) {
                                return QuiltedGridTile(1, 1);
                              },
                            )),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
