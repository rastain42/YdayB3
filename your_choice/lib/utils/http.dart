import 'dart:convert';

import 'package:your_choice/entities/product.dart';
import 'package:http/http.dart' as http;

const String url = "http://161.97.90.183:8000";

Future<List<Product>> getProducts() async {
  final response = await http.get(Uri.parse('$url/products'));
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    List<Product> products = list.map((model) => Product.fromJson(model)).toList();
    return products;
  } else {
    throw Exception('ERROR:Failed to get products');
  }
}

Future<List<Product>> getBasket(token) async {
  final response = await http.get(Uri.parse('$url/carts/my-cart'), headers: {'Authorization': 'Bearer $token'});
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    List<Product> products = list.map((model) => Product.fromJson(model)).toList();
    return products;
  } else {
    throw Exception('ERROR:Failed to get products');
  }
}

Future<String> post({required String route, required Object body, Map<String, String>? headers}) async {
  final response = await http.post(
    Uri.parse(url + route),
    body: body,
    headers: headers,
  );
  final responseCode = response.statusCode;
  if (responseCode == 302) {
    return response.body;
  } else {
    throw Exception('ERROR:Failed to post at $route,\ncode :$responseCode,\nmessage : ${response.body}');
  }
}

Future<String> delete({required String route, required Object body, Map<String, String>? headers}) async {
  final response = await http.post(
    Uri.parse(url + route),
    body: body,
    headers: headers,
  );
  final responseCode = response.statusCode;
  if (responseCode == 201) {
    return response.body;
  } else {
    throw Exception('ERROR:Failed to post at $route,\n code :$responseCode ');
  }
}

// 401 exception
class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);
}

const networkRoundTripTime = Duration(milliseconds: 750);
