import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/product_model.dart';

abstract class ProductRepository {
  Future<void> fetchProducts();
}

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.restful-api.dev/objects'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var something = ProductModelResponse.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        print("I received sometihing $something");
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print("Something went wrong $e");
    }
  }
}
