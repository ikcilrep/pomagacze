import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomagacze/components/buttons.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:pomagacze/models/onboarding_section.dart';
import 'package:yaml/yaml.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _index = 0;

  List<OnboardingSection> _sections = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await rootBundle.loadString('assets/Onboarding.yaml');
    final mapData = loadYaml(data);
    setState(() {
      _sections = mapData['sections']
          .map<OnboardingSection>((x) => OnboardingSection.fromData(x))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(),
            _buildButtons(context),
          ],
        ),
      ),
    ));
  }

  Widget _buildSection() {
    if (_sections.isEmpty) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    var section = _sections[_index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(section.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  Row _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 110,
          child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _index = max(0, _index - 1);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 10),
                  Text('Wstecz'),
                ],
              )),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DotsIndicator(
              dotsCount: _sections.length,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                  activeColor: Theme.of(context).colorScheme.primary),
            )),
        SizedBox(
          width: 110,
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _index = min(_sections.length - 1, _index + 1);
                });
              },
              style: primaryButtonStyle(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Dalej'),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward),
                ],
              )),
        )
      ],
    );
  }
}
