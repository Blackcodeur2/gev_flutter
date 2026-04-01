import 'package:camer_trip/app/screens/history/reservation_page.dart';
import 'package:camer_trip/app/screens/home/home_page.dart';
import 'package:camer_trip/app/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 📌 Pages
  final List<Widget> _pages = const [
    HomePage(),
    Center(child: Text("Recherche")),
    SizedBox(), // bouton central (action sheet)
    ReservationsPages(),
    SettingPage()
  ];

  /// 🔐 Simulation (remplace par ton AuthService)
  bool get isLoggedIn => false;

  void _onTabTapped(int index) {
    // 🔥 Bouton central = action
    if (index == 2) {
      _openAddModal();
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  void _openAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text("Agent IA "),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,

        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor:
            theme.colorScheme.onSurface.withOpacity(0.6),
        backgroundColor: theme.colorScheme.surface,

        type: BottomNavigationBarType.fixed,
        elevation: 8,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt, size: 32),
            label: 'Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Reservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Parametres',
          ),
        ],
      ),
    );
  }
}