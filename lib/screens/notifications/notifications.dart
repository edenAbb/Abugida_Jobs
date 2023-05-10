import 'package:et_job/cubits/notification/notification_cubit.dart';
import 'package:et_job/cubits/notification/notification_state.dart';
import 'package:et_job/models/job.dart';
import 'package:et_job/models/notification.dart';
import 'package:et_job/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/data.dart';
import '../../repository/account.dart';
import '../../utils/env/device.dart';
import '../../utils/env/session.dart';
import '../root/root_screen.dart';
import '../settings/setting.dart';
import '../widgets/app_bar.dart';
import '../widgets/list_view.dart';
import '../widgets/show_dialog.dart';

import 'package:http/http.dart' as http;
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _appBar = GlobalKey<FormState>();
  @override
  void initState() {
    _loadProfile();
    _initDataRequest();
    super.initState();
  }

  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }
  _initDataRequest() {
    DataTar dataTar;
    dataTar = DataTar(itemId: 1,offset: 0);
    context.read<NotificationCubit>().loadNotification(dataTar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "Notification", appBar: AppBar(), widgets: [
        IconButton(onPressed: _openProfile,
            icon: const Icon(Icons.settings))
      ]),
      body: Stack(
        children: [
          BlocBuilder<NotificationCubit, NotificationState>(builder: (context, state) {
            if (state is LoadingNotification) {
              return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ));
            }
            if (state is NotificationLoadingFailed) {
              Session().logSession("VacancyLoadingFailed", state.error);
              if (state.error == 'end-session') {
                gotoSignIn(context);
              }
              return Center(child: Text(state.error));
            }
            if (state is NotificationLoaded) {
              Session().logSession(
                  "ItemSize", state.notification.notifications.length.toString());
              return notificationHolder(state.notification.notifications);
            }
            return const Center(child: Text("No Notification"));
          }),
        ],
      ),
    );
  }

  bool _isLoadMoreRunning = false;
  notificationHolder(List<JNotification> notification) {
    return notification.isNotEmpty
        ? Column(
      children: [
        proLoaded ? Expanded(
          child: ListView.builder(
            //controller: _controller,
              itemCount: notification.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, item) {
                return NotificationCard(notification: notification[item],
                    theme:Theme.of(context).primaryColor);
              }),
        ): Container(),
        // when the _loadMore function is running
        if (_isLoadMoreRunning == true)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    )
        : const Center(child: Text("No Vacancy found"));
  }

  var proLoaded = false;
  late User user;
  var auth = AccountRepository(httpClient: http.Client());

  _loadProfile() {
    auth.getUserData().then((value) => {
      setState(() {
        user = value;
        proLoaded = true;
      })
    });
  }
}
