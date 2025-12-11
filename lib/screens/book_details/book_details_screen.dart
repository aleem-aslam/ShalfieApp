import 'package:flutter/material.dart';
import '../../data/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repository/cart_repository.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  final _cartRepo = FirestoreCartRepository();
  final _auth = FirebaseAuth.instance;
  BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          book.category,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final user = _auth.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please log in to add items to cart'),
                  ),
                );
                return;
              }

              try {
                await _cartRepo.addToCart(user.uid, book);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book added to cart')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add to cart: $e')),
                );
              }
            },

            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Text(
              book.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 110,
                    height: 160,
                    child: Image.network(
                      book.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow("Author :", book.author),
                      const SizedBox(height: 4),
                      _infoRow("Category :", book.category),
                      const SizedBox(height: 4),
                      _infoRow(
                        "Rating :",
                        book.rating.toStringAsFixed(2),
                        valueStyle: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      _infoRow(
                        "Pricing :",
                        "\$${book.price.toStringAsFixed(2)}",
                        valueStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 140,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            final user = _auth.currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please log in to add items to cart',
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              await _cartRepo.addToCart(user.uid, book);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Book added to cart'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to add to cart: $e'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text("Add to Cart"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Description:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Text(
              book.description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// small helper for "Author : value" rows
Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
  return RichText(
    text: TextSpan(
      text: label,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      children: [
        const TextSpan(text: " "),
        TextSpan(
          text: value,
          style:
              valueStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
        ),
      ],
    ),
  );
}
