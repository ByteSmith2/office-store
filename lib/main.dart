import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PCShopApp());
}

class PCShopApp extends StatelessWidget {
  const PCShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
