import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.fetchProducts();
  }

  /// Hàm load lại dữ liệu
  Future<void> refreshData() async {
    setState(() {
      futureProducts = ApiService.fetchProducts();
    });
    await futureProducts;
  }

  void retry() {
    setState(() {
      futureProducts = ApiService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          "TH3 - Ngô Văn Hiến - 2351060444",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          /// LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.teal,
              ),
            );
          }

          /// ERROR
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 15),
                  const Text("Không thể kết nối Internet"),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Thử lại"),
                  ),
                ],
              ),
            );
          }

          /// SUCCESS + PULL TO REFRESH
          /// SUCCESS + PULL TO REFRESH + GRIDVIEW
          final products = snapshot.data!;

          return RefreshIndicator(
            color: Colors.teal,
            onRefresh: refreshData,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cột
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75, // chỉnh chiều cao card
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
