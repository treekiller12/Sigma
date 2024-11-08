import "package:unofficial_filman_client/notifiers/filman.dart";
import "package:unofficial_filman_client/screens/hello.dart";
import "package:unofficial_filman_client/screens/main/home.dart";
import "package:unofficial_filman_client/screens/main/offline.dart";
import "package:unofficial_filman_client/screens/main/watched.dart";
import "package:unofficial_filman_client/screens/settings.dart";
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
        // Paski nawigacji w AppBar
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu),
          color: Colors.black,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Text(
                "Strona Główna",
                style: TextStyle(
                  color: Colors.grey[350], // Kolor tekstu szaro-biały
                ),
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Text(
                "Oglądane",
                style: TextStyle(
                  color: Colors.grey[350], // Kolor tekstu szaro-biały
                ),
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(
                "Pobrane",
                style: TextStyle(
                  color: Colors.grey[350], // Kolor tekstu szaro-biały
                ),
              ),
            ),
          ],
          onSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
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
