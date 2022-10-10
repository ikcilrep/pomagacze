import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/models/help_event.dart';

class EventDetails extends StatelessWidget {
  final HelpEvent _helpEvent;

  const EventDetails(this._helpEvent, {super.key});

  String get ageRangeString {
    if (_helpEvent.minimalAge == null && _helpEvent.maximalAge == null) {
      return "Brak";
    }

    if (_helpEvent.minimalAge == null) {
      return 'Maksymalnie ${_helpEvent.maximalAge} lat';
    }

    if (_helpEvent.maximalAge == null) {
      return 'Przynajmniej ${_helpEvent.minimalAge} lat';
    }

    return '${_helpEvent.minimalAge} - ${_helpEvent.maximalAge} lat';
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy - kk:mm');
    return Scaffold(
      appBar: AppBar(title: Text(_helpEvent.title)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
                title: const Text("Lokalizacja"),
                subtitle: Text(_helpEvent.placeName ?? '')),
            ListTile(
                title: const Text("Czas rozpoczęcia"),
                subtitle: Text(dateFormat
                    .format(_helpEvent.dateStart ?? DateTime.now()))),
            ListTile(
                title: const Text("Czas zakończenia"),
                subtitle: Text(
                    dateFormat.format(_helpEvent.dateEnd ?? DateTime.now()))),
            ListTile(
                title: const Text("Opis"),
                subtitle: Text(_helpEvent.description)),
            ListTile(
                title: const Text("Wymagany wiek wolontariusza"),
                subtitle: Text(ageRangeString)),
          ],
        ),
      ),
    );
  }
}
