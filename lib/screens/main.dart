import 'package:flutter/material.dart';
import 'package:unofficial_filman_client/screens/home.dart';
import 'package:unofficial_filman_client/screens/settings.dart';
import 'package:unofficial_filman_client/screens/watched.dart';
import 'package:unofficial_filman_client/screens/offline.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  FocusNode homeFocusNode = FocusNode();
  FocusNode watchedFocusNode = FocusNode();
  FocusNode offlineFocusNode = FocusNode();
  FocusNode settingsFocusNode = FocusNode();

  @override
  void dispose() {
    homeFocusNode.dispose();
    watchedFocusNode.dispose();
    offlineFocusNode.dispose();
    settingsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Row(
        children: [
          FocusScope(
            child: MouseRegion(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 200,
                color: Colors.grey[850],
                child: ListView(
                  children: [
                    _buildMenuItem(Icons.home, "Strona Główna", 0, homeFocusNode),
                    _buildMenuItem(Icons.watch_later, "Oglądane", 1, watchedFocusNode),
                    _buildMenuItem(Icons.download, "Offline", 2, offlineFocusNode),
                    _buildMenuItem(Icons.settings, "Ustawienia", 3, settingsFocusNode),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                switch (currentPageIndex) {
                  case 0:
                    return const HomePage();
                  case 1:
                    return const WatchedPage();
                  case 2:
                    return const OfflinePage();
                  case 3:
                    return const SettingsPage();
                  default:
                    return const HomePage();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    final IconData icon,
    final String title,
    final int pageIndex,
    final FocusNode focusNode,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          currentPageIndex = pageIndex;
        });
      },
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (hasFocus) {
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: focusNode.hasFocus ? Colors.pink : Colors.transparent,
          child: Row(
            children: [
              Icon(icon, color: focusNode.hasFocus ? Colors.white : Colors.grey),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: focusNode.hasFocus ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
