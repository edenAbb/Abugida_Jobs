
import 'package:et_job/models/user.dart';
import 'package:provider/provider.dart';
import '../../../routes/shared.dart';
import 'package:flutter/material.dart';

import '../../../services/helper/header.dart';
import '../../../utils/env/session.dart';
import '../../../utils/theme/theme_provider.dart';
import '../../account/update_account.dart';
import 'profile_image.dart';

class Profile extends StatelessWidget {
  final User user;
  final int tar;
  const Profile(this.user, this.tar,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMale = user.gender == "1";
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    Size deviceSize = MediaQuery.of(context).size;
    Session().logSession("profileUrl",
        "${user.profileImage}");
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ProfileImage(
                      height: 60.0,
                      width: 60.0,
                      profileUrl: "${user.profileImage}"),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            //color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 13.0,
                        ),
                        Text(
                          user.role.name,
                          style: const TextStyle(
                            //color: Colors.white70,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  tar == 0 ? IconButton(
                      onPressed: () {/*
                        Navigator.pushNamed(context, ChangePassword.routeName,
                            arguments: ChangePasswordArgs(isOnline: true));
*/
                        Navigator.pushNamed(context, UpdateAccount.routeName,
                            arguments: UpdateAccountArgs(isOnline: true));
                      },
                      icon: Icon(
                        Icons.border_color,
                        size: 20.0,
                        color: themeProvider.getColor,
                      )):Container()
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              _innerMenu(Icons.phone,
                  user.phoneNumber,
                  themeProvider.getColor),
              SizedBox(
                height: 15.0,
              ),
              _innerMenu(Icons.email,
                  user.email ?? "Unavailable",
                  themeProvider.getColor),
              SizedBox(
                height: 15.0,
              ),
              _innerMenu(Icons.male,
                  user.gender ?? "",
                  themeProvider.getColor),
              SizedBox(
                height: 15.0,
              ),
              // _innerMenu(Icons.date_range,
              //     user.role.name,
              //     themeProvider.getColor),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(flex: 8,),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, UpdateAccount.routeName,
                          arguments: UpdateAccountArgs(isOnline: true));
                    }, child: Text("Update",style: TextStyle(fontSize: 12),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, ChangePassword.routeName,
                          arguments: ChangePasswordArgs(isOnline: true));
                    }, child: Text("Change Password",style: TextStyle(fontSize: 12),)),
                  ),
                ],
              ),
              */
            ],
          ),
      ),
    );
  }
  _innerMenu(IconData icon, String name,Color theme){
    return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(icon,color: theme),
          ),
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
  }
}
class Educational extends StatelessWidget {
  final User user;

  const Educational(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMale = user.gender == "1";
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    Size deviceSize = MediaQuery.of(context).size;
    Session().logSession("profileUrl",
        "${RequestHeader.getIp()}users/getUserProfile/${user.profileImage}");
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              _innerMenu(Icons.phone,
                  user.phoneNumber,
                  themeProvider.getColor),
              SizedBox(
                height: 15.0,
              ),
              _innerMenu(Icons.email,
                  user.email ?? "loading",
                  themeProvider.getColor),
              SizedBox(
                height: 15.0,
              ),
              _innerMenu(Icons.male,
                  isMale ? "Male": "Female",
                  themeProvider.getColor),
              SizedBox(
                height: 15.0,
              ),
              _innerMenu(Icons.date_range,
                  /*user.birthDate ?? */"loading",
                  themeProvider.getColor),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(flex: 8,),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, UpdateAccount.routeName,
                          arguments: UpdateAccountArgs(isOnline: true));
                    }, child: Text("Update",style: TextStyle(fontSize: 12),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, ChangePassword.routeName,
                          arguments: ChangePasswordArgs(isOnline: true));
                    }, child: Text("Change Password",style: TextStyle(fontSize: 12),)),
                  ),
                ],
              ),
              */
            ],
          ),
      ),
    );
  }
  _innerMenu(IconData icon, String name,Color theme){
    return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(icon,color: theme),
          ),
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Text(
              name,
              style: const TextStyle(
                //color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
  }
}
