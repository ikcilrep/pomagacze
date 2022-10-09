import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/models/help_request.dart';

class HelpRequestDetail extends StatelessWidget {
  final HelpRequest _helpRequest;

  const HelpRequestDetail(this._helpRequest, {super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy - kk:mm');
    return Scaffold(
      appBar: AppBar(title: Text(_helpRequest.title)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
                title: const Text("Miejsce zbiórki"),
                subtitle: Text(_helpRequest.placeName!)),
            ListTile(
                title: const Text("Czas rozpoczęcia"),
                subtitle: Text(dateFormat.format(_helpRequest.dateStart!))),
            ListTile(
                title: const Text("Czas zakończenia"),
                subtitle: Text(dateFormat.format(_helpRequest.dateEnd!))),
            ListTile(
                title: const Text("Opis"),
                subtitle: Text(_helpRequest.description)),
          ],
        ),
      ),
    );
  }
}
