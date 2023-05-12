
import 'package:flutter/material.dart';

import '../../routes/shared.dart';
import '../widgets/app_bar.dart';
import '../../models/notification.dart';

class ViewNTFS extends StatefulWidget {
  static const routeName = "/view_ntfs";
  final NtfsDetailArgs args;
  const ViewNTFS({Key? key, required this.args}) : super(key: key);

  @override
  State<ViewNTFS> createState() => _ViewNTFSState();
}

class _ViewNTFSState extends State<ViewNTFS> {
  final _appBar = GlobalKey<FormState>();
  late JNotification notification;
  @override
  void initState() {
    notification = widget.args.notification;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: notification.title,
          appBar: AppBar(), widgets: []),
      body: Container(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
                child: Text(
                  notification.body,
                  style: TextStyle(fontSize: 15),
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text((notification.date)),
          )
        ]),
      ),
    );
  }
}
