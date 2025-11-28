import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Mock data - will be replaced with backend API calls
  final List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      title: 'Tuesday Mooney',
      subtitle: 'Talks to Ghosts',
      author: 'Kate Raccula',
      quantity: 1,
      price: 33.00,
      imageUrl: 'assets/images/tuesday_mooney.jpg',
    ),
    CartItem(
      id: '2',
      title: 'Hello, Dream',
      subtitle: 'Adult Narrative',
      author: 'Cristina Camerena, Lady Desatia',
      quantity: 1,
      price: 17.00,
      imageUrl: 'assets/images/hello_dream.jpg',
    ),
  ];

  double get _subtotal {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get _shipping => 10.00;
  double get _total => _subtotal + _shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(_cartItems[index]);
              },
            ),
          ),

          // Order Summary
          _buildOrderSummary(),

          // Checkout Button
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Title and Author
          Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            item.subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            item.author,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Quantity and Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity Selector
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _updateQuantity(item.id, item.quantity - 1),
                      child: const Icon(Icons.remove, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.quantity.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _updateQuantity(item.id, item.quantity + 1),
                      child: const Icon(Icons.add, size: 16),
                    ),
                  ],
                ),
              ),

              // Price
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Order Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),

          // Subtotal
          _buildSummaryRow("Subtotal", _subtotal),
          const SizedBox(height: 8),

          // Shipping
          _buildSummaryRow("Shipping", _shipping),
          const SizedBox(height: 12),

          // Divider
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '\$${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _proceedToCheckout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Proceed to Checkout",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Backend-ready methods
  void _updateQuantity(String itemId, int newQuantity) {
    if (newQuantity < 1) return;

    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);

        // Backend integration point: Update quantity in database
        // await CartService.updateQuantity(itemId, newQuantity);
      }
    });
  }

  void _proceedToCheckout() {
    // Backend integration point: Process checkout
    // await CheckoutService.processOrder(_cartItems);

    // Navigate to checkout screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen()));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Proceeding to checkout...')));
  }

  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);

      // Backend integration point: Remove item from cart
      // await CartService.removeFromCart(itemId);
    });
  }
}

// Data model for cart items - can be moved to models folder later
class CartItem {
  final String id;
  final String title;
  final String subtitle;
  final String author;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  CartItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? author,
    int? quantity,
    double? price,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      author: author ?? this.author,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
