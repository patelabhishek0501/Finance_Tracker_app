import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:project_track_your_finance/screens/add_transaction_screen.dart';
import 'home.dart'; // TransactionsScreen
import 'statistics_screen.dart';
import 'wallet_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    TransactionsScreen(),
    StatisticsScreen(),
    WalletPage(),
    SettingsScreen(),
  ];

  final List<IconData> _iconList = [
    Icons.home_outlined,
    Icons.pie_chart_outline,
    Icons.account_balance_wallet_outlined,
    Icons.settings_outlined,
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // Add your floating button with proper spacing from the bottom bar
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0), // Add some space if needed
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTransactionScreen()),
            );
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // FAB should be at center of bottom

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _iconList,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        onTap: _onTabSelected,
        activeColor: Colors.blue,
        inactiveColor: Colors.grey,
        // backgroundColor: Colors.white,
        iconSize: 26,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor 
                            ?? (Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey[900]! 
                                : Colors.white),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        splashRadius: 30,
        elevation: 8,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        height: 60,
        // Add any other properties you want to customize
      ),
    );
  }
}

