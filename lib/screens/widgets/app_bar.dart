
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class JobsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.red;
  final String title;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const JobsAppBar({required Key key,
    required this.title,
    required this.appBar,
    required this.widgets})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0.5,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
      ).tr(),
      centerTitle: false,
      actionsIconTheme: const IconThemeData(color: Colors.white),
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}