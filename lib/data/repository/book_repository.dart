import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

// Base abstract class and implementations
abstract class BookRepository {
  Future<List<Book>> getHomeBooks();
  Future<List<Book>> filterBooks({
    String? category,
    String? search,
    String? format,
    double? minPrice,
    double? maxPrice,
  });
}

class FirestoreBookRepository implements BookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Book>> getHomeBooks() async {
    /// Fetch recommended/home books from Firestore.
    ///later change  logic or add a "home" field in Firestore.

    final snapshot = await _firestore.collection('books').limit(20).get();

    return snapshot.docs
        .map((doc) => Book.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<List<Book>> filterBooks({
    String? category,
    String? search,
    String? format,
    double? minPrice,
    double? maxPrice,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection('books');

    // FILTER: category
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    // FILTER: format (if you use it)
    if (format != null && format.isNotEmpty) {
      query = query.where('format', isEqualTo: format);
    }

    // FILTER: price range
    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    //  get all matching docs first
    final snapshot = await query.get();
    var books = snapshot.docs
        .map((doc) => Book.fromMap(doc.id, doc.data()))
        .toList();

    // then apply search in Dart (case-insensitive, contains)
    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();

      books = books.where((b) {
        final title = b.title.toLowerCase();
        final author = b.author.toLowerCase();

        return title.contains(q) || author.contains(q);
      }).toList();
    }

    return books;
  }
}
