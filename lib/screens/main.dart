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

  // Funkcja do budowania AppBar z gradientem
  AppBar _buildAppBar(final BuildContext context, {final bool showProgress = false}) {
    return AppBar(
      backgroundColor: Colors.transparent, // Transparentne tło, bo gradient jest tłem
      elevation: 0, // Brak cienia
      title: Row(
        children: [
          // Logo
          Image.asset(
            'assets/logo.png', // Upewnij się, że masz odpowiednią ścieżkę do swojego logo
            height: 30,
            width: 30,
          ),
          const SizedBox(width: 8),
          // Nazwa aplikacji
          const Text(
            "Filman TV Client",
            style: TextStyle(
              color: Colors.white, // Biały tekst
              fontSize: 20,
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
            hoverColor: Colors.redAccent, // Efekt podświetlenia
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
            hoverColor: Colors.redAccent, // Efekt podświetlenia
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
            selectedIcon: Icon(Icons.home, color: Colors.redAccent),
            icon: Icon(Icons.home_outlined),
            label: "Strona Główna",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.watch_later, color: Colors.redAccent),
            icon: Icon(Icons.watch_later_outlined),
            label: "Oglądane",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.download, color: Colors.redAccent),
            icon: Icon(Icons.download_outlined),
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
}
