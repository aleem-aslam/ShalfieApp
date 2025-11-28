import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  // Dummy categories – later replace with backend data
  final List<Map<String, String>> categories = [
    {
      "name": "Non-fiction",
      "image":
          "https://m.media-amazon.com/images/I/7167M4Z5H-L._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "name": "Classics",
      "image":
          "https://m.media-amazon.com/images/I/81DwnP3eF8L._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "name": "Fantasy",
      "image":
          "https://m.media-amazon.com/images/I/91b0C2YNSrL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "name": "Young Adult",
      "image":
          "https://m.media-amazon.com/images/I/81mTwOJt2oL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "name": "Crime",
      "image":
          "https://m.media-amazon.com/images/I/71s0PbqQFML._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "name": "Horror",
      "image":
          "https://m.media-amazon.com/images/I/81VfxErkqOL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "name": "Sci-fi",
      "image":
          "https://m.media-amazon.com/images/I/81gepf1QFSL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "name": "Drama",
      "image":
          "https://m.media-amazon.com/images/I/81OthjkJBuL._AC_UF1000,1000_QL80_.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- SEARCH BAR -----------------
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.black87),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search title/author/ISBN no",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.filter_list_rounded),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------------- TITLE -----------------
              const Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 15),

              // ---------------- CATEGORIES GRID -----------------
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return GestureDetector(
                    onTap: () {
                      // TODO: Later add navigation to category listing screen
                      // Navigator.push(...)
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(cat["image"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            cat["name"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(blurRadius: 4, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
