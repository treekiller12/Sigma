import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:unofficial_filman_client/notifiers/filman.dart";
import "package:unofficial_filman_client/screens/main.dart";
import "package:bonsoir/bonsoir.dart";
import "dart:io";
import "package:device_info_plus/device_info_plus.dart";

enum LoginState { waiting, loginin, done }

class HelloScreen extends StatefulWidget {
  const HelloScreen({super.key});

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  LoginState state = LoginState.waiting;
  String status = "Otwórz aplikację na telefonie";
  late final BonsoirBroadcast broadcast;

  @override
  void initState() {
    super.initState();
    setupLogin();
  }

  @override
  void dispose() {
    super.dispose();
    broadcast.stop();
  }

  void setupLogin() async {
    final BonsoirService service = BonsoirService(
      name: (await DeviceInfoPlugin().androidInfo).device,
      type: "_majusssfilman._tcp",
      port: 3030,
    );
    broadcast = BonsoirBroadcast(service: service);

    final serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 3031);
    serverSocket.listen((final client) {
      client.listen((final raw) {
        final data = String.fromCharCodes(raw).trim();
        if (data == "GETSTATE") {
          client.write("STATE:${state.toString()}");
          return;
        }
        if (data.startsWith("LOGIN:")) {
          final [login, cookies] = data.split(":")[1].split("|");
          final filmanNotifier =
              Provider.of<FilmanNotifier>(context, listen: false);
          setState(() {
            state = LoginState.loginin;
            status = "Logowanie jako $login...";
            filmanNotifier.cookies
              ..clear()
              ..addAll(cookies.split(","));
            filmanNotifier.prefs.setStringList("cookies", cookies.split(","));
            filmanNotifier.saveUser(login);
          });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (final _) => const MainScreen()));
          client.write("STATE:LoginState.done");
          broadcast.stop();
        }
      });
    });

    await broadcast.ready;
    await broadcast.start();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Górna część z logo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Filman TV Client",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),  // Odstęp dla reszty elementów
            // Centralna część ekranu
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Instrukcja
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Aby się zalogować, otwórz aplikację Filman na telefonie i kliknij 'Zaloguj się' na Android TV.",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Twoje filmy i seriale",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: state == LoginState.loginin
                          ? null  // Przyciski nieklikalny podczas logowania
                          : () {
                              setState(() {
                                state = LoginState.loginin;
                                status = "Rozpoczynanie logowania...";
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state == LoginState.loginin
                            ? Colors.grey // Kolor szary podczas logowania
                            : Colors.redAccent,  // Kolor normalny przycisku
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        state == LoginState.loginin
                            ? "Logowanie..."  // Tekst w czasie logowania
                            : "Oczekiwanie...",  // Tekst początkowy
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
