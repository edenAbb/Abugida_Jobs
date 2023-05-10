import 'package:flutter/material.dart';

import '../../utils/theme/colors.dart';

class ShowSnack{
  BuildContext context;
  String message;
  ShowSnack(this.context,this.message);
  void show(){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        content: Text(
            message,style: const TextStyle(color: Colors.white)
        ),backgroundColor: Theme.of(context).primaryColor));
  }
}