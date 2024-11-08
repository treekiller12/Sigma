import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unofficial_filman_client/notifiers/filman.dart';
import 'package:unofficial_filman_client/screens/main.dart';

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

  AppBar _buildAppBar(final BuildContext context,
      {final bool showProgress = false}) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/logo.png', // Zaktualizuj ścieżkę do swojego logo
            height: 30,
            width: 30,
          ),
          const SizedBox(width: 8),
          const Text(
            "Filman TV Client",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.transparent,
            ],
          ),
        ),
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
          icon: const Icon(Icons.settings, color: Colors.white),
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
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
      automaticallyImplyLeading: false,
      bottom: showProgress
          ? const PreferredSize(
              preferredSize: Size.fromHeight(4),
              child: LinearProgressIndicator(),
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (final int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Strona Główna",
          ),
          NavigationDestination(
            icon: Icon(Icons.watch_later_outlined),
            label: "Oglądane",
          ),
          NavigationDestination(
            icon: Icon(Icons.download_outlined),
            label: "Pobrane",
          ),
        ],
      ),
    );
  }
}
