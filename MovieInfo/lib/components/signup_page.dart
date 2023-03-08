import 'dart:io';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sampleapplication/components/common/page_header.dart';
import 'package:sampleapplication/components/common/page_heading.dart';
import 'package:sampleapplication/components/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sampleapplication/components/phone_verification.dart';
import 'package:sampleapplication/components/common/custom_form_button.dart';
import 'package:sampleapplication/components/common/custom_input_field.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _profileImage;

  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  late bool isLoading;

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _signupFormKey,
              child: Column(
                children: [
                  const PageHeader(),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Sign-up',
                        ),
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: _pickProfileImage,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade400,
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_sharp,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                            controller: _nameController,
                            labelText: 'Name',
                            hintText: 'Your name',
                            isDense: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Name field is required!';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                            labelText: 'Email',
                            hintText: 'Your email id',
                            isDense: true,
                            controller: _emailcontroller,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Email is required!';
                              }
                              if (!EmailValidator.validate(textValue)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                            controller: _phoneNumberController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            labelText: 'Contact Number',
                            hintText: 'Your contact 10 digit number',
                            isDense: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Contact number is required!';
                              }
                              if (textValue.length != 10) {
                                return 'Invalid Contact number';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                            controller: _dobController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            labelText: 'Date of Birth',
                            hintText: 'DD/MM/YYYY',
                            isDense: true,
                            validator: (textValue) {
                              if (textValue == null ||
                                  textValue.isEmpty ||
                                  textValue.length != 10) {
                                return 'Date of Birth is required!';
                              }
                              if (!_validDOB(textValue)) {
                                return 'Invalid Date of Birth';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                          labelText: 'Password',
                          hintText: 'Your password',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _passwordcontroller,
                          isDense: true,
                          obscureText: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Password is required!';
                            }
                            if (textValue.length < 6) {
                              return 'Password Should be greater than 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: true,
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        CustomFormButton(
                          innerText: 'Submit',
                          onPressed: () async {
                            _handleSignupUser();
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account ? ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff939393),
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()))
                                },
                                child: const Text(
                                  'Log-in',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff748288),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignupUser() async {
    // signup user
    if (_signupFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Submitting Data..')));
      setState(() {
        LoadingFlag.isLoading = true;
      });
      var methods =
          await _auth.fetchSignInMethodsForEmail(_emailcontroller.text);
      setState(() {
        LoadingFlag.isLoading = false;
      });
      if (methods.isEmpty) {
        successDialog();
      } else {
        failureDialog("Email already exists!");
      }
    }
  }

  Future successDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text("User Sign-up"),
              content: Text("Phone number verification required"),
              actions: [
                TextButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneVerification(
                                _phoneNumberController.text,
                                _nameController.text,
                                _dobController.text,
                                _emailcontroller.text,
                                _profileImage,
                                _passwordcontroller.text)))
                  },
                  child: const Text('Verify Phone Number'),
                ),
              ]));

  // ignore: non_constant_identifier_names
  Future failureDialog(FailureReason) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text("User Sign-up"),
              content: Text("$FailureReason"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ]));

  bool _validDOB(String text) {
    DateTime dateTime1;
    try {
      dateTime1 = DateFormat("dd/MM/yyyy").parse(text);
    } catch (e) {
      return false;
    }
    var nowDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
    DateTime currDate = DateFormat("dd/MM/yyyy").parse(nowDate);
    if (currDate.isBefore(dateTime1)) {
      return false;
    }
    return true;
  }
}


      // final User? user = (await _auth.createUserWithEmailAndPassword(
      //         email: _emailcontroller.text, password: _passwordcontroller.text))
      //     .user;
      // setState(() {
      //   LoadingFlag.isLoading = false;
      //   failureDialog(
      //       e.toString().replaceRange(0, 14, '').split(']')[1].trim());
      // })