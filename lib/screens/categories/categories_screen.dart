import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../book_details/book_details_screen.dart';

import '../../data/models/book.dart';
import '../../data/repository/book_repository.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // category config (these are fine as static)
  List<_CategoryItem> get _categories => const [
    _CategoryItem(name: "Non-fiction", image: "assets/images/non-fiction.png"),
    _CategoryItem(name: "Classics", image: "assets/images/classics.png"),
    _CategoryItem(name: "Fantasy", image: "assets/images/fantasy.png"),
    _CategoryItem(name: "Young Adult", image: "assets/images/youngadult.png"),
    _CategoryItem(name: "Crime", image: "assets/images/crime.png"),
    _CategoryItem(name: "Horror", image: "assets/images/horror.png"),
    _CategoryItem(name: "Sci-fi", image: "assets/images/sci-fi.png"),
    _CategoryItem(name: "Drama", image: "assets/images/drama.png"),
  ];

  // backend + state
  late final BookRepository _bookRepo;
  Future<List<Book>>? _futureBooks;

  String? _selectedCategory;
  String? _searchQuery;
  String? _selectedFormat; // Paperback / Hardcover
  double _minPrice = 0;
  double _maxPrice = 100;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _bookRepo = FirestoreBookRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // search + FILTER ROW
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: "Search title/author/ISBN no",
                                border: InputBorder.none,
                              ),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                final query = value.trim();
                                if (query.isEmpty) return;

                                setState(() {
                                  _searchQuery = query;
                                  _selectedCategory = null;
                                  _showResults = true;

                                  _futureBooks = _bookRepo.filterBooks(
                                    search: query,
                                    format: _selectedFormat,
                                    minPrice: _minPrice,
                                    maxPrice: _maxPrice,
                                  );
                                });
                              },
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
                    child: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        _openFilterBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  if (_showResults)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _showResults = false;
                          _selectedCategory = null;
                          _searchQuery = null;
                          _futureBooks = null;
                        });
                      },
                    ),
                  const SizedBox(width: 8),
                  Text(
                    _showResults ? "Results" : "Categories",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              //MAIN AREA: categories grid OR results
              Expanded(
                child: _showResults
                    ? _buildResultsArea()
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.6,
                            ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final item = _categories[index];
                          return _CategoryCard(
                            item: item,
                            onTap: () => _onCategorySelected(item.name),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //FILTER BOTTOM SHEET

  void _openFilterBottomSheet(BuildContext context) {
    String? tempFormat = _selectedFormat;
    double tempMin = _minPrice;
    double tempMax = _maxPrice;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Type",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text("Paperback"),
                        selected: tempFormat == "Paperback",
                        onSelected: (sel) {
                          setSheetState(() {
                            tempFormat = sel ? "Paperback" : null;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text("Hardcover"),
                        selected: tempFormat == "Hardcover",
                        onSelected: (sel) {
                          setSheetState(() {
                            tempFormat = sel ? "Hardcover" : null;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Price Range",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  RangeSlider(
                    values: RangeValues(tempMin, tempMax),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    labels: RangeLabels(
                      "\$${tempMin.toStringAsFixed(0)}",
                      "\$${tempMax.toStringAsFixed(0)}",
                    ),
                    onChanged: (values) {
                      setSheetState(() {
                        tempMin = values.start;
                        tempMax = values.end;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _selectedFormat = null;
                              _minPrice = 0;
                              _maxPrice = 100;
                            });
                          },
                          child: const Text("Reset"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _selectedFormat = tempFormat;
                              _minPrice = tempMin;
                              _maxPrice = tempMax;
                              _showResults = true;

                              _futureBooks = _bookRepo.filterBooks(
                                category: _selectedCategory,
                                search: _searchQuery,
                                format: _selectedFormat,
                                minPrice: _minPrice,
                                maxPrice: _maxPrice,
                              );
                            });
                          },
                          child: const Text("Apply"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //WHEN CATEGORY SELECTED

  void _onCategorySelected(String name) {
    setState(() {
      _selectedCategory = name;
      _searchQuery = null;
      _showResults = true;

      _futureBooks = _bookRepo.filterBooks(
        category: name,
        format: _selectedFormat,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      );
    });
  }

  //RESULTS AREA

  Widget _buildResultsArea() {
    if (_futureBooks == null) {
      return const Center(
        child: Text("Search or choose a category to see books."),
      );
    }

    return FutureBuilder<List<Book>>(
      future: _futureBooks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final books = snapshot.data ?? [];

        if (books.isEmpty) {
          return const Center(child: Text("No books found."));
        }

        return GridView.builder(
          padding: const EdgeInsets.only(
            bottom: 16,
          ), // 👈 add some bottom space
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.55,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _buildBookCard(
              context,
              book,
            ); // 👈 we’ll change this function next
          },
        );
      },
    );
  }

  Widget _buildBookCard(BuildContext context, Book book) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 6),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// simple model for local use
class _CategoryItem {
  final String name;
  final String image; // asset path

  const _CategoryItem({required this.name, required this.image});
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  final VoidCallback onTap;

  const _CategoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(item.image, fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.4)),
            Center(
              child: Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
