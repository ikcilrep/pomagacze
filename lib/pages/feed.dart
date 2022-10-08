import 'package:flutter/material.dart';
import 'package:pomagacze/components/request_card.dart';
import 'package:pomagacze/models/help_request.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildFAB(),
        _buildList(),
      ],
    );
  }

  Widget _buildFAB() {
    return Positioned(
        bottom: 15,
        right: 10,
        child: FloatingActionButton.extended(
            isExtended: true,
            label: Text('Dodaj zgłoszenie'),
            icon: Icon(Icons.add),
            onPressed: () {}));
  }

  Widget _buildList() {
    return ListView.builder(
        itemBuilder: (context, index) => RequestCard(HelpRequest.fromData(
            {'title': 'Hi', 'description': 'Lorem ipsum dolor sit amet...'})),
        itemCount: 2);
  }
}
