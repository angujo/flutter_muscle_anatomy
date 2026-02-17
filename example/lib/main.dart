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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Row(
                children: [
                  _anatomyView(Male.front()
                      ..highlights([Muscle.biceps]), 'Male Front'),
                  _anatomyView(Male.back()
                    ..highlights([Muscle.trapezius]), 'Male back'),
                ],
              ),
              Row(
                children: [
                  _anatomyView(Female.front()
                      ..highlights([Muscle.rectusAbdominis]), 'Female Front'),
                  _anatomyView(Female.back()..highlights([Muscle.triceps]), 'Female Back'),
                ],
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
