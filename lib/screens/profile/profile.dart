import 'package:easy_localization/easy_localization.dart';
import 'package:et_job/screens/root/root_screen.dart';
import 'package:et_job/screens/settings/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import '../../cubits/account/account_cubit.dart';
import '../../models/user.dart';
import '../../repository/account.dart';
import '../../utils/env/device.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/theme_provider.dart';
import '../settings/widgets/profile_detail.dart';
import '../settings/widgets/setting_menu.dart';
import '../widgets/app_bar.dart';
import '../widgets/painter.dart';
import '../widgets/show_toast.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/setting";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    context.read<AccountCubit>().loadProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: JobsAppBar(
            key: _appBar,
            title: "Profile",
            appBar: AppBar(),
            widgets: const []),
        body: Stack(
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
                  Profile(user,1),
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
                          _getMenuTitle("Educational Background"),
                          menuIt("Academic award", "subTitle"),
                          // SettingMenu(
                          //     theme: Theme.of(context).primaryColor, cat: 3),
                          //
                        ],
                      )),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getMenuTitle("Your Current File"),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("View your cv..."),
                          ),
                          Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    ShowSnack(context,
                                        "this feature is available soon")
                                        .show();
                                  },
                                  child: Text("View Files"))),

                        _getMenuTitle("Upload Your File"),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Allow you to upload cv and related file"),
                        ),
                        Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  ShowSnack(context,
                                      "this feature is available soon")
                                      .show();
                                },
                                child: Text("Upload Files")))
                        ],

                      )),

                  SizedBox(
                    height: Device.deviceScreen(context) * 0.02,
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getMenuTitle("Experience"),
                          SettingMenu(
                              theme: Theme.of(context).primaryColor, cat: 3),
                        ],
                      )),
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
            ),
          ],
        ));
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
  SettingMenuItem menuIt(String title, String subTitle){
    var item = ProfileMenuItem(title: title, subTitle: subTitle);
    return SettingMenuItem(theme: Theme.of(context).primaryColor,
        cat: 3, position: 2,menu: item);
  }
}
