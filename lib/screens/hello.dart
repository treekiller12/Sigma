import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unofficial_filman_client/notifiers/filman.dart';
import 'package:unofficial_filman_client/screens/main.dart';
import 'package:bonsoir/bonsoir.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

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
  FocusNode _loginFocusNode = FocusNode();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    setupLogin();
  }

  @override
  void dispose() {
    _loginFocusNode.dispose();
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
    // Definiowanie kolorów przycisku na podstawie stanu logowania
    Color buttonColor;
    String buttonText;

    switch (state) {
      case LoginState.waiting:
        buttonColor = Colors.orangeAccent; // Kolor dla stanu oczekiwania
        buttonText = "Oczekuje na logowanie...";
        break;
      case LoginState.loginin:
        buttonColor = Colors.blueAccent; // Kolor dla stanu logowania
        buttonText = "Logowanie...";
        break;
      case LoginState.done:
        buttonColor = Colors.greenAccent; // Kolor dla stanu zalogowano
        buttonText = "Zalogowano";
        break;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Filman TV Client",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "Aby się zalogować, otwórz aplikację Filman na telefonie i kliknij 'Zaloguj się' na Android TV.",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Focus(
                focusNode: _loginFocusNode,
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isHovered = hasFocus; // Zmiana na podstawie fokusu
                  });
                },
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovered = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: buttonColor, // Dynamiczny kolor przycisku
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 5,
                                offset: const Offset(0, 5),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: (state == LoginState.waiting || state == LoginState.loginin)
                          ? null
                          : () {
                              // Działanie po kliknięciu przycisku, gdy zalogowano
                            },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        buttonText, // Tekst przycisku w zależności od stanu
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
