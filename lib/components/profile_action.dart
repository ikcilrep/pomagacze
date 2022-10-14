import 'package:flutter/material.dart';

class ProfileAction extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? title;
  final Widget? icon;

  const ProfileAction({Key? key, this.onTap, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: ListTile(
          onTap: onTap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          title: title,
          trailing: icon,
        ),
      ),
    );
  }
}
