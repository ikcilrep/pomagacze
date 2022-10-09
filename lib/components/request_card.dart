import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/models/help_request.dart';
import 'package:pomagacze/pages/help_request_detail.dart';

class RequestCard extends StatefulWidget {
  final HelpRequest request;

  const RequestCard(this.request, {Key? key}) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) =>
            HelpRequestDetail(widget.request),
        tappable: true,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        closedElevation: 1.5,
        // transitionDuration: const Duration(seconds: 2),
        closedBuilder: (_, openContainer) {
          return Card(
              elevation: 1.5,
              child: InkWell(
                  borderRadius: BorderRadius.circular(10),
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
        });
  }
}
