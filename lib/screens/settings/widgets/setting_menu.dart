import 'package:flutter/material.dart';
import '../../root/root_screen.dart';
import '../../widgets/show_toast.dart';
import 'constant.dart';
import 'menu_item.dart';
import 'package:http/http.dart' as http;

class SettingMenu extends StatelessWidget {
  final Color theme;
  final int cat;

  const SettingMenu({required this.theme, required this.cat, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return Container();
    return Column(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (var menu in _getMenus(cat))
          GestureDetector(
            onTap: () {
              if (cat == 1) {
                _setupActions(_getMenus(cat).indexOf(menu), context);
              }
            },
            child: SettingMenuItem(
              menu: menu,
              theme: theme,
              cat: cat,
              position: _getMenus(cat).indexOf(menu),
            ),
          ),
      ],
    );
  }

  _setupActions(int position, BuildContext context) {
    switch (position) {
      case 4:
        gotoSignIn(context);
        break;
      case 4:
        gotoSignIn(context);
        break;
      case 4:
        gotoSignIn(context);
        break;
      case 4:
        gotoSignIn(context);
        break;
    }
  }

  _getMenus(int tar) {
    switch (tar) {
      case 1:
        return supportMenuList;
      case 2:
        return appInfoList;
      case 3:
        return aboutUsList;
    }
  }
}

class SettingMenuItem extends StatelessWidget {
  final ProfileMenuItem? menu;
  final Color theme;
  final int cat;
  final int position;

  const SettingMenuItem(
      {Key? key,
      this.menu,
      required this.theme,
      required this.cat,
      required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          /*boxShadow: [
            BoxShadow(
              color: theme.withOpacity(0.5),
              blurRadius: 3.0, // has the effect of softening the shadow
              spreadRadius: 2.0, // has the effect of extending the shadow
            ),
          ],*/
          //color: _themeColor(theme),
          borderRadius: BorderRadius.circular(
            5.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    /*padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme,
                    ),*/
                    child: Icon(
                      menu!.icon,
                      color: theme,
                    ),
                  ),
                  _setupMenus(cat),
                ],
              ),
              cat == 1
                  ? Icon(
                      Icons.chevron_right,
                      color: theme,
                    )
                  : cat == 2
                      ? Container(
                          child: position == 1
                              ? GestureDetector(
                                  onTap: () {
                                    ShowSnack(context,"Checking...").show();
                                  },
                                  child: Text(" Check for update",style: TextStyle(color: theme),))
                              : Container(),
                        )
                      : Container()
            ],
          ),
        ),
      ),
    );
  }

  Container _setupMenus(int tar) {
    if (tar == 1) {
      return Container(
        margin: const EdgeInsets.only(left: 15.0),
        child: Text(
          menu!.title,
          style: TextStyle(
            fontSize: 14.0,
            color: theme,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (tar == 2) {
      return Container(
        margin: const EdgeInsets.only(left: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menu!.title,
              style: TextStyle(
                fontSize: 14.0,
                //color: theme,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                menu!.subTitle,
                style: const TextStyle(
                  fontSize: 14.0,
                  //color: ColorProvider.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menu!.title,
              style: TextStyle(
                fontSize: 11.0,
                color: theme,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              menu!.subTitle,
              style: const TextStyle(
                fontSize: 14.0,
                //color: ColorProvider.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }
}
