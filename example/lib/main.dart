import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/body/body.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Muscle Anatomy'),
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

  @override
  Widget build(BuildContext context) {
    final anatomyFactory = BodyAnatomy(_selectedGender.name);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
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
                      segments: const [
                        ButtonSegment(
                          value: Gender.male,
                          label: Text('Male'),
                          icon: Icon(Icons.male),
                        ),
                        ButtonSegment(
                          value: Gender.female,
                          label: Text('Female'),
                          icon: Icon(Icons.female),
                        ),
                      ],
                      selected: {_selectedGender},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedGender = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _selectRandomMuscle,
                          icon: const Icon(Icons.shuffle),
                          label: const Text('Random Muscles'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _selectedMuscles.clear()),
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear'),
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
                    '${_selectedGender.name.toUpperCase()} Front',
                  ),
                  _anatomyView(
                    anatomyFactory.back()..highlights(_selectedMuscles),
                    '${_selectedGender.name.toUpperCase()} Back',
                  ),
                ],
              ),
              if (_selectedMuscles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 8,
                    children: _selectedMuscles
                        .map((m) => Chip(label: Text(m.name)))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _anatomyView(BodyMuscleAnatomy anatomy, String name) {
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
