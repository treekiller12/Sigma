import "package:unofficial_filman_client/notifiers/filman.dart";
import "package:unofficial_filman_client/screens/main.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:unofficial_filman_client/widgets/recaptcha.dart";
import "package:url_launcher/url_launcher.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController loginController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController repasswordController;
  late final GoogleReCaptchaController recaptchaV2Controller;

  void _submitForm() {
    setState(() {
      recaptchaV2Controller.show();
      isLoading = true;
    });
  }

  void _register(final String recaptchatoken) async {
    final registerResponse =
        await Provider.of<FilmanNotifier>(context, listen: false)
            .createAccountOnFilman(
                loginController.text,
                emailController.text,
                passwordController.text,
                repasswordController.text,
                recaptchatoken);

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });

    if (registerResponse.success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Zarejestrowano pomyślnie!"),
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ));

      final loginResponse =
          await Provider.of<FilmanNotifier>(context, listen: false)
              .loginToFilman(loginController.text, passwordController.text);

      if (!mounted) return;
      if (loginResponse.success) {
        Provider.of<FilmanNotifier>(context, listen: false).saveUser(
          loginController.text,
          passwordController.text,
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (final context) => const MainScreen()),
          );
        }
      } else {
        for (final error in loginResponse.errors) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(error),
              dismissDirection: DismissDirection.horizontal,
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ));
          }
        }
      }
    } else {
      for (final error in registerResponse.errors) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error),
            dismissDirection: DismissDirection.horizontal,
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
          ));
        }
      }
    }
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loginController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    repasswordController = TextEditingController();
    recaptchaV2Controller = GoogleReCaptchaController()
      ..onToken((final String token) {
        _register(token);
      });
  }

  @override
  void dispose() {
    super.dispose();
    loginController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repasswordController.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Zacznij rejestrację do filman.cc!",
                                  style: TextStyle(
                                    fontSize: 32,
                                  )),
                            ),
                            const SizedBox(height: 23.0),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Nazwa użytkownika",
                                border: OutlineInputBorder(),
                              ),
                              controller: loginController,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "E-mail",
                                border: OutlineInputBorder(),
                              ),
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Hasło",
                                border: OutlineInputBorder(),
                              ),
                              controller: passwordController,
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Powtórz hasło",
                                border: OutlineInputBorder(),
                              ),
                              controller: repasswordController,
                              onSubmitted: (final _) {
                                _submitForm();
                              },
                            ),
                            const SizedBox(height: 16.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton(
                                onPressed: () async {
                                  _submitForm();
                                },
                                child: const Text("Zarejestruj się"),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Masz już konto? ",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Zaloguj się",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          GoogleReCaptcha(
            controller: recaptchaV2Controller,
            url: "https://filman.cc/rejestracja",
            siteKey: "6LcQs24iAAAAALFibpEQwpQZiyhOCn-zdc-eFout",
          )
        ]));
  }
}
