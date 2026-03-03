import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String url = "https://dummyjson.com/products?limit=100";

  static Future<List<Product>> fetchProducts() async {
    try {
      await Future.delayed(const Duration(seconds: 3)); // để quay loading

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['products'] as List<dynamic>? ?? [];

        final includeKeywords = [
          'office',
          'desk',
          'workstation',
          'notebook',
          'paper',
          'stationery',
          'folder',
          'calculator',
          'stapler',
          'marker',
          'binder',
          'conference chair',
        ];

        final excludeKeywords = [
          'bed',
          'bedside',
          'sofa',
          'couch',
          'fragrance',
          'perfume',
          'lipstick',
          'beauty',
          'skin',
        ];

        final officeItems = data.where((item) {
          final json = item as Map<String, dynamic>;
          final title = (json['title'] as String? ?? '').toLowerCase();
          final description = (json['description'] as String? ?? '')
              .toLowerCase();
          final category = (json['category'] as String? ?? '').toLowerCase();
          final tags = (json['tags'] as List<dynamic>? ?? [])
              .map((tag) => tag.toString().toLowerCase())
              .join(' ');

          final content = '$title $description $category $tags';
          final matchedInclude = _containsKeyword(content, includeKeywords);
          final matchedExclude = _containsKeyword(content, excludeKeywords);

          return matchedInclude && !matchedExclude;
        }).toList();

        final products = officeItems.map((item) {
          final json = item as Map<String, dynamic>;
          return Product(
            id: json['id'] as int,
            name: json['title'] as String? ?? 'Sản phẩm văn phòng',
            description: json['description'] as String? ?? '',
            image: json['thumbnail'] as String? ?? '',
            price: (json['price'] as num?)?.toDouble() ?? 0,
          );
        }).toList();

        if (products.length < 8) {
          final currentIds = products.map((product) => product.id).toSet();
          for (final product in _backupOfficeProducts()) {
            if (!currentIds.contains(product.id)) {
              products.add(product);
              currentIds.add(product.id);
            }
            if (products.length >= 8) {
              break;
            }
          }
        }

        if (products.isEmpty) {
          throw Exception('Không có dữ liệu văn phòng phẩm');
        }

        return products.take(8).toList();
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      throw Exception("Không thể kết nối mạng!");
    }
  }

  static bool _containsKeyword(String content, List<String> keywords) {
    for (final keyword in keywords) {
      if (keyword.contains(' ')) {
        if (content.contains(keyword)) {
          return true;
        }
      } else {
        final regex = RegExp('\\b${RegExp.escape(keyword)}\\b');
        if (regex.hasMatch(content)) {
          return true;
        }
      }
    }
    return false;
  }

  static List<Product> _backupOfficeProducts() {
    return [
      Product(
        id: 20001,
        name: 'Bút bi xanh văn phòng',
        description: 'Bút bi mực xanh viết êm, phù hợp dùng mỗi ngày.',
        image: 'https://picsum.photos/seed/office-pen-fallback/400/400',
        price: 0.8,
      ),
      Product(
        id: 20002,
        name: 'Sổ tay A5',
        description: 'Sổ ghi chú công việc và lịch họp.',
        image: 'https://picsum.photos/seed/office-notebook-fallback/400/400',
        price: 3.4,
      ),
      Product(
        id: 20003,
        name: 'Giấy note dán',
        description: 'Giấy ghi chú nhiều màu để nhắc việc.',
        image: 'https://picsum.photos/seed/office-note-fallback/400/400',
        price: 2.0,
      ),
      Product(
        id: 20004,
        name: 'Kẹp giấy inox',
        description: 'Kẹp tài liệu gọn gàng và chống gỉ.',
        image: 'https://picsum.photos/seed/office-clip-fallback/400/400',
        price: 1.1,
      ),
      Product(
        id: 20005,
        name: 'Bấm kim mini',
        description: 'Bấm kim nhỏ gọn cho bàn làm việc.',
        image: 'https://picsum.photos/seed/office-stapler-fallback/400/400',
        price: 4.5,
      ),
      Product(
        id: 20006,
        name: 'Bìa hồ sơ A4',
        description: 'Bìa hồ sơ để lưu trữ chứng từ văn phòng.',
        image: 'https://picsum.photos/seed/office-folder-fallback/400/400',
        price: 4.2,
      ),
      Product(
        id: 20007,
        name: 'Bút dạ quang',
        description: 'Bút highlight đánh dấu thông tin quan trọng.',
        image: 'https://picsum.photos/seed/office-marker-fallback/400/400',
        price: 2.7,
      ),
      Product(
        id: 20008,
        name: 'Máy tính cầm tay',
        description: 'Máy tính 12 số hỗ trợ tính toán nhanh.',
        image: 'https://picsum.photos/seed/office-calculator-fallback/400/400',
        price: 11.9,
      ),
    ];
  }
}
