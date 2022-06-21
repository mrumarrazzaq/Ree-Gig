//// ignore_for_file: avoid_print
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:form_field_validator/form_field_validator.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:ree_gig/home_screen.dart';
//import 'package:ree_gig/project_constants.dart';
//import 'forgot_password.dart';
//import 'register_screen.dart';
//import 'package:google_fonts/google_fonts.dart';
//
//class SigninScreen extends StatefulWidget {
//  static const String id = 'SigninScreen';
//
//  SigninScreen({Key? key}) : super(key: key);
//
//  @override
//  _SigninScreenState createState() => _SigninScreenState();
//}
//
//class _SigninScreenState extends State<SigninScreen> {
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//  bool _obscureText = true;
//  bool isValidEmail = false;
//  bool isLoading = false;
//  bool _isreadOnly = false;
//
//  var email = "";
//  var password = "";
//  final emailController = TextEditingController();
//  final passwordController = TextEditingController();
//  final storage = FlutterSecureStorage();
//
//  String? validatePassword(value) {
//    if (value.isEmpty) {
//      return 'Please enter password';
//    } else if (value.length < 8) {
//      return 'Should be at least 8 characters';
//    } else if (value.length > 25) {
//      return 'Should not be more than 25 characters';
//    } else {
//      return null;
//    }
//  }
//
//  @override
//  void dispose() {
//    emailController.dispose();
//    passwordController.dispose();
//    super.dispose();
//  }
//
//  userSignin() async {
//    try {
//      isLoading = true;
////      UserCredential userCredential = await FirebaseAuth.instance
////          .signInWithEmailAndPassword(email: email, password: password);
////      //______________________________________________________________________//
////      print('user credential email : ${userCredential.user?.email}');
////      //STORE user id into the Local Database
////      await storage.write(key: 'uid', value: userCredential.user?.uid);
//      //______________________________________________________________________//
//      // ignore: deprecated_member_use
////      _scaffoldKey.currentState!.showSnackBar(
////        const SnackBar(
////          backgroundColor: Colors.green,
////          content: Text(
////            "Login Successfully",
////            style: TextStyle(fontSize: 10.0, color: Colors.white),
////          ),
////          duration: Duration(seconds: 30),
////        ),
////      );
//      Fluttertoast.showToast(
//        msg: 'User Login Successfully', // message
//        toastLength: Toast.LENGTH_SHORT, // length
//        gravity: ToastGravity.BOTTOM, // location
//        backgroundColor: Colors.green,
//      );
//      Navigator.pushAndRemoveUntil(
//          context,
//          MaterialPageRoute(
//            builder: (context) => HomeScreen(),
//          ),
//          (route) => false);
//    } on FirebaseAuthException catch (e) {
//      setState(() {
//        isLoading = false;
//      });
//      if (e.code == 'user-not-found') {
//        // ignore: deprecated_member_use
//        _scaffoldKey.currentState!.showSnackBar(
//          const SnackBar(
//            backgroundColor: Colors.red,
//            content: Text(
//              "No User Found for that Email",
//              style: TextStyle(fontSize: 15.0, color: Colors.white),
//            ),
//          ),
//        );
//      } else if (e.code == 'wrong-password') {
//        setState(() {
//          isLoading = false;
//        });
//        // ignore: deprecated_member_use
//        _scaffoldKey.currentState!.showSnackBar(
//          const SnackBar(
//            backgroundColor: Colors.red,
//            content: Text(
//              "Wrong Password Provided by User",
//              style: TextStyle(fontSize: 15.0, color: Colors.white),
//            ),
//          ),
//        );
//      }
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    print("SigninScreen Bulid Run");
//
//    return Stack(
//      children: [
//        Image.asset(
//          'images/background.jpg',
//          height: MediaQuery.of(context).size.height,
//          width: MediaQuery.of(context).size.width,
//          fit: BoxFit.cover,
//        ),
//        Scaffold(
//          key: _scaffoldKey,
//          backgroundColor: Colors.transparent,
//          body: Stack(
//            children: [
//              Align(
//                alignment: Alignment.topCenter,
//                child: Padding(
//                  padding: const EdgeInsets.only(top: 35.0),
//                  child: Column(
//                    children: [
//                      RichText(
//                        text: TextSpan(
//                          text: 'REE ',
//                          style: TextStyle(color: whiteColor, fontSize: 40),
//                          children: <TextSpan>[
//                            TextSpan(
//                                text: 'GIG',
//                                style: TextStyle(
//                                    color: whiteColor,
//                                    fontSize: 40,
//                                    fontWeight: FontWeight.bold)),
//                          ],
//                        ),
//                      ),
//                      Text('LOGIN',
//                          style: TextStyle(color: whiteColor, fontSize: 25)),
//                    ],
//                  ),
//                ),
//              ),
//              Align(
//                alignment: Alignment.center,
//                child: Padding(
//                  padding: const EdgeInsets.only(top: 50.0),
//                  child: Container(
//                    height: MediaQuery.of(context).size.height - 330,
//                    width: MediaQuery.of(context).size.width - 70,
//                    decoration: BoxDecoration(
//                      color: whiteColor,
//                      borderRadius: const BorderRadius.all(Radius.circular(20)),
//                      boxShadow: const [
//                        BoxShadow(
//                          color: Colors.black,
//                          blurRadius: 2.0,
//                          spreadRadius: 0.0,
//                          offset: Offset(
//                              2.0, 2.0), // shadow direction: bottom right
//                        )
//                      ],
//                    ),
//                    child: Form(
//                      key: _formKey,
//                      child: ListView(
//                        shrinkWrap: true,
//                        children: [
//                          Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              Padding(
//                                padding: const EdgeInsets.only(
//                                    left: 15.0,
//                                    right: 15.0,
//                                    bottom: 20.0,
//                                    top: 10.0),
//                                child: TextFormField(
//                                  readOnly: _isreadOnly,
//                                  keyboardType: TextInputType.emailAddress,
//                                  autofillHints: const [AutofillHints.email],
//                                  decoration: InputDecoration(
//                                    border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                    ),
//                                    focusedBorder: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                      borderSide: BorderSide(
//                                          color: darkPurple, width: 2.0),
//                                    ),
//                                    hintText: 'Email',
//                                    labelText: 'Email',
//                                    isDense: true,
//                                    labelStyle: const TextStyle(
//                                        color: Colors.black, fontSize: 18),
//                                    prefixIcon: const Icon(
//                                      Icons.email,
//                                      color: Colors.black,
//                                    ),
//                                    prefixText: '  ',
//                                    suffixIcon: isValidEmail
//                                        ? const Icon(Icons.check,
//                                            color: Colors.green, size: 20.0)
//                                        : null,
//                                  ),
//                                  controller: emailController,
//                                  validator: MultiValidator([
//                                    RequiredValidator(
//                                        errorText: 'Please enter email'),
//                                    EmailValidator(
//                                        errorText: 'Not a Valid Email'),
//                                  ]),
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(
//                                    left: 15.0, right: 15.0, bottom: 10.0),
//                                child: TextFormField(
//                                  obscureText: _obscureText,
//                                  readOnly: _isreadOnly,
//                                  decoration: InputDecoration(
//                                    border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                    ),
//                                    hintText: 'Password',
//                                    labelText: 'Password',
//                                    isDense: true,
//                                    focusedBorder: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                      borderSide: BorderSide(
//                                          color: darkPurple, width: 2.0),
//                                    ),
//                                    labelStyle: const TextStyle(
//                                        color: Colors.black, fontSize: 18),
//                                    prefixIcon: const Icon(
//                                      Icons.vpn_key,
//                                      color: Colors.black,
//                                    ),
//                                    prefixText: '  ',
//                                    suffixIcon: GestureDetector(
//                                      child: _obscureText
//                                          ? const Icon(
//                                              Icons.visibility,
//                                              size: 20.0,
//                                              color: Colors.black,
//                                            )
//                                          : const Icon(
//                                              Icons.visibility_off,
//                                              size: 20.0,
//                                              color: Colors.black,
//                                            ),
//                                      onTap: () {
//                                        setState(() {
//                                          _obscureText = !_obscureText;
//                                        });
//                                      },
//                                    ),
//                                  ),
//                                  controller: passwordController,
//                                  validator: validatePassword,
//                                ),
//                              ),
//                              // ignore: deprecated_member_use
//                              Material(
//                                color: lightPurple,
//                                clipBehavior: Clip.antiAlias,
//                                borderRadius: BorderRadius.circular(30.0),
//                                child: MaterialButton(
//                                  minWidth: 250.0,
//                                  height: 40.0,
//                                  elevation: 2.0,
//                                  padding: const EdgeInsets.symmetric(
//                                      vertical: 10.0),
//                                  onPressed: () {
//                                    SystemChannels.textInput
//                                        .invokeMethod('TextInput.hide');
//
//                                    if (_formKey.currentState!.validate()) {
//                                      setState(() {
//                                        isValidEmail = true;
//                                        email = emailController.text;
//                                        password = passwordController.text;
//                                      });
//                                      userSignin();
//                                    }
//                                  },
//                                  child: isLoading
//                                      ? Row(
//                                          mainAxisSize: MainAxisSize.min,
//                                          children: [
//                                            const CircularProgressIndicator(
//                                              color: Colors.white,
//                                              strokeWidth: 2.0,
//                                            ),
//                                            const SizedBox(
//                                              width: 15.0,
//                                            ),
//                                            Text(
//                                              'Please Wait...',
//                                              style: TextStyle(
//                                                color: whiteColor,
//                                              ),
//                                            ),
//                                          ],
//                                        )
//                                      : Text(
//                                          'Log In',
//                                          style: TextStyle(
//                                            color: whiteColor,
//                                          ),
//                                        ),
//                                ),
//                              ),
//                              const Divider(
//                                indent: 30.0,
//                                endIndent: 30.0,
//                                thickness: 2.0,
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(bottom: 8.0),
//                                child: Material(
//                                  color: Colors.blue[900],
//                                  clipBehavior: Clip.antiAlias,
//                                  borderRadius: BorderRadius.circular(5.0),
//                                  child: MaterialButton(
//                                    minWidth: 200.0,
//                                    height: 40.0,
//                                    padding: const EdgeInsets.symmetric(
//                                        vertical: 10.0),
//                                    onPressed: () {
//                                      SystemChannels.textInput
//                                          .invokeMethod('TextInput.hide');
//                                    },
//                                    child: Text(
//                                      'Log In With Facebook',
//                                      style: TextStyle(
//                                        color: whiteColor,
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(bottom: 8.0),
//                                child: Material(
//                                  color: Colors.blue[500],
//                                  clipBehavior: Clip.antiAlias,
//                                  borderRadius: BorderRadius.circular(5.0),
//                                  child: MaterialButton(
//                                    minWidth: 200.0,
//                                    height: 40.0,
//                                    padding: const EdgeInsets.symmetric(
//                                        vertical: 10.0),
//                                    onPressed: () {
//                                      SystemChannels.textInput
//                                          .invokeMethod('TextInput.hide');
//                                    },
//                                    child: Text(
//                                      'Log In With Twitter',
//                                      style: TextStyle(
//                                        color: whiteColor,
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(bottom: 8.0),
//                                child: Material(
//                                  color: Colors.red[500],
//                                  clipBehavior: Clip.antiAlias,
//                                  borderRadius: BorderRadius.circular(5.0),
//                                  child: MaterialButton(
//                                    minWidth: 200.0,
//                                    height: 40.0,
//                                    padding: const EdgeInsets.symmetric(
//                                        vertical: 10.0),
//                                    onPressed: () {
//                                      SystemChannels.textInput
//                                          .invokeMethod('TextInput.hide');
//                                    },
//                                    child: Text(
//                                      'Log In With Google+',
//                                      style: TextStyle(
//                                        color: whiteColor,
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(bottom: 5.0),
//                                child: Column(children: [
//                                  TextButton(
//                                    onPressed: () => {
//                                      Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                          builder: (context) =>
//                                              const ForgotPassword(),
//                                        ),
//                                      )
//                                    },
//                                    child: Text(
//                                      'FORGET PASSWORD?',
//                                      style: TextStyle(
//                                          fontSize: 14.0,
//                                          color: whiteColor,
//                                          backgroundColor: Colors.pinkAccent
//                                              .withOpacity(0.7)),
//                                    ),
//                                  ),
//                                  Text("DON'T HAVE ACCOUNT? ",
//                                      style: TextStyle(color: blackColor)),
//                                  TextButton(
//                                    onPressed: () => {
//                                      SystemChannels.textInput
//                                          .invokeMethod('TextInput.hide'),
//                                      Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                          builder: (context) =>
//                                              const RegisterScreen(),
//                                        ),
//                                      )
//                                    },
//                                    child: Text(
//                                      'CREATE ACCOUNT',
//                                      style: TextStyle(
//                                          color: whiteColor,
//                                          backgroundColor: Colors.pinkAccent
//                                              .withOpacity(0.7)),
//                                    ),
//                                  )
//                                ]),
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ],
//    );
//  }
//}
