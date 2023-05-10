import 'package:flutter/material.dart';

List<ProfileMenuItem> supportMenuList = [
  ProfileMenuItem(
    title: 'How To',
    subTitle: 'Ensure your harvesting address',
    icon: Icons.help,
  ),
  ProfileMenuItem(
    title: 'Contact Us',
    subTitle: 'System permission change',
    icon: Icons.contact_support,
  ),
  ProfileMenuItem(
    title: 'Privacy Policy',
    subTitle: 'Basic functional settings',
    icon: Icons.privacy_tip,
  ),
  ProfileMenuItem(
    title: 'Terms and Condition',
    subTitle: 'Take over the news in time',
    icon: Icons.meeting_room,
  ),
];

List<ProfileMenuItem> appInfoList = [
  ProfileMenuItem(
    title: 'Build name:',
    subTitle: 'Dunamis',
    icon: Icons.apps,
  ),
  ProfileMenuItem(
    title: 'App version:',
    subTitle: '1.7',
    icon: Icons.verified_sharp,
  ),
  ProfileMenuItem(
    title: 'Build Number:',
    subTitle: '0.1',
    icon: Icons.query_builder,
  ),
];

List<ProfileMenuItem> aboutUsList = [
  ProfileMenuItem(
    title: 'Owned By:',
    subTitle: 'Future Tech',
    icon: Icons.house,
  ),
  ProfileMenuItem(
    title: 'Developed By:',
    subTitle: 'Eden, --- and ---',
    icon: Icons.developer_board,
  ),
];
List<ProfileMenuItem> academicMenuList = [
  ProfileMenuItem(
    title: 'Owned By:',
    subTitle: 'Future Tech',
    icon: Icons.house,
  ),
  ProfileMenuItem(
    title: 'Developed By:',
    subTitle: 'Eden, --- and ---',
    icon: Icons.developer_board,
  ),

];

class ProfileMenuItem {
  String title;
  String subTitle;
  IconData? icon;
  ProfileMenuItem({this.icon, required this.title,required this.subTitle});
}


