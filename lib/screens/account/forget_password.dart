
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../repository/account.dart';
import '../../routes/shared.dart';
import '../../utils/env/session.dart';
import '../../utils/network/network.dart';
import '../../utils/security/validator.dart';
import '../../utils/theme/colors.dart';
import '../widgets/circles.dart';
import '../widgets/painter.dart';
import '../widgets/show_toast.dart';
import 'confirm_otp.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = "/forget_password";

  const ForgetPassword({Key? key, required ForgetPasswordArgs args}) : super(key: key);
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);
  final _appBar = GlobalKey<FormState>();
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;
  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  bool _onProcess = false;
  final phoneControl = TextEditingController();
  final _forgetFormKey = GlobalKey<FormState>();
  late StreamSubscription _connectionChangeStream;
  bool isOffline = false;
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
    /*return Scaffold(
      appBar: HelloAppBar(key: _appBar, title: "forget_password", appBar: AppBar(), widgets: const []),
      body: Container(

      ),
    );
    */
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Form(
          key: _forgetFormKey,
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
                      margin: const EdgeInsets.fromLTRB(20, 300, 20, 10),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        children:  <Widget>[
                          TextFormField(
                            keyboardType:
                            const TextInputType.numberWithOptions(signed: true, decimal: false),
                            controller: phoneControl,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.phone,
                                  color: Theme.of(context).primaryColor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey.shade100 )),
                                labelText: "Phone",
                                enabledBorder: InputBorder.none,
                                labelStyle: const TextStyle(color: Colors.grey)),
                            validator: (value) => Sanitizer().isPhoneValid(value!),
                            onSaved: (value) {

                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                    final _form = _forgetFormKey.currentState;
                                    if (_form!.validate()) {
                                      setState(() {
                                        _onProcess = true;
                                      });
                                      _form.save();
                                      _checkUser(context, phoneControl.text);
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      "REQUEST CODE",
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
                                      colors: [Theme.of(context).primaryColor,
                                        ColorProvider().primaryDarkColor],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                          )/*,
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
  _checkUser(BuildContext context,String phone) {
    Session().logSession("forget", "init");
    if (!isOffline) {
      Session().logSession("forget", "connected");
      setState(() {
        _onProcess = true;
      });
      prepareRequest(context,phone);
    }else{
      Session().logSession("forget", "not connected");
    }
  }

  void prepareRequest(BuildContext context,String phone) {
    var sender = AccountRepository(httpClient: http.Client());
    Session().logSession("forget", "http client");
    var res = sender.isPhoneRegistered(phone);
    res.then((value) => {
      Session().logSession("forget", "response ${value.message}"),
      setState(() {
        _onProcess = false;
      }),
      if (value.code == "200")
        {
          toConfirmScreen(phone)
          //ShowSnack(context, value.message).show()
        }
      else
        {ShowSnack(context, value.message).show()}
    }).onError((error, stackTrace) => {
      Session().logSession("forget", "response $error"),
      _onProcess = false
    });
  }
  void toConfirmScreen(String phone){
    Navigator.pushNamed(context, ConfirmCode.routeName,
        arguments: ConfirmCodeArgs(phone: phone));
  }
}
