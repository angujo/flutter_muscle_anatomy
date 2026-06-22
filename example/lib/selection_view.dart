import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muscle_anatomy/core/core.dart';

enum Gender { male, female }

class SelectionView extends StatefulWidget {
  final Widget Function(
    Gender gender,
    Set<(Muscle, MuscleSide)> selectedMuscles,
    void Function(Set<(Muscle, MuscleSide)>) onMusclesChanged,
  )
  child;

  const SelectionView({super.key, required this.child});

  @override
  State<SelectionView> createState() => _SelectionViewState();
}

class _SelectionViewState extends State<SelectionView> {
  Gender _selectedGender = Gender.male;
  final Set<(Muscle, MuscleSide)> _selectedMuscles = {};

  void _onMusclesChanged(Set<(Muscle, MuscleSide)> muscles) {
    setState(() {
      _selectedMuscles.clear();
      _selectedMuscles.addAll(muscles);
    });
  }

  void _selectRandomMuscle() {
    final random = Random();
    final allMuscles = Muscle.values.toList();
    final newSelection = <(Muscle, MuscleSide)>{};
    // Select 7 random muscles
    for (int i = 0; i < 7; i++) {
      newSelection.add((
        allMuscles[random.nextInt(allMuscles.length)],
        MuscleSide.values[random.nextInt(MuscleSide.values.length)],
      ));
    }
    _onMusclesChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    onPressed: () => _onMusclesChanged({}),
                    icon: const Icon(Icons.clear_all),
                    label: Text('ui.clear'.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
        widget.child(_selectedGender, _selectedMuscles, _onMusclesChanged),
        if (_selectedMuscles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8,
              children: _selectedMuscles
                  .map(
                    (m) => Chip(
                      label: Text(
                        "${m.$1.localizedName} (${m.$2.name})",
                        style: TextStyle(fontSize: 10),
                      ),
                      labelPadding: EdgeInsets.symmetric(
                        horizontal: .1,
                        vertical: 1,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
