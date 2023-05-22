import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../repository/account.dart';
import '../../routes/shared.dart';
import '../../utils/env/session.dart';
import '../../utils/security/validator.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/theme_provider.dart';
import '../root/root_screen.dart';
import '../widgets/circles.dart';
import '../widgets/painter.dart';
import '../widgets/show_toast.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  static const routeName = "/register";

  const RegisterScreen({Key? key, required RegisterScreenArgs args})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userNameControl = TextEditingController();
  final emailControl = TextEditingController();
  final passwordControl = TextEditingController();
  final password2Control = TextEditingController();
  final phoneControl = TextEditingController();

  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;

  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;
  var invisible = false;

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

  bool _onProcess = false;
  final _registerFormKey = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: Form(
          key: _registerFormKey,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: ListView(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.fromLTRB(20, 100, 20, 10),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.asset("assets/icons/icon.png"),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.legend_toggle,
                                color: Theme.of(context).primaryColor,),
                              Expanded(
                                child: jobTopBar(context, "Looking for: ",
                                    _dropDownItem(typeItems, _chosenTypeValue)),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: userNameControl,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100)),
                                labelText: _chosenTypeValue == "Jobs" ? "Full name" : "Company Name",
                                enabledBorder: InputBorder.none,
                                labelStyle:
                                const TextStyle(color: Colors.grey)),
                            validator: (value) =>
                            _chosenTypeValue == "Jobs" ? Sanitizer().isFullNameValid(value!):
                            Sanitizer().is3Length(value!),
                          ),

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
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100)),
                                labelText: "Phone",
                                enabledBorder: InputBorder.none,
                                labelStyle:
                                    const TextStyle(color: Colors.grey)),
                            validator: (value) =>
                                Sanitizer().isPhoneValid(value!),
                          ),
                          TextFormField(
                            controller: emailControl,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade100)),
                                labelText: "Email",
                                enabledBorder: InputBorder.none,
                                labelStyle:
                                    const TextStyle(color: Colors.grey)),
                            validator: (value) =>
                                Sanitizer().isEmailValid(value!),
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
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade100)),
                              labelText: "Password",
                              enabledBorder: InputBorder.none,
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffix: GestureDetector(
                                onTap: changeSate,
                                //call this method when contact with screen is removed
                                child: Icon(
                                  invisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            validator: (value) =>
                                Sanitizer().isPasswordValid(value!),
                          ),
                          TextFormField(
                            controller: password2Control,
                            obscureText: invisible,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.vpn_key,
                                color: Theme.of(context).primaryColor,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade100)),
                              labelText: "Confirm Password",
                              enabledBorder: InputBorder.none,
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffix: GestureDetector(
                                onTap: changeSate,
                                //call this method when contact with screen is removed
                                child: Icon(
                                  invisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            validator: (value) => Sanitizer()
                                .isPasswordMatch(passwordControl.text, value!),
                          ),
                          _chosenTypeValue == 'Jobs' ? Row(
                            children: [
                              Icon(Icons.male,
                                color: Theme.of(context).primaryColor,),
                              Expanded(
                                child: jobTopBar(context, "Gender: ",
                                    _dropDownGItem(genders, _chosenGenderValue)),
                              ),
                            ],
                          ) : Container(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onProcess
                              ? null
                              : () {
                                  final _form = _registerFormKey.currentState;
                                  if (_form!.validate()) {
                                    setState(() {
                                      _onProcess = true;
                                    });
                                    _form.save();
                                    prepareRequest(context);
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              const Text("REGISTER",
                                  style: TextStyle(color: Colors.white)),
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: _onProcess
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "ALREADY HAVE AN ACCOUNT ? ",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black38,
                              fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.amber,
                          onTap: () {
                            Navigator.pop(context);
                            /*Navigator.pushNamed(
                            context, LoginScreen.routeName, arguments: LoginScreenArgs(isOnline: true));*/
                          },
                          child: Center(
                            child: Text(
                              "  SIGN IN",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void prepareRequest(BuildContext context) {
    final Map<String, dynamic> _user = {};
    _user['full_name'] = userNameControl.text;
    _user['phone'] = phoneControl.text;
    _user['email'] = emailControl.text;
    _user['password'] = passwordControl.text;
    _user['role'] = getRole(_chosenTypeValue);
    _user['gender'] = _chosenGenderValue;
    var sender = AccountRepository(httpClient: http.Client());
    Session().logSession("login", "http client");
    setState(() {
      _onProcess = true;
    });
    //var res = sender.fakeRegister(_user);
    var res = sender.registerUser(_user);
    res
        .then((value) => {
              Session().logSession("register", "success ${value.message}"),
              setState(() {
                _onProcess = false;
              }),
              if (value.code == "200")
                {_openHomeScreen(getRoleEn(_chosenTypeValue))}
              else
                {
                  ShowSnack(context, value.message).show(),
                }
            })
        .onError((error, stackTrace) => {
              Session().logSession("register", "error $error"),
              setState(() {
                _onProcess = false;
              })
            });
  }

  _openHomeScreen(UserRole role) {
    HomeScreenArgs argument = HomeScreenArgs(userRole: role);
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (Route<dynamic> route) => false,
        arguments: argument);
  }

  var typeItems = <String>['Jobs', 'Employee','Admin'];
  String _chosenTypeValue = "Jobs";

  var genders = <String>['Male', 'Female'];
  String _chosenGenderValue = "Male";

  String getRole(String selected){
    if(selected == "Jobs"){
      return "employee";
    }else if(selected == "Employee"){
      return "employer";
    }else if(selected == "Admin"){
      return "admin";
    }else{
      return "guest";
    }
  }
  UserRole getRoleEn(String selected){
    if(selected == "Jobs"){
      return UserRole.employee;
    }else if(selected == "Employee"){
      return UserRole.employer;
    }else if(selected == "Admin"){
      return UserRole.admin;
    }else{
      return UserRole.guest;
    }
  }



  Widget _dropDownItem(List<String> data, String chosen) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.blue,
      underline: null,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      value: _chosenTypeValue,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.blue,
      items: data.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: const Text(
        "Please choose ",
        style: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (String? value) {
        setState(() {
          _chosenTypeValue = value!;
          Session().logSession("chhosen", _chosenTypeValue);
        });
      },
    );
  }
  Widget _dropDownGItem(List<String> data, String chosen) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.blue,
      underline: null,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      value: _chosenGenderValue,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.blue,
      items: data.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: const Text(
        "Please choose ",
        style: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (String? value) {
        setState(() {
          _chosenGenderValue = value!;
        });
      },
    );
  }

  Widget jobTopBar(BuildContext context, String name, Widget value) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,//Theme.of(context).primaryColor.withOpacity(0.3),
              /*blurRadius: 3.0,
              // has the effect of softening the shadow
              spreadRadius:
              2.0, */ // has the effect of extending the shadow
            ),
          ],
          //color: _themeColor(theme),
          borderRadius: BorderRadius.circular(
            5.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(name,
                  style: const TextStyle(
                    color: Colors.black,
                  )),
            ),
            value
          ],
        ),
      ),
    );
  }
}
