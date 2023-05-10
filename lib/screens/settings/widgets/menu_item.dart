
import '../../../utils/env/device.dart';
import 'constant.dart';
import 'package:flutter/material.dart';

class CMenuItem extends StatelessWidget {
  final ProfileMenuItem? menu;
  final Color theme;
  const CMenuItem({this.menu,required this.theme,position});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
      child: Container(
        height: Device.deviceScreen(context) * 0.09,
        decoration: BoxDecoration(
          /*boxShadow: [
            BoxShadow(
              color: Color(0xFFD1DCFF),
              blurRadius: 3.0, // has the effect of softening the shadow
              spreadRadius: 2.0, // has the effect of extending the shadow
            ),
          ],*/
          //color: _themeColor(theme),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme,
                    ),
                    child: Icon(
                      menu!.icon,
                      color: theme,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          menu!.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            //color: ColorProvider.primaryTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          menu!.subTitle,
                          style: TextStyle(
                            fontSize: 14.0,
                            //color: profile_item_color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Icon(
                Icons.chevron_right,
                color: theme,
              )
            ],
          ),
        ),
      ),
    );
  }
}
