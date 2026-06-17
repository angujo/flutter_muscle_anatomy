import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/body/body.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize the library's translator to use easy_localization
  MuscleAnatomyLocalization.translator =
      (key, {namedArgs}) => key.tr(namedArgs: namedArgs);

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

enum Gender { male, female }

class _MyHomePageState extends State<MyHomePage> {
  Gender _selectedGender = Gender.male;
  final Set<Muscle> _selectedMuscles = {};

  void _selectRandomMuscle() {
    final random = Random();
    final allMuscles = Muscle.values.toList();
    setState(() {
      _selectedMuscles.clear();
      // Select 4 random muscles
      for (int i = 0; i < 4; i++) {
        _selectedMuscles.add(allMuscles[random.nextInt(allMuscles.length)]);
      }
    });
  }

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
    final anatomyFactory = Anatomy(_selectedGender.name);

    return Scaffold(
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SegmentedButton<Gender>(
                      segments: [
                        ButtonSegment(
                          value: Gender.male,
                          label: Text('male'.localizedGender),
                          icon: const Icon(Icons.male),
                        ),
                        ButtonSegment(
                          value: Gender.female,
                          label: Text('female'.localizedGender),
                          icon: const Icon(Icons.female),
                        ),
                      ],
                      selected: {_selectedGender},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedGender = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _selectRandomMuscle,
                          icon: const Icon(Icons.shuffle),
                          label: Text('ui.random_muscles'.tr()),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _selectedMuscles.clear()),
                          icon: const Icon(Icons.clear_all),
                          label: Text('ui.clear'.tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _anatomyView(
                    anatomyFactory.front()..highlights(_selectedMuscles),
                    '${_selectedGender.name.localizedGender.toUpperCase()} ${BodyView.front.localizedName}',
                  ),
                  _anatomyView(
                    anatomyFactory.back()..highlights(_selectedMuscles),
                    '${_selectedGender.name.localizedGender.toUpperCase()} ${BodyView.back.localizedName}',
                  ),
                ],
              ),
              if (_selectedMuscles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 8,
                    children: _selectedMuscles
                        .map((m) => Chip(label: Text(m.localizedName)))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _anatomyView(MuscleAnatomy anatomy, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.string(anatomy.toString(), width: 200, height: 300),
        Text(name),
      ],
    );
  }
}
