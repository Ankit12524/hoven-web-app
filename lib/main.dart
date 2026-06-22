import 'package:basic_hoven_website/alisha_valentine_page.dart';
import 'package:basic_hoven_website/only_for_harshita.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'location_page.dart';
import 'package:basic_hoven_website/user_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart'; // Add this import

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  usePathUrlStrategy(); // Add this line before runApp

  runApp(const HovenPatisserieApp());
}

class HovenPatisserieApp extends StatelessWidget {
  const HovenPatisserieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: shopNameFull,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5D4037), // Dark brown
          primary: const Color(0xFF5D4037),
          secondary: const Color(0xFFD7CCC8),
          surface: const Color(0xFFFFFBFF),
          onSurface: const Color(0xFF1E1B16),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(), // Your main landing page
        '/scam': (context) => AlishaValentinePage(), // The new page you want
        '/onlyForHarshiita' : (context) => OnlyForHarshitaExperience(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const MenuPage(),
    const LocationPage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'Contact',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person_2),
            label: 'User',
          ),
        ],
      ),
    );
  }
}