import 'package:unofficial_filman_client/notifiers/filman.dart';
import 'package:unofficial_filman_client/screens/hello.dart';
import 'package:unofficial_filman_client/screens/main/home.dart';
import 'package:unofficial_filman_client/screens/main/offline.dart';
import 'package:unofficial_filman_client/screens/main/watched.dart';
import 'package:unofficial_filman_client/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;
  bool isExpanded = false; 

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: null, // Ukrycie górnego paska
      body: Row(
        children: [
          // Side menu (left panel) rozwijane przy najechaniu
          MouseRegion(
            onEnter: (_) {
              setState(() {
                isExpanded = true; // Rozwija menu przy najechaniu
              });
            },
            onExit: (_) {
              setState(() {
                isExpanded = false; // Zamyka menu, gdy kursor opuści pasek
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isExpanded ? 200 : 60,
              color: Colors.grey[850],
              child: ListView(
                padding: EdgeInsets.zero, // Wyzerowanie paddingu, by ikony były bliżej
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  // Elementy menu
                  _buildMenuItem(Icons.home, "Strona Główna", 0),
                  _buildMenuItem(Icons.watch_later, "Oglądane", 1),
                  _buildMenuItem(Icons.download, "Pobrane", 2),
                  _buildMenuItem(Icons.settings, "Ustawienia", 3),
                  _buildMenuItem(Icons.logout, "Wyloguj", 4),
                ],
              ),
            ),
          ),
          // Główna zawartość
          Expanded(
            child: IndexedStack(
              index: currentPageIndex,
              children: const [
                HomePage(),
                WatchedPage(),
                OfflinePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Funkcja tworząca elementy menu
  Widget _buildMenuItem(IconData icon, String label, int index) {
    bool isSelected = currentPageIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Mniejszy odstęp między ikonami
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.redAccent : Colors.white,
          size: 24,
        ),
        title: AnimatedOpacity(
          opacity: isExpanded ? 1.0 : 0.0, // Wyświetlanie etykiety tylko w trybie rozwiniętym
          duration: const Duration(milliseconds: 200),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.redAccent : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}
