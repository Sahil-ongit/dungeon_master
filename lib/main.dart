import 'package:dungeon_master/screens/adventure.dart';
import 'package:dungeon_master/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/inventory.dart';     // ✅ Added
import 'screens/storyline.dart';     // ✅ Added
import 'screens/battle.dart';        // ✅ Added


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DungeonMasterApp());
}

class DungeonMasterApp extends StatelessWidget {
  const DungeonMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dungeon Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.deepPurple,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/inventory': (context) => const InventoryScreen(),   // ✅ Added
        '/storyline': (context) => const StorylineScreen(),   // ✅ Added
        '/battle': (context) => const BattleScreen(),
        '/adventure': (context) => const AdventureHomeScreen(),   // ✅ Added

      },
    );
  }
}
