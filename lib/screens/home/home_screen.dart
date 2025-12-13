import 'package:flutter/material.dart';

import '../../data/models/book.dart';
import '../../data/repository/book_repository.dart';
import '../book_details/book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BookRepository _bookRepository;

  late Future<List<Book>> _homeFuture;

  Future<List<Book>>? _searchFuture;
  bool _showSearchResults = false;

  final TextEditingController _searchController = TextEditingController();
  final PageController _bestDealsController = PageController(
    viewportFraction: 0.9,
  );

  int _bestDealsPage = 0;

  @override
  void initState() {
    super.initState();
    _bookRepository = FirestoreBookRepository();
    _homeFuture = _bookRepository.getHomeBooks();

    _bestDealsController.addListener(() {
      final page = _bestDealsController.page?.round() ?? 0;
      if (page != _bestDealsPage) {
        setState(() => _bestDealsPage = page);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bestDealsController.dispose();
    super.dispose();
  }

  void _startSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _showSearchResults = true;
      _searchFuture = _bookRepository.filterBooks(search: trimmed);
    });
  }

  void _clearSearch() {
    setState(() {
      _showSearchResults = false;
      _searchFuture = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Happy Reading!',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _startSearch(_searchController.text),
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: _startSearch,
                ),
              ),
            ),

            Expanded(
              child: _showSearchResults
                  ? _buildSearchResults()
                  : _buildHomeSections(),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------
  // HOME SECTIONS (NORMAL)
  // -----------------------
  Widget _buildHomeSections() {
    return FutureBuilder<List<Book>>(
      future: _homeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allBooks = snapshot.data ?? [];
        if (allBooks.isEmpty) {
          return const Center(child: Text('No books available right now.'));
        }

        // Simple slicing – still fully dynamic from Firestore
        final bestDeals = allBooks.take(5).toList();
        final topBooks = allBooks;
        final latestBooks = allBooks.reversed.take(6).toList();
        final upcomingBooks = allBooks.skip(3).take(6).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            // ----- Best Deals -----
            const Text(
              'Best Deals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 210,
              child: PageView.builder(
                controller: _bestDealsController,
                itemCount: bestDeals.length,
                itemBuilder: (context, index) {
                  final book = bestDeals[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _BestDealCard(book: book),
                  );
                },
              ),
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                bestDeals.length,
                (index) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _bestDealsPage
                        ? Colors.black
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ----- Top Books -----
            _sectionHeader('Top Books', trailing: 'see more'),
            const SizedBox(height: 16),

            // Row(
            //   // children: [
            //   //   _TopFilterChip(label: 'This Week', selected: true),
            //   //   const SizedBox(width: 8),
            //   //   _TopFilterChip(label: 'This Month'),
            //   //   const SizedBox(width: 8),
            //   //   _TopFilterChip(label: 'This Year'),
            //   // ],
            // ),
            const SizedBox(height: 12),

            SizedBox(
              height: 325,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: topBooks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final book = topBooks[index];
                  return _VerticalBookCard(book: book);
                },
              ),
            ),

            const SizedBox(height: 24),

            // ----- Latest Books -----
            _sectionHeader('Latest Books', trailing: 'see more'),
            const SizedBox(height: 16),
            SizedBox(
              height: 325,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: latestBooks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final book = latestBooks[index];
                  return _VerticalBookCard(book: book);
                },
              ),
            ),

            const SizedBox(height: 24),

            // ----- Upcoming Books -----
            _sectionHeader('Upcoming Books', trailing: 'see more'),
            const SizedBox(height: 16),
            SizedBox(
              height: 325,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: upcomingBooks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final book = upcomingBooks[index];
                  return _VerticalBookCard(book: book);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionHeader(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchFuture == null) {
      return const Center(child: Text('Type something to search books.'));
    }

    return FutureBuilder<List<Book>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return const Center(child: Text('No books found.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final book = results[index];
            return _SearchResultTile(book: book);
          },
        );
      },
    );
  }
}

class _BestDealCard extends StatelessWidget {
  final Book book;

  const _BestDealCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // cover
            SizedBox(
              width: 110,
              height: double.infinity,
              child: Image.network(
                book.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\$${book.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '12% off',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalBookCard extends StatelessWidget {
  final Book book;

  const _VerticalBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final category = (book.category ?? '').isNotEmpty ? book.category! : '';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
        );
      },
      child: SizedBox(
        width: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // cover with grey background
              AspectRatio(
                aspectRatio: 0.7,
                child: Container(
                  color: Colors.grey.shade300,
                  child: Image.network(
                    book.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              // black info panel
              Container(
                width: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (category.isNotEmpty)
                      Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    if (category.isNotEmpty) const SizedBox(height: 2),
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${book.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopFilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _TopFilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: selected ? Colors.black : Colors.transparent,
        border: Border.all(
          color: selected ? Colors.black : Colors.grey.shade400,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : Colors.black,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Book book;

  const _SearchResultTile({required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 50,
          height: 80,
          child: Image.network(
            book.coverUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
      ),
      title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        '\$${book.price.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
        );
      },
    );
  }
}
