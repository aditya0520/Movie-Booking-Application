import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleapplication/components/common/custom_input_field.dart';
import 'package:sampleapplication/components/common/page_header.dart';
import 'package:sampleapplication/components/forget_password_page.dart';
import 'package:sampleapplication/components/signup_page.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sampleapplication/components/landingPage/landing_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sampleapplication/components/common/page_heading.dart';

import 'package:sampleapplication/components/common/custom_form_button.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //
  final _loginFormKey = GlobalKey<FormState>();

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
                          const PageHeading(
                            title: 'Log-in',
                          ),
                          CustomInputField(
                              labelText: 'Email',
                              hintText: 'Your email id',
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
                            labelText: 'Password',
                            hintText: 'Your password',
                            obscureText: true,
                            suffixIcon: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Password is required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: size.width * 0.80,
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgetPasswordPage()))
                              },
                              child: const Text(
                                'Forget password?',
                                style: TextStyle(
                                  color: Color(0xff939393),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomFormButton(
                            innerText: 'Login',
                            onPressed: _handleLoginUser,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            width: size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account ? ',
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
                                                const SignupPage()))
                                  },
                                  child: const Text(
                                    'Sign-up',
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
        ),
      ),
    );
  }

  void _handleLoginUser() {
    // login user
    if (_loginFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data..')),
      );
    }
    // LandingPageState.selectedGenre = 0;
    // if (MovieCarouselState.pageController.hasClients) {
    //   MovieCarouselState.pageController.jumpTo(0);
    //   MovieCarouselState.initialPage = 0;
    // }
    // Movie.movies = allMovies;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LandingPage()));
  }
}
