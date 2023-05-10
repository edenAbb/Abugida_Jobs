import 'package:et_job/cubits/user/user_cubit.dart';
import 'package:et_job/cubits/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../models/data.dart';
import '../../../models/user.dart';
import '../../../repository/account.dart';
import '../../../utils/env/device.dart';
import '../../../utils/env/session.dart';
import '../../../utils/theme/theme_provider.dart';
import '../../root/root_screen.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/list_view.dart';
import '../../widgets/painter.dart';
import '../../widgets/show_dialog.dart';

import 'package:http/http.dart' as http;
class AppUsersScreen extends StatefulWidget{
  static const routeName = "/admin_home";

  const AppUsersScreen({Key? key})
      : super(key: key);

  @override
  State<AppUsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<AppUsersScreen> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
    //_loadProfile();
    _initDataRequest();
  }
  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }

  _initDataRequest() {
    DataTar dataTar;
    dataTar = DataTar(offset: 0);
    context.read<UserCubit>().loadUser(dataTar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "App Users", appBar: AppBar(), widgets: [
        IconButton(onPressed: _openProfile,
            icon: const Icon(Icons.settings))
      ]),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 170,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 950,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                color: Theme.of(context).primaryColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            if (state is LoadingUser) {
              return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: themeProvider.getColor,
                    ),
                  ));
            }
            if (state is UserLoadingFailed) {
              Session().logSession("VacancyLoadingFailed", state.error);
              if (state.error == 'end-session') {
                gotoSignIn(context);
              }
              return Center(child: Text(state.error));
            }
            if (state is UserLoaded) {
              Session().logSession(
                  "ItemSize", state.users.users.length.toString());
              return vacancyHolder(state.users.users);
            }
            return const Center(child: Text("No Vacancy Available"));
          }),
        ],
      ),
    );
  }

  bool _isLoadMoreRunning = false;
  vacancyHolder(List<User> users) {
    return users.isNotEmpty
        ? Column(
      children: [
        Expanded(
          child: ListView.builder(
            //controller: _controller,
              itemCount: users.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, item) {
                return UserCard(user: users[item]);
              }),
        ),
        // when the _loadMore function is running
        if (_isLoadMoreRunning == true)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Center(
              child: CircularProgressIndicator(
                color: themeProvider.getColor,
              ),
            ),
          ),
      ],
    )
        : const Center(child: Text("No Users found"));
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