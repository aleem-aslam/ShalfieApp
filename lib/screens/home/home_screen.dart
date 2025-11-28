import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool showSearch = false;

  // Animation controller for expanding search bar
  late AnimationController searchController;
  late Animation<double> searchAnimation;

  @override
  void initState() {
    super.initState();

    searchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    searchAnimation = Tween<double>(begin: 0, end: 60).animate(
      CurvedAnimation(parent: searchController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ---------------------------------------
  // SAMPLE BOOK DATA
  // ---------------------------------------
  final List<Map<String, dynamic>> bestDeals = [
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "price": 28.00,
      "image":
          "https://m.media-amazon.com/images/I/91bYsX41DVL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "title": "The Subtle Art",
      "author": "Mark Manson",
      "price": 22.00,
      "image":
          "https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "price": 28.00,
      "image":
          "https://m.media-amazon.com/images/I/91bYsX41DVL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "title": "The Subtle Art",
      "author": "Mark Manson",
      "price": 22.00,
      "image":
          "https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg",
    },
  ];

  final List<Map<String, dynamic>> latestBooks = [
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "price": 28.00,
      "image":
          "https://m.media-amazon.com/images/I/91bYsX41DVL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "title": "The Subtle Art",
      "author": "Mark Manson",
      "price": 22.00,
      "image":
          "https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "price": 28.00,
      "image":
          "https://m.media-amazon.com/images/I/91bYsX41DVL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "title": "The Subtle Art",
      "author": "Mark Manson",
      "price": 22.00,
      "image":
          "https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg",
    },
  ];

  final List<Map<String, dynamic>> topBooks = [
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "price": 28.00,
      "image":
          "https://m.media-amazon.com/images/I/91bYsX41DVL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "title": "The Subtle Art",
      "author": "Mark Manson",
      "price": 22.00,
      "image":
          "https://m.media-amazon.com/images/I/71QKQ9mwV7L._AC_UF1000,1000_QL80_.jpg",
    },
  ];

  // ---------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text(
          "Happy Reading",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                showSearch = !showSearch;
                showSearch
                    ? searchController.forward()
                    : searchController.reverse();
              });
            },
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ANIMATED SEARCH BAR
              SizeTransition(
                sizeFactor: searchAnimation.drive(Tween(begin: 0, end: 1)),
                axisAlignment: -1,
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search books...",
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // BEST DEALS
              sectionHeader("Best Deals"),
              const SizedBox(height: 10),
              buildHorizontalList(bestDeals),

              const SizedBox(height: 30),

              // LATEST BOOKS
              sectionHeader("Latest Books"),
              const SizedBox(height: 12),
              buildHorizontalList(latestBooks),

              const SizedBox(height: 30),

              // TOP BOOKS
              sectionHeader("Top Books"),
              const SizedBox(height: 12),
              buildHorizontalList(topBooks),
            ],
          ),
        ),
      ),
    );
  }

  // REUSABLE SECTION HEADER
  Widget sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          "see more",
          style: TextStyle(fontSize: 12, color: Colors.blueGrey),
        ),
      ],
    );
  }

  // REUSABLE HORIZONTAL LIST
  Widget buildHorizontalList(List<Map<String, dynamic>> books) {
    return SizedBox(
      height: 235,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return GestureDetector(
            onTap: () {
              // Later: Navigator.push(...)
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BOOK IMAGE
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),

                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(book["image"]),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    book["title"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    book["author"],
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${book["price"]}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
