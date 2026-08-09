import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecom_api/core/providers/navigation_provider.dart';
import 'package:ecom_api/core/providers/favorites_provider.dart';
import 'home_view.dart';
import 'favorites_view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    HomeView(),
    FavoritesView(),
    Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      body: IndexedStack(index: navProvider.selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navProvider.selectedIndex,
        onTap: (index) => navProvider.setIndex(index),
        selectedItemColor: const Color(0xFFC67C4E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Consumer<FavoritesProvider>(
              builder: (context, favProvider, child) {
                final count = favProvider.badgeCount;
                if (count == 0) return const Icon(Icons.favorite_border);
                return Badge(
                  label: Text('$count'),
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.favorite_border),
                );
              },
            ),
            activeIcon: const Icon(Icons.favorite, color: Colors.red),
            label: 'Favorites',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
