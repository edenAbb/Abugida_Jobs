import 'package:easy_localization/easy_localization.dart';
import 'package:et_job/cubits/account/account_cubit.dart';
import 'package:et_job/cubits/account/account_state.dart';
import 'package:et_job/screens/root/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import '../../models/data.dart';
import '../../models/user.dart';
import '../../repository/account.dart';
import '../../routes/shared.dart';
import '../../utils/env/device.dart';
import '../../utils/env/session.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/theme_provider.dart';
import '../account/update_account.dart';
import '../widgets/app_bar.dart';
import '../widgets/painter.dart';
import '../widgets/show_toast.dart';
import 'widgets/profile_detail.dart';
import 'widgets/profile_image.dart';
import 'widgets/setting_menu.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = "/setting";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _appBar = GlobalKey<FormState>();

  late ThemeProvider themeProvider;

  late User user;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    //_loadProfile();
    _initDataRequest();
    super.initState();
  }
  _initDataRequest() {
    DataTar dataTar;
    dataTar = DataTar(itemId: 2,offset: 0);
    context.read<AccountCubit>().loadProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: JobsAppBar(
            key: _appBar,
            title: "settings",
            appBar: AppBar(),
            widgets: const []),
        body: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
      if (state is LoadOnProcess) {
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
      if (state is LoadFailed) {
        Session().logSession("VacancyLoadingFailed", state.error);
        if (state.error == 'end-session') {
          gotoSignIn(context);
        }
        return Center(child: Text(state.error));
      }
      if (state is LoadedSuccessfully) {
        return Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 160,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 150,
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
            SingleChildScrollView(
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  profile(state.user),
                  SizedBox(
                    height: Device.deviceScreen(context) * 0.01,
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getMenuTitle("Support"),
                          SettingMenu(
                              theme: Theme.of(context).primaryColor, cat: 1),
                        ],
                      )),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getMenuTitle("App info"),
                          SettingMenu(
                              theme: Theme.of(context).primaryColor, cat: 2),
                        ],
                      )),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getMenuTitle("About us"),
                          SettingMenu(
                              theme: Theme.of(context).primaryColor, cat: 3),
                        ],
                      )),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        _getMenuTitle("Select Theme"),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(0);
                                    setState(() {});
                                  },
                                  child: Container(
                                    //color: ColorProvider().primaryDeepOrange,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: ColorProvider().primaryDeepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(1);
                                    setState(() {});
                                  },
                                  child: Container(
                                    //color: ColorProvider().primaryDeepBlue,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: ColorProvider().primaryDeepBlue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(2);
                                    setState(() {});
                                  },
                                  child: Container(
                                    //color: ColorProvider().primaryDeepTeal,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: ColorProvider().primaryDeepRed,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(3);
                                    setState(() {});
                                  },
                                  child: Container(
                                    //color: ColorProvider().primaryDeepTeal,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: ColorProvider().primaryDeepTeal,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              /*Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    themeProvider.changeTheme(4);
                                    setState(() {});
                                  },
                                  child: Container(
                                    //color: ColorProvider().primaryDeepTeal,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: ColorProvider().primaryDeepBlack,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LikeOrNot(onLike: onLike, onDislike: onDislike),
                      ),
                    ),
                    */
                  SizedBox(
                    height: Device.deviceScreen(context) * 0.02,
                  ),
                  /*SizedBox(
                        height: Device.deviceScreen(context) * 0.15,
                        child: ProfileCategories()),
                    */

                  Center(
                      child: ElevatedButton(
                          onPressed: () {
                            gotoSignIn(context);
                          },
                          child: const Text("Logout"))),
                ],
              ),
            )
          ],
        );
      }
      return Container(child: Text("Unabale to load data"));
    })
    );
  }

  _getMenuTitle(String menuTitle) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              /*blurRadius: 3.0,
              // has the effect of softening the shadow
              spreadRadius:
              2.0, */ // has the effect of extending the shadow
            ),
          ],
          //color: _themeColor(theme),
          borderRadius: BorderRadius.circular(
            5.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(menuTitle),
        ),
      ),
    );
  }

  var proLoaded = false;

  _loadProfile() {
    var auth = AccountRepository(httpClient: http.Client());
    //UserProvider userProvider = UserProvider(authRepository: auth);
    auth.getUserData().then((value) => {
          setState(() {
            user = value;
            proLoaded = true;
          })
        });
  }
  Card profile(User user){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                ProfileImage(
                    height: 60.0,
                    width: 60.0,
                    profileUrl: "${user.profileImage}"),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          //color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 13.0,
                      ),
                      Text(
                        user.role.name,
                        style: const TextStyle(
                          //color: Colors.white70,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {/*
                        Navigator.pushNamed(context, ChangePassword.routeName,
                            arguments: ChangePasswordArgs(isOnline: true));
*/
                      Navigator.pushNamed(context, UpdateAccount.routeName,
                          arguments: UpdateAccountArgs(isOnline: true))
                          .then((value) => {
                            _initDataRequest()
                      });
                    },
                    icon: Icon(
                      Icons.border_color,
                      size: 20.0,
                      color: themeProvider.getColor,
                    ))
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            _innerMenu(Icons.phone,
                user.phoneNumber,
                themeProvider.getColor),
            SizedBox(
              height: 15.0,
            ),
            _innerMenu(Icons.email,
                user.email ?? "Unavailable",
                themeProvider.getColor),
            SizedBox(
              height: 15.0,
            ),
            _innerMenu(Icons.male,
                user.gender ?? "",
                themeProvider.getColor),
            SizedBox(
              height: 15.0,
            ),
            // _innerMenu(Icons.date_range,
            //     user.role.name,
            //     themeProvider.getColor),
            /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(flex: 8,),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, UpdateAccount.routeName,
                          arguments: UpdateAccountArgs(isOnline: true));
                    }, child: Text("Update",style: TextStyle(fontSize: 12),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, ChangePassword.routeName,
                          arguments: ChangePasswordArgs(isOnline: true));
                    }, child: Text("Change Password",style: TextStyle(fontSize: 12),)),
                  ),
                ],
              ),
              */
          ],
        ),
      ),
    );
  }
  _innerMenu(IconData icon, String name,Color theme){
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Icon(icon,color: theme),
        ),
        Padding(
          padding: EdgeInsets.all(3.0),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
