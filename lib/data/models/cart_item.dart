class CartItem {
  final String id; // Firestore doc id
  final String bookId; // books collection id
  final String title;
  final String author;
  final double price;
  final String coverUrl;
  final int quantity;

  CartItem({
    required this.id,
    required this.bookId,
    required this.title,
    required this.author,
    required this.price,
    required this.coverUrl,
    required this.quantity,
  });

  factory CartItem.fromMap(String id, Map<String, dynamic> data) {
    return CartItem(
      id: id,
      bookId: data['bookId'] as String,
      title: data['title'] as String,
      author: data['author'] as String,
      price: (data['price'] as num).toDouble(),
      coverUrl: data['coverUrl'] as String,
      quantity: (data['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'title': title,
      'author': author,
      'price': price,
      'coverUrl': coverUrl,
      'quantity': quantity,
    };
  }
}
