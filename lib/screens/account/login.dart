import 'dart:async';
import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:et_job/models/user.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/account.dart';
import '../../routes/shared.dart';
import '../../services/helper/header.dart';
import '../../utils/env/session.dart';
import '../../utils/network/network.dart';
import '../../utils/security/validator.dart';
import '../../utils/theme/colors.dart';
import '../root/root_screen.dart';
import '../widgets/circles.dart';
import '../widgets/painter.dart';
import '../widgets/show_toast.dart';
import 'forget_password.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  const LoginScreen({Key? key, required LoginScreenArgs args})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late StreamSubscription _connectionChangeStream;
  bool isOffline = false;

  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);
  final _loginFormKey = GlobalKey<FormState>();
  var invisible = true;

  void changeSate() {
    if (invisible) {
      setState(() {
        invisible = false;
      });
    } else {
      setState(() {
        invisible = true;
      });
    }
  }

  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;

  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;
  final passwordControl = TextEditingController();
  final phoneControl = TextEditingController();
  final Map<String, dynamic> _user = {};
  late bool _onProcess;

  @override
  void initState() {
    _onProcess = false;
    NetworkManager connectionStatus = NetworkManager.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    super.initState();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  dispose() {
    _connectionChangeStream.cancel();
    _onProcess = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: Form(
          key: _loginFormKey,
          child: Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.5,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 170,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 150,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    color: Theme.of(context).primaryColor,
                    child: ClipPath(
                      clipper: WaveClipperBottom(),
                      child: Container(
                        height: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              _align()
            ],
          ),
        ));
  }

  Align _align() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: (){
                _displayTextInputDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset("assets/icons/icon.png"),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                //border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: _phoneAndPassword(),
          ),
          _startLoginProcess(),
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.amber,
                  onTap: () {
                    Navigator.pushNamed(context, ForgetPassword.routeName,
                        arguments: ForgetPasswordArgs(isOnline: true));
                  },
                  child: Center(
                    child: Text(
                      "FORGOT PASSWORD?",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )),
          _newUser(),
          /*(isOffline)
                        ? const Text("Not connected")
                        : const Text("Connected"),*/
        ],
      ),
    );
  }

  Column _phoneAndPassword() {
    return Column(
      children: <Widget>[
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          controller: phoneControl,
          decoration: InputDecoration(
              icon: Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade100)),
              labelText: "Phone",
              enabledBorder: InputBorder.none,
              labelStyle: const TextStyle(color: Colors.grey)),
          //validator: (value) => Sanitizer().isPhoneValid(value!),
          validator: (value) => Sanitizer().isPhoneValid(value!),
          onSaved: (value) {
            _user["phone"] = value;
          },
        ),
        TextFormField(
          controller: passwordControl,
          obscureText: invisible,
          decoration: InputDecoration(
            icon: Icon(
              Icons.vpn_key,
              color: Theme.of(context).primaryColor,
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade100)),
            labelText: "Password",
            enabledBorder: InputBorder.none,
            labelStyle: const TextStyle(color: Colors.grey),
            suffix: GestureDetector(
              onTap: _onProcess ? null : changeSate,
              //call this method when contact with screen is removed
              child: Icon(
                invisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          validator: (value) => Sanitizer().isPasswordValid(value!),
          onSaved: (value) {
            _user["password"] = value;
          },
        ),
      ],
    );
  }

  Container _startLoginProcess() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 45,
            child: Container(
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  splashColor: Colors.amber,
                  onTap: _onProcess
                      ? null
                      : () {
                          final _form = _loginFormKey.currentState;
                          if (_form!.validate()) {
                            _form.save();
                            _loginUser(context);
                          }
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text("SIGN IN",
                          style: TextStyle(color: Colors.white)),
                      const Spacer(),
                      Align(
                        widthFactor: 2,
                        alignment: Alignment.centerRight,
                        child: _onProcess
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Theme.of(context).primaryColor,
                    ColorProvider().primaryDarkColor
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
          )
        ],
      ),
    );
  }

  Row _newUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "DON'T HAVE AN ACCOUNT ? ",
          style: TextStyle(
              fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.amber,
          onTap: () {
            Navigator.pushNamed(context, RegisterScreen.routeName,
                arguments: RegisterScreenArgs(isOnline: true));
          },
          child: Center(
            child: Text(
              "SIGN UP",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  _loginUser(BuildContext context) {
    Session().logSession("login", "init");
    if (!isOffline) {
      Session().logSession("login", "connected");
      prepareRequest(context);
    } else {
      Session().logSession("login", "not connected");
    }
  }

  void prepareRequest(BuildContext context) {
    var sender = AccountRepository(httpClient: http.Client());
    //Session().logSession("login", "http client");
    setState(() {
      _onProcess = true;
    });
    //var res = sender.fakeLogin(_user["password"]);
    var res = sender.loginUser(_user);
    res.then((value) => {
              setState(() {
                _onProcess = false;
              }),
              if (value.code == "200")
                {_openHomeScreen(value.userRole)}
              else
                {
                  ShowSnack(context, value.message).show(),
                }
            })
        .onError((error, stackTrace) => {
              Session().logSession("login", "response $error"),
      setState(() {
        _onProcess = false;
      }),
            });
  }

  _openHomeScreen(UserRole role) {
    HomeScreenArgs argument = HomeScreenArgs(userRole: role);
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (Route<dynamic> route) => false,
        arguments: argument);
  }
  UserRole getRoleEn(String selected){
    if(selected == "Jobs"){
      return UserRole.employer;
    }else if(selected == "Employee"){
      return UserRole.employee;
    }else{
      return UserRole.guest;
    }
  }
  TextEditingController _textFieldController = TextEditingController();

  final _ipFormKey = GlobalKey<FormState>();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    getIp();
    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _ipFormKey,
          child: AlertDialog(
            title: const Text('Input Server Ip'),
            content: TextFormField(
              controller: _textFieldController,
              decoration: InputDecoration(
                  hintText: ip),
              validator: (value){
                if (!validator.ip(value!)) {
                  return 'Please enter a valid ip';
                }
                return null;
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  final _form = _ipFormKey.currentState;
                  if (_form!.validate()) {
                    _form.save();
                    saveIp();
                    Navigator.pop(context);
                  }else{
                    ShowSnack(context,"Please Input Valid IP").show();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> saveIp() async {
    RequestHeader.setIp(_textFieldController.text);
  }
  Future<void> getIp() async {
      ip = await RequestHeader.getRawIp();
      _textFieldController.text = ip;
  }
  var ip = "not loaded";

}
