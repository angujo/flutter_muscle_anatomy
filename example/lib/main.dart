
import 'package:easy_localization/easy_localization.dart';
import 'package:example/view_only.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';

import 'interactive_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize the library's translator to use easy_localization
  MuscleAnatomyLocalization.translator = (key, {namedArgs}) =>
      key.tr(namedArgs: namedArgs);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('pt'),
        Locale('hi'),
        Locale('ar'),
        Locale('fr'),
        Locale('id'),
        Locale('de'),
        Locale('ja'),
        Locale('ko'),
      ],
      path: 'packages/flutter_muscle_anatomy/assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'ui.app_title'.tr(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'ui.app_title'.tr()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'ui.choose_language'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView(
                  children: context.supportedLocales.map((locale) {
                    return ListTile(
                      title: Text('languages.${locale.languageCode}'.tr()),
                      subtitle: Text(locale.languageCode.toUpperCase()),
                      selected: context.locale == locale,
                      onTap: () {
                        context.setLocale(locale);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Center(child: Text(widget.title)),
            actions: [
              IconButton(
                onPressed: _showLanguagePicker,
                icon: const Icon(Icons.language),
                tooltip: 'ui.switch_language'.tr(),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'View Only'),
                Tab(text: 'Interactive'),
              ],
            ),
          ),
          body: const TabBarView(children: [ViewOnly(), InteractiveView()]),
        ),
      ),
    );
  }
}
