import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../repository/account.dart';
import '../../routes/shared.dart';
import '../../utils/env/session.dart';
import '../../utils/security/validator.dart';
import '../../utils/theme/colors.dart';
import '../widgets/app_bar.dart';
import '../widgets/circles.dart';
import '../widgets/painter.dart';
import '../widgets/show_toast.dart';
import 'package:http/http.dart' as http;
class ChangePassword extends StatefulWidget {
  static const routeName = "/change_password";

  const ChangePassword({Key? key, required ChangePasswordArgs arg})
      : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);
  final _appBar = GlobalKey<FormState>();
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
  final _changeFormKey = GlobalKey<FormState>();
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;

  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  final password0Control = TextEditingController();
  final password1Control = TextEditingController();
  final password2Control = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: HelloAppBar(key: _appBar, title: "change_password", appBar: AppBar(), widgets: const []),
      body: Container(

      ),
    );
    */
    return Scaffold(
      appBar: JobsAppBar(
        key: _appBar,
        title: "Update Account",
        appBar: AppBar(),
        widgets: const []),
      backgroundColor: const Color(0xFFEEEEEE),
      body: Form(
          key: _changeFormKey,
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
                          TextFormField(
                            controller: password0Control,
                            obscureText: invisible,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.vpn_key,
                                color: Theme.of(context).primaryColor,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade100)),
                              labelText: "Old Password",
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
                              ),),
                            validator: (value) => Sanitizer().isPasswordValid(value!),
                            onSaved: (value) {
                              _passwords["old_password"] = value;
                            },
                          ),
                          TextFormField(
                            controller: password1Control,
                            obscureText: invisible,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.vpn_key,
                                color: Theme.of(context).primaryColor,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade100)),
                              labelText: "New Password",
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
                              ),),
                            validator: (value) => Sanitizer().isPasswordValid(value!),
                            onSaved: (value) {},
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
                              ),),
                            validator: (value) => Sanitizer()
                                .isPasswordMatch(password1Control.text,value!),
                            onSaved: (value) {
                              _passwords["new_password"] = value;
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(90, 0, 20, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 40,
                            child: Container(
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).primaryColor,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: Colors.amber,
                                  onTap: _onProcess
                                      ? null
                                      : () {
                                    final _form = _changeFormKey.currentState;
                                    if (_form!.validate()) {
                                      _form.save();
                                      if(_passwords['old_password'] != _passwords['new_password']){
                                        setState(() {
                                          _onProcess = true;
                                        });
                                        prepareRequest(context);
                                      }else{
                                        ShowSnack(context, "Old and New Password can not be same!!!").show();
                                      }
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Change Password",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        ColorProvider().primaryDarkColor
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                          ) /*,
                      FloatingActionButton(
                        onPressed: () {},
                        mini: true,
                        elevation: 0,
                        child: const Image(
                          image: AssetImage("assets/facebook2.png"),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        mini: true,
                        elevation: 0,
                        child: const Image(
                          image: AssetImage("assets/twitter.png"),
                        ),
                      ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  final Map<String, dynamic> _passwords = {};
  void prepareRequest(BuildContext context) {
    var sender = AccountRepository(httpClient: http.Client());
    //Session().logSession("login", "http client");
    setState(() {
      _onProcess = true;
    });
    //var res = sender.fakeLogin(_doctor["password"]);
    var res = sender.changePassword(_passwords);
    res.then((value) => {
      setState(() {
        _onProcess = false;
      }),
      // if (value.code == "200")
      //   {
      //     ShowSnack(context,"Password changed")
      //   }
      // else
      //   {
      //     ShowSnack(context, value.message).show()
      //   }
      ShowSnack(context, value.message).show(),
    Navigator.pop(context)
    })
        .onError((error, stackTrace) => {
      Session().logSession("login", "response $error"),
      setState(() {
        _onProcess = false;
      }),
    });
  }
}
