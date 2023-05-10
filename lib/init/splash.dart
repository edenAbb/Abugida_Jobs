
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../models/user.dart';
import '../repository/account.dart';
import '../routes/shared.dart';
import '../screens/account/change_password.dart';
import '../screens/account/confirm_otp.dart';
import '../screens/account/forget_password.dart';
import '../screens/account/login.dart';
import '../screens/root/root_screen.dart';
import '../screens/widgets/painter.dart';
import '../utils/env/session.dart';
import '../utils/theme/theme_provider.dart';

import 'package:http/http.dart' as http;
class SplashScreen extends StatefulWidget {
  static const routeName = "/change_password";

  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late User user;
  late ThemeProvider themeProvider;
  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    startTimer();
    super.initState();
  }
  var proLoaded = false;
  _loadProfile() {
    var auth = AccountRepository(httpClient: http.Client());
    auth.getUserData().then((value) => {
      setState((){
        if(value.token != ""){
          user = value;
          Session().logSession("user", value.toString());
          proLoaded = true;
          _openHomeScreen(value.role);
        }else{
          _openLoginScreen();
        }
      })
    });
  }
  startTimer() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, _loadProfile);
  }
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }
  bool _isUserLoggedIn(){
    return proLoaded;
  }
  _openLoginScreen(){
    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context) => LoginScreen(args: LoginScreenArgs(isOnline: true))));
  }
  _openHomeScreen(UserRole role){
    HomeScreenArgs argument = HomeScreenArgs(userRole: role);
    Navigator.pushNamedAndRemoveUntil(context,
        HomeScreen.routeName, (Route<dynamic> route) => false,
        arguments: argument);

  }

  _openRegistration(){
    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context) => LoginScreen(args: LoginScreenArgs(isOnline: true))));
  }

  _waitSec() async {
    await Future.delayed(const Duration(seconds: 5));
  }
  initScreen(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 180,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 170,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                color: Theme.of(context).primaryColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 1200,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints.expand(),
            decoration:  BoxDecoration(
              //color: ColorProvider.primaryDarkColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.asset("assets/icons/icons-vacancy.png",scale: 0.5,),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                SizedBox(
                  height: 200,
                  child: SleekCircularSlider(
                    min: 0,
                    max: 100,
                    initialValue: 100,
                    appearance: CircularSliderAppearance(
                      infoProperties: InfoProperties(
                          mainLabelStyle: TextStyle(
                            color: themeProvider.getColor,
                            fontSize: 25,
                          )
                      ),
                      customColors: CustomSliderColors(
                        //dotColor: ColorProvider.white,
                          progressBarColor: themeProvider.getColor,
                          shadowColor: themeProvider.getColor.withOpacity(0.5),
                          shadowMaxOpacity: 0.5,
                          shadowStep: 6,
                          trackColor: themeProvider.getColor.withOpacity(0.5)
                      ),
                      spinnerDuration: 4,
                      animDurationMultiplier: 5,
                      animationEnabled: true,
                      startAngle: 0.0,
                      angleRange: 360,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Initializing app...',
                  style: TextStyle(
                    //color: ColorProvider.white
                      fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
