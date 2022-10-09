import 'package:flutter/material.dart';
import 'package:pomagacze/models/help_request.dart';

class RequestCard extends StatefulWidget {
  final HelpRequest request;

  const RequestCard(this.request, {Key? key}) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1.5,
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.request.title,
                        style: Theme.of(context).textTheme.bodyLarge),
                    Text(widget.request.description,
                        style: Theme.of(context).textTheme.bodyText2)
                  ],
                ))));
  }
}
