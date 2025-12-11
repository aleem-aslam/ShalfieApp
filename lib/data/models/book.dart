class Book {
  final String id;
  final String title;
  final String author;
  final String category; // e.g. "Classics", "Fantasy"
  final String format; // e.g. "Paperback", "Hardcover"
  final double price;
  final String coverUrl;
  final String description;
  final double rating; // e.g. 4.5

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.format,
    required this.price,
    required this.coverUrl,
    required this.description,
    required this.rating,
  });

  factory Book.fromMap(String id, Map<String, dynamic> data) {
    return Book(
      id: id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      format: data['format'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      coverUrl: data['coverUrl'] ?? '',
      description: data['description'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'format': format,
      'price': price,
      'coverUrl': coverUrl,
      'description': description,
    };
  }
}
