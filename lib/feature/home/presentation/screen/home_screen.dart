import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/feature/settings/presentation/screen/settings_screen.dart';
import 'package:rook_flutter_demo/feature/summaries/presentation/screen/summaries_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentPageIndex,
          onDestinationSelected: (int index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.home_sharp),
              icon: Icon(Icons.home_outlined),
              label: "Summaries",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings_sharp),
              icon: Icon(Icons.settings_outlined),
              label: "Settings",
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: const [
            SummariesScreen(),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }
}
