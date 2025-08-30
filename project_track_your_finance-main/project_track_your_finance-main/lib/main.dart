import 'package:flutter/material.dart';
import 'package:project_track_your_finance/screens/pin_lock_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/transaction_provider.dart';
import 'screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.manropeTextTheme(), // Global Google Font
    appBarTheme: AppBarTheme(
      toolbarTextStyle: GoogleFonts.manropeTextTheme().bodyMedium?.copyWith(color: Colors.white),
      titleTextStyle: GoogleFonts.manropeTextTheme().titleLarge?.copyWith(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(buttonColor: Colors.blue),
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.manropeTextTheme(), // Global Google Font
    appBarTheme: AppBarTheme(
      toolbarTextStyle: GoogleFonts.manropeTextTheme().bodyMedium?.copyWith(color: Colors.white),
      titleTextStyle: GoogleFonts.manropeTextTheme().titleLarge?.copyWith(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(buttonColor: Colors.blue),
    scaffoldBackgroundColor: Colors.black,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Run the app with system's theme (light/dark) preference
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider()..fetchTransactions(),
      child: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          return MaterialApp(
            title: 'Finance Tracker',
            theme: AppTheme.lightTheme, // Light Theme
            darkTheme: AppTheme.darkTheme, // Dark Theme
            themeMode: ThemeMode.system, // Auto-detect system theme
            home: transactionProvider.isLoading ? SplashScreen() : PinLockScreen(child: HomeScreen()),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Just Wait...',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
