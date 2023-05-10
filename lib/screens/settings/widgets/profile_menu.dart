import 'package:flutter/material.dart';
import '../../root/root_screen.dart';
import 'constant.dart';
import 'menu_item.dart';
import 'package:http/http.dart' as http;

class ProfileMenu extends StatelessWidget {
  final Color theme;
  const ProfileMenu({required this.theme, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return Container();
    return Column(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (var menu in supportMenuList)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: (){
                _setupActions(4/*profileMenuList.indexOf(menu)*/,context);
              },
              child: CMenuItem(
                menu: menu,theme: theme,
              ),
            ),
          ),
      ],
    );
  }
  _setupActions(int position,BuildContext context){
    switch(position){
      case 4:
        gotoSignIn(context);
        //_logout(context);
        break;
    }
  }
}