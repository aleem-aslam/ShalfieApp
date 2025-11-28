// lib/screens/reader/book_details_screen.dart
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: const Center(child: Text('Book Details Screen')),
    );
  }
}
