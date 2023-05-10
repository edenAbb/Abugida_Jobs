import 'package:et_job/utils/env/device.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme/theme_provider.dart';
import '../../settings/setting.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/painter.dart';

class AdminHome0 extends StatefulWidget{
static const routeName = "/admin_home";

const AdminHome0({Key? key})
: super(key: key);

@override
State<AdminHome0> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome0> {
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
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
      appBar: JobsAppBar(key: _appBar, title: "Dashboard", appBar: AppBar(), widgets: [
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
                height: 270,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 950,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 0,
                color: Theme.of(context).primaryColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            //padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            //color: ColorProvider.primaryColor,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0,bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor.withOpacity(0.4),
                          shape: BoxShape.rectangle,
                        ),
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.group,
                                    size: 20,color:Colors.white),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Vacancies and users",
                                    style: TextStyle(color:Colors.white,
                                        fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("*",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor.withOpacity(0.4),
                            shape: BoxShape.rectangle,
                          ),
                          child: SizedBox(
                            height: 170,
                            width: MediaQuery.of(context).size.width * 0.47,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.manage_accounts_outlined,
                                                size: 20,color:Colors.yellow),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Open",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("0",
                                              style: TextStyle(color:Colors.white,
                                                  fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.manage_accounts_outlined,
                                                size: 20,color:Colors.red),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Closed",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("0",
                                              style: TextStyle(color:Colors.white,
                                                  fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.manage_accounts_outlined,
                                                size: 20,color:Colors.green),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Completed",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("0",
                                              style: TextStyle(color:Colors.white,
                                                  fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                    height: 5,
                                    thickness: 2,
                                    color: Colors.white
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Jobs",
                                    style: TextStyle(color:Colors.white,
                                        fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor.withOpacity(0.4),
                            shape: BoxShape.rectangle,
                          ),
                          child: SizedBox(
                            height: 170,
                            width: MediaQuery.of(context).size.width * 0.47,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.person,
                                                size: 20,color:Colors.white),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Employee",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("0",
                                              style: TextStyle(color:Colors.white,
                                                  fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.work,
                                                size: 20,color:Colors.white),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Employer",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("0",
                                              style: TextStyle(color:Colors.white,
                                                  fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.admin_panel_settings,
                                                size: 20,color:Colors.white),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Admin",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("0",
                                              style: TextStyle(color:Colors.white,
                                                  fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                    height: 5,
                                    thickness: 2,
                                    color: Colors.white
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Users",
                                    style: TextStyle(color:Colors.white,
                                        fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        shape: BoxShape.rectangle,
                      ),
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.money,
                                    size: 20,color:Colors.white),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Payments",
                                    style: TextStyle(color:Colors.white,
                                        fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("*",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              shape: BoxShape.rectangle,
                            ),
                            child: SizedBox(
                              height: 170,
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                      height: 5,
                                      thickness: 2,
                                      color: Colors.white
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("Jobs",
                                      style: TextStyle(color:Colors.white,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              shape: BoxShape.rectangle,
                            ),
                            child: SizedBox(
                              height: 170,
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                      height: 5,
                                      thickness: 2,
                                      color: Colors.white
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("Users",
                                      style: TextStyle(color:Colors.white,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor.withOpacity(0.4),
                          shape: BoxShape.rectangle,
                        ),
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.manage_accounts_outlined,
                                    size: 20,color:Colors.white),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Active",
                                    style: TextStyle(color:Colors.white,
                                        fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("0",
                                  style: TextStyle(color:Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              shape: BoxShape.rectangle,
                            ),
                            child: SizedBox(
                              height: 170,
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                      height: 5,
                                      thickness: 2,
                                      color: Colors.white
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("Jobs",
                                      style: TextStyle(color:Colors.white,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              shape: BoxShape.rectangle,
                            ),
                            child: SizedBox(
                              height: 170,
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.manage_accounts_outlined,
                                                  size: 20,color:Colors.white),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Active",
                                                  style: TextStyle(color:Colors.white,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("0",
                                                style: TextStyle(color:Colors.white,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                      height: 5,
                                      thickness: 2,
                                      color: Colors.white
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("Users",
                                      style: TextStyle(color:Colors.white,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}