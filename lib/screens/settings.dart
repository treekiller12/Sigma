import 'package:unofficial_filman_client/notifiers/settings.dart';
import 'package:unofficial_filman_client/utils/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dpad_container/dpad_container.dart'; // import dpad_container

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TitleDisplayType? selectedTitleType;

  @override
  void initState() {
    super.initState();
    selectedTitleType = Provider.of<SettingsNotifier>(context, listen: false).titleDisplayType;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final TitleDisplayType? titleType =
        Provider.of<SettingsNotifier>(context).titleDisplayType;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ustawienia"),
      ),
      body: DPadNavigation( // DPadNavigation do obsługi DPAD
        child: ListView(
          children: [
            ListTile(
              title: const Text("Tryb ciemny"),
              onTap: () {
                Provider.of<SettingsNotifier>(context, listen: false).setTheme(
                    Theme.of(context).brightness == Brightness.light
                        ? ThemeMode.dark
                        : ThemeMode.light);
              },
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (final bool value) {
                  Provider.of<SettingsNotifier>(context, listen: false)
                      .setTheme(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text("Wyświetlanie tytułów"),
              subtitle: Text(
                  "Tytuły na filamn.cc są dzielone '/' na człony, w zależności od języka. Wybierz, które tytuły chcesz wyświetlać:"),
            ),
            DPadSelectableWidget<TitleDisplayType>( // Używamy DPadSelectableWidget do obsługi selekcji
              value: TitleDisplayType.all,
              selectedValue: selectedTitleType,
              onSelected: (final TitleDisplayType value) {
                setState(() {
                  selectedTitleType = value;
                });
                Provider.of<SettingsNotifier>(context, listen: false)
                    .setTitleDisplayType(value);
              },
              child: RadioListTile<TitleDisplayType>(
                title: const Text("Cały tytuł"),
                value: TitleDisplayType.all,
                groupValue: titleType,
                onChanged: (final TitleDisplayType? value) {
                  if (value != null) {
                    Provider.of<SettingsNotifier>(context, listen: false)
                        .setTitleDisplayType(value);
                  }
                },
              ),
            ),
            DPadSelectableWidget<TitleDisplayType>(
              value: TitleDisplayType.first,
              selectedValue: selectedTitleType,
              onSelected: (final TitleDisplayType value) {
                setState(() {
                  selectedTitleType = value;
                });
                Provider.of<SettingsNotifier>(context, listen: false)
                    .setTitleDisplayType(value);
              },
              child: RadioListTile<TitleDisplayType>(
                title: const Text("Pierwszy człon tytułu"),
                value: TitleDisplayType.first,
                groupValue: titleType,
                onChanged: (final TitleDisplayType? value) {
                  if (value != null) {
                    Provider.of<SettingsNotifier>(context, listen: false)
                        .setTitleDisplayType(value);
                  }
                },
              ),
            ),
            DPadSelectableWidget<TitleDisplayType>(
              value: TitleDisplayType.second,
              selectedValue: selectedTitleType,
              onSelected: (final TitleDisplayType value) {
                setState(() {
                  selectedTitleType = value;
                });
                Provider.of<SettingsNotifier>(context, listen: false)
                    .setTitleDisplayType(value);
              },
              child: RadioListTile<TitleDisplayType>(
                title: const Text("Drugi człon tytułu"),
                value: TitleDisplayType.second,
                groupValue: titleType,
                onChanged: (final TitleDisplayType? value) {
                  if (value != null) {
                    Provider.of<SettingsNotifier>(context, listen: false)
                        .setTitleDisplayType(value);
                  }
                },
              ),
            ),
            Consumer<SettingsNotifier>(
                builder: (final context, final settings, final child) =>
                    ListTile(
                        subtitle: RichText(
                            text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Przykładowy tytuł: ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            text: getDisplayTitle(
                                "Szybcy i wściekli / The Fast and the Furious",
                                settings))
                      ],
                    )))),
          ],
        ),
      ),
    );
  }
}
