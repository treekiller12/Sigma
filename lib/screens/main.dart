import "package:unofficial_filman_client/notifiers/filman.dart";
import "package:unofficial_filman_client/screens/hello.dart";
import "package:unofficial_filman_client/screens/main/home.dart";
import "package:unofficial_filman_client/screens/main/offline.dart";
import "package:unofficial_filman_client/screens/main/watched.dart";
import "package:unofficial_filman_client/screens/settings.dart";
import "package:unofficial_filman_client/utils/greeting.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  AppBar _buildAppBar(final BuildContext context, {final bool showProgress = false}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0, // Usuwamy cień
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black, // Kolor na górze
              Colors.transparent, // Przezroczystość na dole
            ],
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Logo
          Image.asset(
            'assets/logo.png', // Upewnij się, że masz odpowiednią ścieżkę do swojego logo
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 8),
          // Nazwa aplikacji - mniejsza czcionka
          const Text(
            "Filman TV Client",
            style: TextStyle(
              color: Colors.white, // Biały tekst
              fontSize: 18, // Mniejszy rozmiar tekstu
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (final context) => const SettingsScreen(),
              ),
            );
          },
          icon: const Icon(Icons.settings),
          color: Colors.white,
        ),
        IconButton(
          onPressed: () {
            Provider.of<FilmanNotifier>(context, listen: false).logout();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (final context) => const HelloScreen(),
              ),
            );
          },
          icon: const Icon(Icons.logout),
          color: Colors.white,
        ),
      ],
      automaticallyImplyLeading: false,
      bottom: showProgress
          ? const PreferredSize(
              preferredSize: Size.fromHeight(4),
              child: LinearProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Zmodyfikowany pasek nawigacji z gradientem na górze
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black, // Kolor na górze
                  Colors.transparent, // Przezroczystość na dole
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem("Strona Główna", 0),
                  _buildNavItem("Oglądane", 1),
                  _buildNavItem("Pobrane", 2),
                ],
              ),
            ),
          ),
          // Ciało aplikacji
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

  // Funkcja do tworzenia elementów nawigacji z efektem podświetlenia
  Widget _buildNavItem(String label, int index) {
    bool isSelected = currentPageIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentPageIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.redAccent : Colors.grey, // Szary kolor, czerwony jak wybrany
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
