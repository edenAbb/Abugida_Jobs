import 'package:flutter/material.dart';

import 'constant.dart';

class ProfileImage extends StatelessWidget {
  final double height, width;
  final Color color;
  String profileUrl;
  ProfileImage(
      {required this.profileUrl,this.height = 100.0, this.width = 100.0, this.color = Colors.white});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: NetworkImage(profileUrl),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: color,
          width: 3.0,
        ),
      ),
    );
  }
}
