import 'package:flutter/material.dart';
import 'dart:io';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _profileImage;
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Load initial user data (simulate backend)
    _nameController.text = "John Doe";
    _emailController.text = "johndoe123@mail.com";
    _passwordController.text = "********";
    _addressController.text = "No.23, James Street,\nNew Town, North Province";
  }

  Future<void> _pickImage() async {
    // Simulate image selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Profile Photo"),
        content: const Text("Choose an option"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                // Simulate camera selection (_profileImage would be set here)
              });
            },
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                // Simulate gallery selection (_profileImage would be set here)
              });
            },
            child: const Text("Gallery"),
          ),
        ],
      ),
    );
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _saveChanges();
      }
    });
  }

  void _saveChanges() {
    // In real app, save to backend
    final newName = _nameController.text;
    final newEmail = _emailController.text;
    final newAddress = _addressController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    print('Saved changes: $newName, $newEmail, $newAddress');
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: () {
                _saveChanges();
                setState(() {
                  _isEditing = false;
                });
              },
              icon: const Icon(Icons.check),
              tooltip: "Save Changes",
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image with Edit Option
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name Section
            _buildEditableInfoRow(
              "Name:",
              _nameController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),

            // Email Section
            _buildEditableInfoRow(
              "E-mail:",
              _emailController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),

            // Password Section
            _buildEditableInfoRow(
              "Password:",
              _passwordController,
              isEditing: _isEditing,
              isPassword: true,
            ),
            const SizedBox(height: 16),

            // Address Section
            _buildEditableAddressRow(),
            const SizedBox(height: 30),

            // Buttons
            if (!_isEditing)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _toggleEditing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Edit"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Log out"),
                    ),
                  ),
                ],
              ),

            if (_isEditing)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Cancel editing, discard changes
                        setState(() {
                          _isEditing = false;
                          _loadUserData();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveChanges();
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableInfoRow(
    String label,
    TextEditingController controller, {
    required bool isEditing,
    bool isPassword = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: isEditing
              ? TextField(
                  controller: controller,
                  obscureText: isPassword,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : Text(
                  controller.text,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
        ),
      ],
    );
  }

  Widget _buildEditableAddressRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "Address:",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: _isEditing
              ? TextField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : Text(
                  _addressController.text,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
