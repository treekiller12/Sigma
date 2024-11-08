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
  bool isExpanded = false; // Flag to track the state of the sidebar

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Hide the top app bar
        child: Container(),
      ),
      body: Row(
        children: [
          // Side menu (left panel)
          FocusTraversalGroup(
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isExpanded = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isExpanded = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isExpanded ? 200 : 60, // Toggle width based on expansion state
                color: Colors.grey[850], // Dark gray color for the menu
                child: ListView(
                  children: [
                    // Logo at the top
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/logo.png', // Update the path to your logo
                        height: 50,
                        width: 50,
                      ),
                    ),
                    // Menu items
                    _buildMenuItem(Icons.home, "Strona Główna", 0),
                    _buildMenuItem(Icons.watch_later, "Oglądane", 1),
                    _buildMenuItem(Icons.download, "Pobrane", 2),
                    _buildMenuItem(Icons.settings, "Ustawienia", 3),
                    _buildMenuItem(Icons.logout, "Wyloguj", 4),
                  ],
                ),
              ),
            ),
          ),
          // Main content
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

  // Function to create menu items with icons and labels
  Widget _buildMenuItem(IconData icon, String label, int index) {
    bool isSelected = currentPageIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.redAccent : Colors.white,
        size: 24, // Smaller icon size
      ),
      title: AnimatedOpacity(
        opacity: isExpanded ? 1.0 : 0.0, // Show the label only when expanded
        duration: const Duration(milliseconds: 200),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.redAccent : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14, // Smaller text size for the label
          ),
        ),
      ),
      onTap: () {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }
}
