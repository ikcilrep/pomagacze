import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomagacze/models/read_learn_instructions.dart';
import 'package:yaml/yaml.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await rootBundle.loadString('assets/LearnInstructions.yaml');
    final mapData = loadYaml(data);
    setState(() {
      sections = mapData['sections']
          .map<FAQSection>((x) => FAQSection.fromData(x))
          .toList();
    });
  }

  List<FAQSection> sections = [];

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return DefaultTabController(
      length: sections.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Jak pomagać?'),
          bottom: TabBar(
            tabs: [for (var x in sections) Tab(child: Text(x.title))],
            labelColor: Theme.of(context).colorScheme.onSurface,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: TabBarView(
          children: [
            for (var s in sections)
              Container(
                child: _buildSection(s),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(FAQSection section) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                section.children[index].isExpanded = !isExpanded;
              });
            },
            children: [
              for (var x in section.children)
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(x.title),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 16),
                        ),
                    body: ListTile(
                      title: Text(
                        x.body,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    isExpanded: x.isExpanded,
                    canTapOnHeader: true)
            ]),
      ),
    );
  }
}
