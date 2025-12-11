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
    /// You can later change this logic or add a "home" field in Firestore.

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

    // FILTER: Category
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    // FILTER: Format
    if (format != null && format.isNotEmpty) {
      query = query.where('format', isEqualTo: format);
    }

    // FILTER: Price range
    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    // FILTER: Search (title)
    if (search != null && search.isNotEmpty) {
      final endText = "$search\uf8ff";
      query = query
          .orderBy('title')
          .where('title', isGreaterThanOrEqualTo: search)
          .where('title', isLessThanOrEqualTo: endText);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => Book.fromMap(doc.id, doc.data()))
        .toList();
  }
}
