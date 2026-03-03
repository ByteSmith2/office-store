import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffF4F6FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),

            const SizedBox(height: 10),

            /// NAME
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),

            const SizedBox(height: 6),

            /// PRICE
            Text(
              "${product.price} USD",
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
