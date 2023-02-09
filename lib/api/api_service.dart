import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:product_app/const/const_data.dart';

import '../model/product_model.dart';

class ApiHttpService {

  //For Get All Result ++++++++++++++++++++++++
  Future<ProductModel> getAllProduct({limit, offset, searchValue}) async {

    var data;

    var url = '${baseUrl}product/search-suggestions/?limit=${limit}&offset=${offset}&search=${searchValue}';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      // print(data);
      return ProductModel.fromJson(data);
    }else{
      return ProductModel.fromJson(data);
    }

  }
}
