import 'package:flutter/material.dart';

import '../../utils/theme/colors.dart';


class Circles{
  BuildContext context;
  Circles(this.context);
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;
  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;
  Positioned topLeft(){
    return Positioned(
      left: -getBigDiameter(context) / 6,
      top: -getBigDiameter(context) / 6,
      child: Container(
        child: const Center(
          child: Text(
            "Et Jobs",
            style: TextStyle(
                fontFamily: "Pacifico",
                fontSize: 40,
                color: Colors.white),
          ),
        ),
        width: getBigDiameter(context),
        height: getBigDiameter(context),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor.withOpacity(0.5),
                  Theme.of(context).primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
      ),
    );
  }
  Positioned topRight(){
    return Positioned(
      right: -getSmallDiameter(context) / 3,
      top: -getSmallDiameter(context) / 3,
      child: Container(
        width: getSmallDiameter(context),
        height: getSmallDiameter(context),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
      ),
    );
  }
  Positioned bottomRight(){
    return Positioned(
      right: -getBigDiameter(context) / 2,
      bottom: -getBigDiameter(context) / 2,
      child: Container(
        width: getBigDiameter(context),
        height: getBigDiameter(context),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withOpacity(0.3)),
      ),
    );
  }
  Stack circleProvider(String text){
    return Stack(
      children: <Widget>[
        Circles(context).topRight(),
        Circles(context).topLeft(),
        Circles(context).bottomRight(),
      ],
    );
  }
}