import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repository/cart_repository.dart';
import '../../data/models/cart_item.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double total;

  const CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final CartRepository _cartRepo = FirestoreCartRepository();

  String _selectedPayment = 'cod'; // 'card' or 'cod'

  bool _isLoadingAddresses = true;
  List<Map<String, dynamic>> _addresses = [];
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoadingAddresses = false;
        _addresses = [];
        _selectedAddressId = null;
      });
      return;
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .orderBy('createdAt', descending: false)
        .get();

    final list = snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();

    String? selectedId;

    // try default
    try {
      final defaultAddr = list.firstWhere(
        (a) => (a['isDefault'] ?? false) == true,
      );
      selectedId = defaultAddr['id'] as String;
    } catch (_) {
      if (list.isNotEmpty) {
        selectedId = list.first['id'] as String;
      }
    }

    setState(() {
      _addresses = list;
      _selectedAddressId = selectedId;
      _isLoadingAddresses = false;
    });
  }

  Map<String, dynamic>? get _selectedAddress {
    if (_selectedAddressId == null) return null;
    try {
      return _addresses.firstWhere((a) => a['id'] == _selectedAddressId);
    } catch (_) {
      return null;
    }
  }

  void _openAddAddressSheet() {
    final user = _auth.currentUser;
    if (user == null) return;

    final fullNameCtrl = TextEditingController();
    final line1Ctrl = TextEditingController();
    final line2Ctrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final provinceCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Delivery Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: fullNameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: line1Ctrl,
                  decoration: const InputDecoration(
                    labelText: 'Address Line 1',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: line2Ctrl,
                  decoration: const InputDecoration(
                    labelText: 'Address Line 2 (optional)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: cityCtrl,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provinceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Province / State',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (fullNameCtrl.text.trim().isEmpty ||
                          line1Ctrl.text.trim().isEmpty ||
                          cityCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please fill in at least name, address, city.',
                            ),
                          ),
                        );
                        return;
                      }

                      final isFirst = _addresses.isEmpty;

                      await _firestore
                          .collection('users')
                          .doc(user.uid)
                          .collection('addresses')
                          .add({
                            'fullName': fullNameCtrl.text.trim(),
                            'line1': line1Ctrl.text.trim(),
                            'line2': line2Ctrl.text.trim(),
                            'city': cityCtrl.text.trim(),
                            'province': provinceCtrl.text.trim(),
                            'phone': phoneCtrl.text.trim(),
                            'isDefault': isFirst,
                            'createdAt': FieldValue.serverTimestamp(),
                          });

                      Navigator.of(ctx).pop();
                      await _loadAddresses();
                    },
                    child: const Text('Save Address'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openChangeAddressSheet() {
    if (_addresses.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String? tempSelected = _selectedAddressId;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Delivery Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _addresses.length,
                      itemBuilder: (context, index) {
                        final addr = _addresses[index];
                        final id = addr['id'] as String;
                        final line1 = addr['line1'] ?? '';
                        final line2 = addr['line2'] ?? '';
                        final city = addr['city'] ?? '';
                        final fullName = addr['fullName'] ?? '';
                        final phone = addr['phone'] ?? '';

                        final subtitle =
                            '$line1${line2.isNotEmpty ? ', $line2' : ''}, $city';

                        return RadioListTile<String>(
                          value: id,
                          groupValue: tempSelected,
                          onChanged: (val) {
                            setSheetState(() => tempSelected = val);
                          },
                          title: Text(fullName),
                          subtitle: Text('$subtitle\n$phone'),
                          isThreeLine: true,
                          dense: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedAddressId = tempSelected;
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Use This Address'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handlePay() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please log in first.')));
      return;
    }

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address.')),
      );
      return;
    }

    // Get cart items
    final cartSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .get();

    if (cartSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
      return;
    }

    final items = cartSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'bookId': data['bookId'],
        'title': data['title'],
        'author': data['author'],
        'price': data['price'],
        'coverUrl': data['coverUrl'],
        'quantity': data['quantity'],
      };
    }).toList();

    final orderData = {
      'total': widget.total,
      'paymentMethod': _selectedPayment,
      'addressId': _selectedAddressId,
      'address': {
        'fullName': _selectedAddress!['fullName'],
        'line1': _selectedAddress!['line1'],
        'line2': _selectedAddress!['line2'],
        'city': _selectedAddress!['city'],
        'province': _selectedAddress!['province'],
        'phone': _selectedAddress!['phone'],
      },
      'items': items,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      // 1) create order
      final orderRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .add(orderData);

      // 2) clear cart
      await _cartRepo.clearCart(user.uid);

      // 3) go to success screen (replace checkout → back goes to Cart)
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(orderId: orderRef.id),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final addr = _selectedAddress;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivering Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (_isLoadingAddresses)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Loading address...',
                  style: TextStyle(fontSize: 13),
                ),
              )
            else if (addr == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No address selected. Please add a delivery address.',
                  style: TextStyle(fontSize: 13),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${addr['fullName']}\n'
                        '${addr['line1']}'
                        '${(addr['line2'] as String).isNotEmpty ? ', ${addr['line2']}' : ''}\n'
                        '${addr['city']}, ${addr['province']}\n'
                        '${addr['phone']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _openChangeAddressSheet,
                      child: const Text(
                        'Change',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _openAddAddressSheet,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
              child: const Text('Add a New Delivery Address'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              value: 'card',
              groupValue: _selectedPayment,
              onChanged: (val) {
                setState(() => _selectedPayment = val!);
              },
              title: const Text('Credit Card'),
              dense: true,
            ),
            RadioListTile<String>(
              value: 'cod',
              groupValue: _selectedPayment,
              onChanged: (val) {
                setState(() => _selectedPayment = val!);
              },
              title: const Text('Cash on Delivery'),
              dense: true,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _handlePay,
                child: Text('Pay \$${widget.total.toStringAsFixed(2)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
