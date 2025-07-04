import 'package:flutter/material.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/main/favorite_screen.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/main/home_screen.dart';
import 'package:flutter_resep_masakan_nusantara_uas/screens/main/profile_screen.dart';

class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Gunakan animasi untuk perpindahan yang lebih mulus
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan OrientationBuilder untuk UI adaptif
    return OrientationBuilder(
      builder: (context, orientation) {
        // Jika layar landscape, gunakan NavigationRail
        if (orientation == Orientation.landscape) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Beranda'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bookmark_border),
                      selectedIcon: Icon(Icons.bookmark),
                      label: Text('Favorit'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profil'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: _pages,
                  ),
                ),
              ],
            ),
          );
        }
        
        // Jika portrait, gunakan BottomNavigationBar
        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Favorit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}