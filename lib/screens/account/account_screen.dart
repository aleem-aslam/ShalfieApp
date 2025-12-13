import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _loading = true;

  String? _name;
  String? _email;
  String? _photoUrl;
  String? _phone;
  String? _addressLine1;
  String? _addressLine2;
  String? _city;
  String? _province;

  int _ordersCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    _email = user.email;

    final userRef = _firestore.collection('users').doc(user.uid);
    final snap = await userRef.get();

    if (snap.exists) {
      final data = snap.data()!;
      _name = (data['name'] ?? '') as String;
      _photoUrl = (data['photoUrl'] ?? '') as String;
      _phone = (data['phone'] ?? '') as String;
      _addressLine1 = (data['addressLine1'] ?? '') as String;
      _addressLine2 = (data['addressLine2'] ?? '') as String;
      _city = (data['city'] ?? '') as String;
      _province = (data['province'] ?? '') as String;
    } else {
      await userRef.set({
        'name': '',
        'photoUrl': '',
        'phone': '',
        'addressLine1': '',
        'addressLine2': '',
        'city': '',
        'province': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      _name = '';
      _photoUrl = '';
      _phone = '';
      _addressLine1 = '';
      _addressLine2 = '';
      _city = '';
      _province = '';
    }

    final ordersSnap = await userRef.collection('orders').get();
    _ordersCount = ordersSnap.size;

    setState(() => _loading = false);
  }

  /// EDIT PROFILE (name + photo)
  void _openEditProfileSheet() {
    final nameCtrl = TextEditingController(text: _name ?? '');
    final phoneCtrl = TextEditingController(text: _phone ?? '');
    final addr1Ctrl = TextEditingController(text: _addressLine1 ?? '');
    final addr2Ctrl = TextEditingController(text: _addressLine2 ?? '');
    final cityCtrl = TextEditingController(text: _city ?? '');
    final provinceCtrl = TextEditingController(text: _province ?? '');

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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: addr1Ctrl,
                  decoration: const InputDecoration(
                    labelText: 'Address Line 1',
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: addr2Ctrl,
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
                      final user = _auth.currentUser;
                      if (user == null) return;

                      final dataToUpdate = {
                        'name': nameCtrl.text.trim(),
                        'phone': phoneCtrl.text.trim(),
                        'addressLine1': addr1Ctrl.text.trim(),
                        'addressLine2': addr2Ctrl.text.trim(),
                        'city': cityCtrl.text.trim(),
                        'province': provinceCtrl.text.trim(),
                      };

                      await _firestore
                          .collection('users')
                          .doc(user.uid)
                          .update(dataToUpdate);

                      setState(() {
                        _name = dataToUpdate['name'] as String;
                        _phone = dataToUpdate['phone'] as String;
                        _addressLine1 = dataToUpdate['addressLine1'] as String;
                        _addressLine2 = dataToUpdate['addressLine2'] as String;
                        _city = dataToUpdate['city'] as String;
                        _province = dataToUpdate['province'] as String;
                      });

                      if (!mounted) return;
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    context.goNamed('login');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _name != null && _name!.isNotEmpty ? _name! : 'Guest User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              /// PROFILE PHOTO
              GestureDetector(
                onTap: () {
                  // photo upload can be added later
                },
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.black12,
                  backgroundImage: (_photoUrl != null && _photoUrl!.isNotEmpty)
                      ? NetworkImage(_photoUrl!)
                      : null,
                  child: (_photoUrl == null || _photoUrl!.isEmpty)
                      ? const Icon(
                          Icons.person,
                          size: 42,
                          color: Colors.black54,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),

              /// NAME
              // Text(
              //   _name?.isNotEmpty == true ? _name! : "User",
              //   style: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              const SizedBox(height: 8),

              /// EMAIL
              Text(
                _email ?? "",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              /// MANAGE ADDRESSES BUTTON
              _actionButton(
                icon: Icons.location_on_outlined,
                label: "Manage Delivery Addresses",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Address management coming soon.'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              /// ORDER HISTORY
              _actionButton(
                icon: Icons.receipt_long,
                label: "Order History ($_ordersCount)",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order history screen coming next.'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              /// EDIT + LOGOUT
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                      ),
                      onPressed: _openEditProfileSheet,
                      child: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        side: const BorderSide(color: Colors.black),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _logout,
                      child: const Text('Log out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(label)),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
