
import 'package:flutter/material.dart';

class Device{
  static double deviceScreen(BuildContext context){
    var height = MediaQuery.of(context).size.height;
    var statusBar = MediaQuery.of(context).viewPadding.top;
    return height - statusBar;
  }
  static double appBar(){
    var height = AppBar().preferredSize.height;
    return height;
  }
  static Size appBarSize(){
    var height = AppBar().preferredSize;
    return height;
  }

  static body(BuildContext context){
    var appB = appBar();
    var bottom = bottomNav(context);
    var ext = appB + bottom;
    return deviceScreen(context) - ext;
  }
  static double bottomNav(BuildContext context){
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return bottomPadding;
  }
}