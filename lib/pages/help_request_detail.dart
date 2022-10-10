import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/models/help_request.dart';

class HelpRequestDetail extends StatelessWidget {
  final HelpRequest _helpRequest;

  const HelpRequestDetail(this._helpRequest, {super.key});

  String get ageRangeString {
    if (_helpRequest.minimalAge == null && _helpRequest.maximalAge == null) {
      return "Brak";
    }

    if (_helpRequest.minimalAge == null) {
      return 'Maksymalnie ${_helpRequest.maximalAge} lat';
    }

    if (_helpRequest.maximalAge == null) {
      return 'Przynajmniej ${_helpRequest.minimalAge} lat';
    }

    return '${_helpRequest.minimalAge} - ${_helpRequest.maximalAge} lat';
  }

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
                subtitle: Text(_helpRequest.placeName ?? '')),
            ListTile(
                title: const Text("Czas rozpoczęcia"),
                subtitle: Text(dateFormat
                    .format(_helpRequest.dateStart ?? DateTime.now()))),
            ListTile(
                title: const Text("Czas zakończenia"),
                subtitle: Text(
                    dateFormat.format(_helpRequest.dateEnd ?? DateTime.now()))),
            ListTile(
                title: const Text("Opis"),
                subtitle: Text(_helpRequest.description)),
            ListTile(
                title: const Text("Wymagany wiek wolontariusza"),
                subtitle: Text(ageRangeString)),
          ],
        ),
      ),
    );
  }
}
