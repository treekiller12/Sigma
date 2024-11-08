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
      backgroundColor: Colors.transparent, // Tło transparentne
      elevation: 0, // Bez cienia
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
        mainAxisAlignment: MainAxisAlignment.start, // Ustawienie w lewo
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
              letterSpacing: 1.2, // Zwiększenie odstępów liter
            ),
          ),
        ],
      ),
      actions: [
        // Ikona ustawień z efektem podświetlenia
        MouseRegion(
          onEnter: (_) => setState(() {}),
          onExit: (_) => setState(() {}),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (final context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
            color: Colors.white,
            hoverColor: Colors.transparent, // Brak podświetlenia na hover
          ),
        ),
        // Ikona wylogowania z efektem podświetlenia
        MouseRegion(
          onEnter: (_) => setState(() {}),
          onExit: (_) => setState(() {}),
          child: IconButton(
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
            hoverColor: Colors.transparent, // Brak podświetlenia na hover
          ),
        ),
      ],
      automaticallyImplyLeading: false,
      bottom: showProgress
          ? const PreferredSize(
              preferredSize: Size.fromHeight(4),
              child: LinearProgressIndicator(
                color: Colors.redAccent, // Można dostosować kolor paska ładowania
              ),
            )
          : null,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context), // Dodajemy zmodyfikowany AppBar
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (final int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: _buildHoverIcon(Icons.home, true),
            icon: _buildHoverIcon(Icons.home_outlined, false),
            label: "Strona Główna",
          ),
          NavigationDestination(
            selectedIcon: _buildHoverIcon(Icons.watch_later, true),
            icon: _buildHoverIcon(Icons.watch_later_outlined, false),
            label: "Oglądane",
          ),
          NavigationDestination(
            selectedIcon: _buildHoverIcon(Icons.download, true),
            icon: _buildHoverIcon(Icons.download_outlined, false),
            label: "Pobrane",
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: const [
          HomePage(),
          WatchedPage(),
          OfflinePage(),
        ],
      ),
    );
  }

  // Funkcja do tworzenia ikon z efektem podświetlenia
  Widget _buildHoverIcon(IconData icon, bool isSelected) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: Icon(
        icon,
        size: 30,
        color: isSelected ? Colors.redAccent : Colors.grey, // Szary kolor domyślnie
      ),
    );
  }
}
