import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String url = "https://fakestoreapi.com/products?limit=10";

  static Future<List<Product>> fetchProducts() async {
    try {
      await Future.delayed(const Duration(seconds: 3)); // để quay loading

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      throw Exception("Không thể kết nối mạng!");
    }
  }
}
