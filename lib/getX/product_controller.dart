import 'package:product_app/api/api_service.dart';
import 'package:get/get.dart';
import 'package:product_app/model/product_model.dart';

class ProductController extends GetxController {
  // var productList = ProductModel().obs;
  var isLoading = true.obs;

  List<Results> productList = <Results>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllProduct();
  }

  getAllProduct({limit = 0, offset = 0, search = ''}) async {
    try {
      isLoading(true);
      var products = await ApiHttpService()
          .getAllProduct(limit: limit, offset: offset, searchValue: search);

      if (products != null) {
        // productList.value = products;
        productList.addAll(products.data!.products!.results!.toList());
        //print("All products: ${productList.value.data!.products!.results![0].brand!.name}");
      } else {
        print("No products found");
      }
    } finally {
      isLoading(false);
    }
  }
}

/*
                      return  MasonryGridView.count(
                        pagingController: _pagingController,
                        itemCount: productController.productList.value.data?.products?.results?.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        // itemCount: controller.productList.value.data?.products?.results?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(5),
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Image(image: NetworkImage("${controller.productList.value.data!.products!.results![index].image}"),
                                  height: 100,
                                  width: 100,
                                ),
                                Text("${controller.productList.value.data!.products!.results![index].brand!.name}")
                              ],
                            ),
                          );
                        },
                      );
*/

/*FutureBuilder(
                  future: ApiHttpService().getAllProduct(limit: 10, offset: 1, search: ''),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return  MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemCount: snapshot.data!.data!.products!.results!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(5),
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image(image: NetworkImage("${snapshot.data!.data!.products!.results![index].image}"),
                              height: 100,
                              width: 100,
                            ),
                            Text("${snapshot.data!.data!.products!.results![index].brand!.name}")
                          ],
                        ),
                      );
                    },
                  );
                },

                )*/
