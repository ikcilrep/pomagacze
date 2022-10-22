import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomagacze/models/onboarding_section.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yaml/yaml.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  final _duration = const Duration(milliseconds: 250);
  final _curve = Curves.linear;

  int _index = 0;
  List<OnboardingSection> _sections = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await rootBundle.loadString('assets/onboarding.yaml');
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
      child: _sections.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Expanded(
                    child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          setState(() {
                            _index = i;
                          });
                        },
                        children:
                            _sections.map((s) => _buildSection(s)).toList())),
                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _index,
                    count: _sections.length,
                    effect: WormEffect(
                        dotWidth: 8,
                        dotHeight: 8,
                        activeDotColor: Theme.of(context).colorScheme.primary,
                        dotColor: Colors.grey[300]!),
                    duration: const Duration(milliseconds: 250),
                  ),
                ),
                const SizedBox(height: 100),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25),
                  child: _buildButtons(context),
                ),
                const SizedBox(height: 40),
              ],
            ),
    ));
  }

  Widget _buildSection(OnboardingSection section) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/onboarding_icons/${section.image}',
            height: 250,
          ),
          const SizedBox(height: 50),
          Text(section.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Text('${section.subtitle}\n\n',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.black54))
        ],
      ),
    );
  }

  Row _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
            onPressed: () {
              _pageController.previousPage(duration: _duration, curve: _curve);
            },
            style: OutlinedButton.styleFrom(side: BorderSide.none),
            child: const Text('Wstecz', style: TextStyle(fontSize: 16))),
        ElevatedButton(
            onPressed: () async {
              if (_index >= _sections.length - 1) {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool(hasCompletedOnboardingKey, true);
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
                }
              } else {
                _pageController.nextPage(duration: _duration, curve: _curve);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.ease,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _index == _sections.length - 1 ? 'Zaczynamy!' : 'Dalej',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ))
      ],
    );
  }
}
