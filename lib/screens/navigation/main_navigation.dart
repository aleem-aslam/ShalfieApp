import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../categories/categories_screen.dart';
import '../cart/cart_screen.dart';
import '../account/account_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFFF1F1F1), // light grey background like design
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              index: 0,
              currentIndex: _currentIndex,
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: _onItemTap,
            ),
            _NavItem(
              index: 1,
              currentIndex: _currentIndex,
              icon: Icons.category,
              label: 'Categories',
              onTap: _onItemTap,
            ),
            _NavItem(
              index: 2,
              currentIndex: _currentIndex,
              icon: Icons.shopping_cart_outlined,
              label: 'Cart',
              onTap: _onItemTap,
            ),
            _NavItem(
              index: 3,
              currentIndex: _currentIndex,
              icon: Icons.person_outline,
              label: 'Account',
              onTap: _onItemTap,
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTap(int index) {
    setState(() => _currentIndex = index);
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == currentIndex;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ICON WITH PILL BACKGROUND WHEN SELECTED
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
