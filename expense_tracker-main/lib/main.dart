import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Initialize Flutter bindings - REQUIRED for async main
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with Flutter
  await Hive.initFlutter();

  // Register the adapter for the Expense class
  Hive.registerAdapter(ExpenseAdapter());

  // Open a Hive box named 'expenses' to store our data
  await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      // In your main.dart, replace the theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple, // Professional purple theme
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Modern Material 3 design
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: const Center(
        child: Text('App is ready! Hive is initialized.'),
      ),
    );
  }
}