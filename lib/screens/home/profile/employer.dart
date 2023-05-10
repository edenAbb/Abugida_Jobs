
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme/theme_provider.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';

class EmployerProfile extends StatefulWidget{
  static const routeName = "/admin_home";

  const EmployerProfile({Key? key})
      : super(key: key);

  @override
  State<EmployerProfile> createState() => _EmployerProfileState();
}

class _EmployerProfileState extends State<EmployerProfile> {
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }
  _openProfile(){
    Navigator.pushNamed(context, SettingScreen.routeName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobsAppBar(key: _appBar, title: "Profile",
          appBar: AppBar(), widgets: [
            IconButton(onPressed: _openProfile,
                icon: const Icon(Icons.settings))
          ]),
      body: SizedBox(
        //padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        //color: ColorProvider.primaryColor,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(

        ),
      ),
    );
  }

}