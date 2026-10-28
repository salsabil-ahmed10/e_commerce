import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_details.dart';

class ProductDetailsRepository {

Future<ProductDetails> getProductDetails(int id) async {
  final response = await http
      .get(Uri.parse('https://dummyjson.com/products/$id'))
      .timeout(const Duration(seconds: 15));

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return ProductDetails.fromJson(data as Map<String, dynamic>);
  } else {
    throw Exception(data['message'] ?? 'Failed to load product');
  }
}

}
