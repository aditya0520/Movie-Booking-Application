import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:sampleapplication/components/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sampleapplication/components/common/page_header.dart';
import 'package:sampleapplication/components/signup_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:sampleapplication/components/common/custom_form_button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore fireStore = FirebaseFirestore.instance;

class PhoneVerification extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String dob;
  final String email;
  final File? profileImage;
  final String password;
  const PhoneVerification(this.phoneNumber, this.name, this.dob, this.email,
      this.profileImage, this.password,
      {Key? key})
      : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String verificationIDReceived = "";
  int count = 1;
  String currentText = "";
  bool wait = true;
  int start = 45;
  final _loginFormKey = GlobalKey<FormState>();
  bool hasError = false;
  late User? user;
  late User? loggedInUser;

  TextEditingController otpTextController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  void initState() {
    otpSend(widget.phoneNumber);
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          backgroundColor: const Color(0xffEEF1F3),
          body: SafeArea(
            child: Column(
              children: [
                const PageHeader(),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: Text(
                                'Verification',
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NotoSerif'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8),
                              child: RichText(
                                text: TextSpan(
                                    text: "Enter the code sent to ",
                                    children: [
                                      TextSpan(
                                          text: widget.phoneNumber,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                    style: TextStyle(
                                        color: Color(0xff939393),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 30),
                                child: PinCodeTextField(
                                  appContext: context,
                                  pastedTextStyle: TextStyle(
                                    color: Colors.green.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  length: 6,
                                  obscureText: false,
                                  obscuringCharacter: '*',
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    inactiveFillColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    activeColor: Colors.grey,
                                    inactiveColor: Colors.grey,
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(10),
                                    fieldHeight: 60,
                                    fieldWidth: 50,
                                    activeFillColor:
                                        hasError ? Colors.orange : Colors.white,
                                  ),
                                  cursorColor: Colors.black,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  textStyle:
                                      TextStyle(fontSize: 20, height: 1.6),
                                  backgroundColor: Colors.white70,
                                  enableActiveFill: true,
                                  errorAnimationController: errorController,
                                  controller: otpTextController,
                                  keyboardType: TextInputType.number,
                                  boxShadows: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Colors.black12,
                                      blurRadius: 10,
                                    )
                                  ],
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      currentText = value;
                                    });
                                  },
                                )),
                            CustomFormButton(
                              innerText: 'Verify',
                              onPressed: () {
                                _handleLoginUser();
                              },
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Didn\'t receive the code?',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff939393),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: start == 0
                                            ? () {
                                                otpSend(widget.phoneNumber);
                                              }
                                            : null,
                                        child: Text(
                                          'RESEND',
                                          style: TextStyle(
                                              decoration: start == 0
                                                  ? TextDecoration.underline
                                                  : null,
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 100, 110, 115),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Visibility(
                                        visible: start == 0 ? false : true,
                                        child: Text(
                                          'in 00:$start',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 100, 110, 115),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void startTimer() {
    const onesec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onesec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void otpSend(String? phone) async {
    setState(() {
      start = 45;
    });
    otpTextController.clear();
    startTimer();
    _auth.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationID, int? resendToken) {
          verificationIDReceived = verificationID;
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  void _handleLoginUser() async {
    setState(() {
      LoadingFlag.isLoading = true;
    });
    if (count == 1) {
      user = (await _auth.createUserWithEmailAndPassword(
              email: widget.email, password: widget.password))
          .user;
      loggedInUser = (await _auth.signInWithEmailAndPassword(
              email: widget.email, password: widget.password))
          .user;
      count = 0;
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived,
        smsCode: otpTextController.text);
    try {
      final userCredential = await user?.linkWithCredential(credential);
      setState(() {
        LoadingFlag.isLoading = false;
      });
      successDialog();
      DocumentReference documentReference =
          fireStore.collection("userInfo").doc(user?.uid);
      Map<String, Object?> map = {};
      map["Name"] = widget.name;
      map["Email"] = widget.email;
      map["DOB"] = widget.dob;
      map["Phone"] = widget.phoneNumber;
      // map["profile_Image"] = widget.profileImage;
      documentReference.set(map);
    } on FirebaseAuthException catch (e) {
      setState(() {
        LoadingFlag.isLoading = false;
      });
      switch (e.code) {
        case "invalid-credential":
          failureDialog("Invalid OTP", "Ok");
          break;
        case "credential-already-in-use":
          failureDialog("Mobile Number Already in Use", "Sign-in again");
          loggedInUser?.delete().then((value) => null);
          break;
        // See the API reference for the full list of error codes.
        default:
          failureDialog("Unknown error. Please try again", "Ok");
      }
    }
  }

  Future successDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text("Mobile Verification"),
              content: Text("Verification Successful!"),
              actions: [
                TextButton(
                  onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()))
                  },
                  child: const Text('Login-in'),
                ),
              ]));

  Future failureDialog(FailureReason, buttonText) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text("Mobile Verification"),
              content: Text("$FailureReason"),
              actions: [
                TextButton(
                  onPressed: buttonText == "Ok"
                      ? () => Navigator.pop(context, 'OK')
                      : () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()))
                          },
                  child: Text('$buttonText'),
                ),
              ]));
}
