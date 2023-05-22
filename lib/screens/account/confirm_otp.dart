import 'dart:async';

import 'package:et_job/utils/env/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../routes/shared.dart';
import '../../utils/security/validator.dart';
import '../../utils/theme/colors.dart';
import '../widgets/circles.dart';
import '../widgets/painter.dart';
import 'reset_password.dart';

class ConfirmCode extends StatefulWidget {
  static const routeName = "/confirm_code";
  final ConfirmCodeArgs args;
  const ConfirmCode({Key? key, required this.args}) : super(key: key);
  @override
  State<ConfirmCode> createState() => _ConfirmCodeState();
}

class _ConfirmCodeState extends State<ConfirmCode> {
  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);
  final _appBar = GlobalKey<FormState>();
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;
  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  bool _onProcess = false;
  final codeControl = TextEditingController();
  final _confirmFormKey = GlobalKey<FormState>();

  late String _verificationId;
  late int _resendToken;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String globalPhone;
  @override
  void initState() {
    var pn = widget.args.phone;
    globalPhone = '+251${pn.substring(1)}';
    sendVerificationCode(globalPhone);
    super.initState();
  }
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();
  final otp5Controller = TextEditingController();
  final otp6Controller = TextEditingController();
  bool doesAllTextFilledsFilled = true;

  bool codeSent = false;
  late Timer _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  int _start = 60;
  bool _isLoading = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void sendVerificationCode(String phoneNumber) async {
    Session().logSession('re-phone', phoneNumber);
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (phoneAuthCredential) async {
          _getSmsAutomaticallyAndConfirm(
              phoneAuthCredential.smsCode, phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red.shade900,
              content: const Text("Incorrect Code")));
          setState(() {
            //showLoading = false;
          });
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            codeSent = true;
          });
          _resendToken = resendingToken!;
          _verificationId = verificationId;
          startTimer();
          _onCodeSent(verificationId, resendingToken,false);
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }
  // @override
  // Widget build(BuildContext context) {
  //   /*return Scaffold(
  //     appBar: HelloAppBar(key: _appBar, title: "confirm_code", appBar: AppBar(), widgets: const []),
  //     body: Container(
  //
  //     ),
  //   );
  //   */
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFEEEEEE),
  //     body: Form(
  //         key: _confirmFormKey,
  //         child: Stack(
  //           children: <Widget>[
  //             Opacity(
  //               opacity: 0.5,
  //               child: ClipPath(
  //                 clipper: WaveClipper(),
  //                 child: Container(
  //                   height: 170,
  //                   color: Theme.of(context).primaryColor,
  //                 ),
  //               ),
  //             ),
  //             ClipPath(
  //               clipper: WaveClipper(),
  //               child: Container(
  //                 height: 150,
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //             ),
  //             Opacity(
  //               opacity: 0.5,
  //               child: Align(
  //                 alignment: Alignment.bottomCenter,
  //                 child: Container(
  //                   height: 70,
  //                   color: Theme.of(context).primaryColor,
  //                   child: ClipPath(
  //                     clipper: WaveClipperBottom(),
  //                     child: Container(
  //                       height: 60,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Align(
  //               alignment: Alignment.bottomCenter,
  //               child: ListView(
  //                 children: <Widget>[
  //                   Container(
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         //border: Border.all(color: Colors.grey),
  //                         borderRadius: BorderRadius.circular(10)),
  //                     margin: const EdgeInsets.fromLTRB(20, 300, 20, 10),
  //                     padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
  //                     child: Column(
  //                       children:  <Widget>[
  //                         TextFormField(
  //                           controller: codeControl,
  //                           decoration: InputDecoration(
  //                               icon: Icon(
  //                                 Icons.vpn_key,
  //                                 color: Theme.of(context).primaryColor,
  //                               ),
  //                               focusedBorder: UnderlineInputBorder(
  //                                   borderSide:
  //                                   BorderSide(color: Colors.grey.shade100 )),
  //                               labelText: "Code",
  //                               enabledBorder: InputBorder.none,
  //                               labelStyle: const TextStyle(color: Colors.grey)),
  //                           validator: (value) => Sanitizer().isVerificationCodeValid(value!),
  //                           onSaved: (value) {
  //
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         SizedBox(
  //                           width: MediaQuery.of(context).size.width * 0.5,
  //                           height: 40,
  //                           child: Container(
  //                             child: Material(
  //                               borderRadius: BorderRadius.circular(20),
  //                               color: Theme.of(context).primaryColor,
  //                               child: InkWell(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 splashColor: Colors.amber,
  //                                 onTap: _onProcess
  //                                     ? null
  //                                     : () {
  //                                   final _form = _confirmFormKey.currentState;
  //                                   if (_form!.validate()) {
  //                                     setState(() {
  //                                       _onProcess = true;
  //                                     });
  //                                     _form.save();
  //                                     Navigator.pushNamed(
  //                                         context, ResetPassword.routeName,
  //                                         arguments: ResetPasswordArgs(phone: widget.args.phone));
  //                                   }
  //
  //                                 },
  //                                 child: const Center(
  //                                   child: Text(
  //                                     "CONFIRM",
  //                                     style: TextStyle(
  //                                         color: Colors.white,
  //                                         fontWeight: FontWeight.w700),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 gradient: LinearGradient(
  //                                     colors: [Theme.of(context).primaryColor,
  //                                       ColorProvider().primaryDarkColor],
  //                                     begin: Alignment.topCenter,
  //                                     end: Alignment.bottomCenter)),
  //                           ),
  //                         )/*,
  //                     FloatingActionButton(
  //                       onPressed: () {},
  //                       mini: true,
  //                       elevation: 0,
  //                       child: const Image(
  //                         image: AssetImage("assets/facebook2.png"),
  //                       ),
  //                     ),
  //                     FloatingActionButton(
  //                       onPressed: () {},
  //                       mini: true,
  //                       elevation: 0,
  //                       child: const Image(
  //                         image: AssetImage("assets/twitter.png"),
  //                       ),
  //                     ),*/
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         )),
  //   );
  // }
  //
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: Stack(
        children: [
           Padding(padding: EdgeInsets.only(top: 40,left: 10),
          child: SizedBox(
            height: 30,
              width: 30,
            child: TextButton(
                onPressed: (){
             return Navigator.pop(context);
              }, child: const Icon(Icons.arrow_back)),
          ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              padding: const EdgeInsets.only(top: 100),
              child: codeSent
                  ? _buildForm(node)
                  : Text("Sending Code...",
                style: TextStyle(color: Colors.green[900], fontSize: 20.0),
              )),
        ],
      ),
    );
  }
  void resendVerificationCode(String phoneNumber, int token) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: const [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Sending."),
              ],
            ),
          );
        });
    _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: globalPhone,
        verificationCompleted: (phoneAuthCredential) async {
          _getSmsAutomaticallyAndConfirm(
              phoneAuthCredential.smsCode, phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          ScaffoldMessenger.of(context).showSnackBar(_errorMessageSnackBar(
              verificationFailed.message ?? "Unknown Error"));
          debugPrint("Verification failed: $verificationFailed");
          Navigator.pop(context);
        },
        codeSent: (verificationId, resendingToken) async {
          _onCodeSent(verificationId, resendingToken!,true);
        },
        forceResendingToken: token,
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  SnackBar _errorMessageSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade900,
    );
  }

  void _onCodeSent(String verificationId, int resendingToken,bool dismiss) {
    otp1Controller.clear();
    otp2Controller.clear();
    otp3Controller.clear();
    otp4Controller.clear();
    otp5Controller.clear();
    otp6Controller.clear();
    if(dismiss){
      Navigator.pop(context);
    }
    setState(() {
      _start = 60;
      _verificationId = verificationId;
      _resendToken = resendingToken;
    });
    startTimer();
  }

  void _getSmsAutomaticallyAndConfirm(
      String? smsCode, PhoneAuthCredential credential) async {
    if (smsCode != null) {
      otp1Controller.text = smsCode[0];
      otp2Controller.text = smsCode[1];
      otp3Controller.text = smsCode[2];
      otp4Controller.text = smsCode[3];
      otp5Controller.text = smsCode[4];
      otp6Controller.text = smsCode[5];
      _signInWithPhoneAuthCredential(credential);
    }
  }

  void _signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _isLoading = false;
      });
      if (authCredential.user != null) {

        Navigator.pushReplacementNamed(context, ResetPassword.routeName,
            arguments:
            ResetPasswordArgs(phone: widget.args.phone));

      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(_errorMessageSnackBar(e.toString()));
    }
  }

  Widget _buildForm(node) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verification Code Sent',
            style: TextStyle(color: Colors.green[900], fontSize: 24.0),
          ),
          const Text(
            'Enter the verification code sent to you',
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = false;
                      });
                      return null;
                    },
                    controller: otp1Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.isEmpty) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = false;
                      });
                      return null;
                    },
                    controller: otp2Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.isEmpty) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = true;
                      });
                      return null;
                    },
                    controller: otp3Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.isEmpty) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = true;
                      });
                      return null;
                    },
                    controller: otp4Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.isEmpty) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = true;
                      });
                      return null;
                    },
                    controller: otp5Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.isEmpty) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
              SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          doesAllTextFilledsFilled = false;
                        });
                        return null;
                      }
                      setState(() {
                        doesAllTextFilledsFilled = true;
                      });
                      return null;
                    },
                    controller: otp6Controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26.0),
                    onChanged: (value) {
                      if (value.length == 1) node.nextFocus();
                      if (value.isEmpty) node.previousFocus();
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          doesAllTextFilledsFilled
              ? Container()
              : const Center(
              child: Text(
                'Must fill all fields',
                style: TextStyle(color: Colors.red),
              )),
          const SizedBox(
            height: 30.0,
          ),
          Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text(
                    _start != 0
                        ? 'Didn\'t receive the code?  $_start'
                        : 'Didn\'t receive the code? ',
                    style: const TextStyle(fontSize: 13.0),
                  ),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> state) =>
                            state.contains(MaterialState.disabled)
                                ? Colors.grey
                                : null),
                      ),
                      onPressed: _start == 0
                          ? () {
                        resendVerificationCode(
                            globalPhone, _resendToken);
                      }
                          : null,
                      child: const Text(
                        ' RESEND',
                      )),
                ],
              )),
          Center(
            child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                width: 200.0,
                height: 40.0,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      if (doesAllTextFilledsFilled) {
                        String code = otp1Controller.text +
                            otp2Controller.text +
                            otp3Controller.text +
                            otp4Controller.text +
                            otp5Controller.text +
                            otp6Controller.text;

                        PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: _verificationId,
                            smsCode: code);
                        _signInWithPhoneAuthCredential(credential);
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text("Verify",
                          style: TextStyle(color: Colors.white)),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isLoading
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
                )),
          ),
        ],
      ),
    );
  }
}
