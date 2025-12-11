import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item.dart';
import '../models/book.dart';

abstract class CartRepository {
  Stream<List<CartItem>> watchCart(String userId);
  Future<void> addToCart(String userId, Book book, {int quantity});
  Future<void> removeFromCart(String userId, String cartItemId);
  Future<void> clearCart(String userId);

  Future<void> updateQuantity(
    String userId,
    String cartItemId,
    int newQuantity,
  );
}

class FirestoreCartRepository implements CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _cartRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  @override
  Future<void> updateQuantity(
    String userId,
    String cartItemId,
    int newQuantity,
  ) async {
    await _cartRef(userId).doc(cartItemId).update({'quantity': newQuantity});
  }

  @override
  Stream<List<CartItem>> watchCart(String userId) {
    return _cartRef(
      userId,
    ).orderBy('createdAt', descending: false).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<void> addToCart(String userId, Book book, {int quantity = 1}) async {
    final ref = _cartRef(userId);

    // If book already in cart, just bump quantity
    final existing = await ref
        .where('bookId', isEqualTo: book.id)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      await existing.docs.first.reference.update({
        'quantity': FieldValue.increment(quantity),
      });
    } else {
      await ref.add({
        'bookId': book.id,
        'title': book.title,
        'author': book.author,
        'price': book.price,
        'coverUrl': book.coverUrl,
        'quantity': quantity,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<void> removeFromCart(String userId, String cartItemId) async {
    await _cartRef(userId).doc(cartItemId).delete();
  }

  @override
  Future<void> clearCart(String userId) async {
    final snapshot = await _cartRef(userId).get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
