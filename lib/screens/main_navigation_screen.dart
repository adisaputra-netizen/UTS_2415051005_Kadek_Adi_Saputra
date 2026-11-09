import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'recipe_list_screen.dart';
import 'saved_recipes_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onSelectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const cardSurface = Color(0xFFFFFDF9);
    const bgWarmCream = Color(0xFFF4EBDD);

    final screens = [
      HomeScreen(onNavigateToTab: _onSelectTab),
      const RecipeListScreen(),
      const SavedRecipesScreen(),
      const ProfileScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 640;

        if (isWide) {
          // Layout Layar Lebar: NavigationRail
          return Scaffold(
            backgroundColor: bgWarmCream,
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: cardSurface,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onSelectTab,
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryTerracotta.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance, color: primaryTerracotta, size: 28),
                    ),
                  ),
                  selectedIconTheme: const IconThemeData(color: primaryTerracotta),
                  unselectedIconTheme: IconThemeData(color: textEspresso.withValues(alpha: 0.5)),
                  selectedLabelTextStyle: const TextStyle(
                    color: primaryTerracotta,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: textEspresso.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Beranda'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.search_rounded),
                      selectedIcon: Icon(Icons.search_rounded),
                      label: Text('Cari Resep'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bookmark_border_rounded),
                      selectedIcon: Icon(Icons.bookmark_rounded),
                      label: Text('Disimpan'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profil'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1, color: Color(0x1A8D3028)),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: screens,
                  ),
                ),
              ],
            ),
          );
        }

        // Layout Layar HP: Bottom Navigation Bar Kustom dengan Underline Indicator
        return Scaffold(
          backgroundColor: bgWarmCream,
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: cardSurface,
              border: Border(
                top: BorderSide(
                  color: primaryTerracotta.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 66,
                child: Row(
                  children: [
                    _buildNavItem(
                      index: 0,
                      label: 'Beranda',
                      icon: Icons.home_rounded,
                      activeColor: primaryTerracotta,
                      inactiveColor: textEspresso,
                    ),
                    _buildNavItem(
                      index: 1,
                      label: 'Cari Resep',
                      icon: Icons.search_rounded,
                      activeColor: primaryTerracotta,
                      inactiveColor: textEspresso,
                    ),
                    _buildNavItem(
                      index: 2,
                      label: 'Disimpan',
                      icon: Icons.bookmark_border_rounded,
                      activeIcon: Icons.bookmark_rounded,
                      activeColor: primaryTerracotta,
                      inactiveColor: textEspresso,
                    ),
                    _buildNavItem(
                      index: 3,
                      label: 'Profil',
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      activeColor: primaryTerracotta,
                      inactiveColor: textEspresso,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    IconData? activeIcon,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final bool isSelected = _currentIndex == index;
    final color = isSelected ? activeColor : inactiveColor.withValues(alpha: 0.55);

    return Expanded(
      child: InkWell(
        onTap: () => _onSelectTab(index),
        splashColor: activeColor.withValues(alpha: 0.08),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? (activeIcon ?? icon) : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3),
            // Indikator garis bawah (Underline bar) untuk item aktif
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 24 : 0,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
