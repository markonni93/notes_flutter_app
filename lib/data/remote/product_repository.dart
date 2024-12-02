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
        List<dynamic> jsonList = jsonDecode(response.body);

        print("json list is $jsonList");

        // Parse each item in the list into a Product object
        List<Product> products = jsonList.map((item) => Product.fromJson(item)).toList();


        print("products $products");

        // Print parsed objects
        for (var product in products) {
          print('ID: ${product.id}');
          print('Name: ${product.name}');
          print('Color: ${product.data?.color}');
          print('Capacity: ${product.data?.capacity}');
        }
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
