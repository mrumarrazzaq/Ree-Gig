//// ignore_for_file: avoid_print
//
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:form_field_validator/form_field_validator.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:ree_gig/project_constants.dart';
//import 'package:ree_gig/security_section/signin_screen.dart';
//
//final user = FirebaseFirestore.instance;
//
//class RegisterScreen extends StatefulWidget {
//  static const String id = 'RegisterScreen';
//
//  const RegisterScreen({Key? key}) : super(key: key);
//
//  @override
//  _RegisterScreenState createState() => _RegisterScreenState();
//}
//
//class _RegisterScreenState extends State<RegisterScreen> {
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//  bool _obscurePassword = true;
//  bool _obscureConfirmPassword = true;
//  bool isValidEmail = false;
//  bool isLoading = false;
//
//  var personName = "";
//  var email = "";
//  var password = "";
//  var confirmPassword = "";
//  var imageURL = "";
//  var userId = "";
//  final emailController = TextEditingController();
//  final passwordController = TextEditingController();
//  final confirmPasswordController = TextEditingController();
//
//  String? validatePassword(value) {
//    if (value.isEmpty) {
//      return 'Please enter a password';
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
//    // Clean up the controller when the widget is disposed.
//    personNameController.dispose();
//    emailController.dispose();
//    passwordController.dispose();
//    confirmPasswordController.dispose();
//    super.dispose();
//  }
//
//  registration() async {
//    if (password == confirmPassword) {
//      try {
//        print(personName);
//        print(email);
//        print(password);
//        print(confirmPassword);
//
//        isLoading = true;
////        UserCredential userCredential = await FirebaseAuth.instance
////            .createUserWithEmailAndPassword(email: email, password: password);
////        print(userCredential);
//        // ignore: deprecated_member_use
////        _scaffoldKey.currentState!.showSnackBar(
////          const SnackBar(
////            backgroundColor: Colors.green,
////            content: Text(
////              'Registered Successfully.. Now Login',
////              style: TextStyle(
////                fontSize: 15,
////                color: Colors.white,
////              ),
////            ),
////            duration: Duration(seconds: 10),
////          ),
////        );
////        final registeredUser =
////            // ignore: unnecessary_string_interpolations
////            FirebaseFirestore.instance.collection('userData').doc('$email');
////
////        final json = {
////          'firstname': firstname,
////          'lastname': lastname,
////          'imageUrl': imageURL,
////        };
//
////        user.collection('$email+userData').doc('$email').set(json);
//        Fluttertoast.showToast(
//          msg: 'Registered Successfully.. Now Login', // message
//          toastLength: Toast.LENGTH_SHORT, // length
//          gravity: ToastGravity.BOTTOM, // location
//          backgroundColor: Colors.green,
//        );
////        registeredUser.set(json);
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(builder: (context) => SigninScreen()),
//        );
//      } on FirebaseAuthException catch (e) {
//        setState(() {
//          isLoading = false;
//        });
//        if (e.code == 'weak-password') {
//          // ignore: deprecated_member_use
//          _scaffoldKey.currentState!.showSnackBar(
//            const SnackBar(
//              backgroundColor: Colors.red,
//              content: Text(
//                'Password Provided is too Weak!!',
//                style: TextStyle(
//                  fontSize: 15,
//                  color: Colors.white,
//                ),
//              ),
//            ),
//          );
//        } else if (e.code == 'email-already-in-use') {
//          setState(() {
//            isLoading = false;
//          });
//
//          // ignore: deprecated_member_use
//          _scaffoldKey.currentState!.showSnackBar(
//            const SnackBar(
//              backgroundColor: Colors.red,
//              content: Text(
//                'Sorry! Account Already Exist !',
//                style: TextStyle(
//                  fontSize: 15,
//                  color: Colors.white,
//                ),
//              ),
//              duration: Duration(seconds: 1),
//            ),
//          );
//        }
//      }
//    } else {
//      setState(() {
//        isLoading = false;
//      });
//      // ignore: deprecated_member_use
//      _scaffoldKey.currentState!.showSnackBar(
//        const SnackBar(
//          backgroundColor: Colors.red,
//          content: Text(
//            'Password and Confirm Password doesn\'t match!!',
//            style: TextStyle(fontSize: 15, color: Colors.white),
//          ),
//        ),
//      );
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    print("RegisterScreen Bulid Run");
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
//                  padding: const EdgeInsets.only(top: 30.0),
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
//                      Text('CREATE ACCOUNT',
//                          style: TextStyle(color: whiteColor, fontSize: 25)),
//                    ],
//                  ),
//                ),
//              ),
//              Align(
//                alignment: Alignment.center,
//                child: Padding(
//                  padding: const EdgeInsets.only(top: 40.0),
//                  child: Container(
//                    height: MediaQuery.of(context).size.height - 260,
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
//                                    left: 20.0,
//                                    right: 20.0,
//                                    bottom: 20.0,
//                                    top: 10.0),
//                                child: TextFormField(
//                                  keyboardType: TextInputType.emailAddress,
//                                  decoration: InputDecoration(
//                                    isDense: true,
//                                    border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                    ),
//                                    focusedBorder: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                      borderSide: BorderSide(
//                                          color: darkPurple, width: 2.0),
//                                    ),
//                                    hintText: 'Name',
//                                    labelText: 'Name',
//                                    labelStyle:
//                                        const TextStyle(color: Colors.black),
//                                    prefixIcon: const Icon(
//                                      Icons.person,
//                                      color: Colors.black,
//                                    ),
//                                    prefixText: '  ',
//                                  ),
//                                  controller: personNameController,
//                                  validator: (String? val) {
//                                    if (val!.isEmpty) {
//                                      return "Please enter a name";
//                                    } else if (double.tryParse(val) != null) {
//                                      return 'numbers not allowed';
//                                    }
//                                    return null;
//                                  },
//                                ),
//                              ),
//                              //Email Address
//                              Padding(
//                                padding: const EdgeInsets.only(
//                                    left: 20.0, right: 20.0, bottom: 20.0),
//                                child: TextFormField(
//                                  keyboardType: TextInputType.emailAddress,
//                                  decoration: InputDecoration(
//                                    isDense: true,
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
//                                    labelStyle:
//                                        const TextStyle(color: Colors.black),
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
//                                  validator: MultiValidator(
//                                    [
//                                      RequiredValidator(
//                                          errorText: 'Please enter a email'),
//                                      EmailValidator(
//                                          errorText: 'Not a Valid Email'),
//                                    ],
//                                  ),
//                                ),
//                              ),
//                              //Password
//                              Padding(
//                                padding: const EdgeInsets.only(
//                                    left: 20.0, right: 20.0, bottom: 20.0),
//                                child: TextFormField(
//                                  obscureText: _obscurePassword,
//                                  decoration: InputDecoration(
//                                    isDense: true,
//                                    border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                    ),
//                                    hintText: 'Password',
//                                    labelText: 'Password',
//                                    focusedBorder: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                      borderSide: BorderSide(
//                                          color: darkPurple, width: 2.0),
//                                    ),
//                                    labelStyle:
//                                        const TextStyle(color: Colors.black),
//                                    prefixIcon: const Icon(
//                                      Icons.vpn_key,
//                                      color: Colors.black,
//                                    ),
//                                    prefixText: '  ',
//                                    suffixIcon: GestureDetector(
//                                      child: _obscurePassword
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
//                                          _obscurePassword = !_obscurePassword;
//                                        });
//                                      },
//                                    ),
//                                  ),
//                                  controller: passwordController,
//                                  validator: validatePassword,
//                                ),
//                              ),
//                              //Confirm Password
//                              Padding(
//                                padding: const EdgeInsets.only(
//                                    left: 20.0, right: 20.0, bottom: 20.0),
//                                child: TextFormField(
//                                  obscureText: _obscureConfirmPassword,
//                                  decoration: InputDecoration(
//                                    isDense: true,
//                                    border: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                    ),
//                                    hintText: 'Confirm Password',
//                                    labelText: 'Confirm Password',
//                                    focusedBorder: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(10.0),
//                                      borderSide: BorderSide(
//                                          color: darkPurple, width: 2.0),
//                                    ),
//                                    labelStyle:
//                                        const TextStyle(color: Colors.black),
//                                    prefixIcon: Icon(
//                                      Icons.vpn_key,
//                                      color: blackColor,
//                                    ),
//                                    prefixText: '  ',
//                                    suffixIcon: GestureDetector(
//                                      child: _obscureConfirmPassword
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
//                                          _obscureConfirmPassword =
//                                              !_obscureConfirmPassword;
//                                        });
//                                      },
//                                    ),
//                                  ),
//                                  controller: confirmPasswordController,
//                                  validator: validatePassword,
//                                ),
//                              ),
//                              //Register Button
//                              Material(
//                                color: lightPurple,
//                                borderRadius: BorderRadius.circular(30.0),
//                                child: MaterialButton(
//                                  clipBehavior: Clip.antiAlias,
//                                  minWidth: 250.0,
//                                  height: 30.0,
//                                  padding: const EdgeInsets.symmetric(
//                                      vertical: 10.0),
//                                  onPressed: () {
//                                    SystemChannels.textInput
//                                        .invokeMethod('TextInput.hide');
//                                    if (_formKey.currentState!.validate()) {
//                                      setState(() {
//                                        isValidEmail = true;
//                                        personName = personNameController.text;
//                                        email = emailController.text;
//                                        password = passwordController.text;
//                                        confirmPassword =
//                                            confirmPasswordController.text;
//                                      });
//                                      registration();
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
//                                                color: lightPurple,
//                                              ),
//                                            ),
//                                          ],
//                                        )
//                                      : Text(
//                                          'Register',
//                                          style: TextStyle(
//                                            color: whiteColor,
//                                          ),
//                                        ),
//                                ),
//                              ),
//
//                              //Other options
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
//                                  Text("ALREADY HAVE HAVE ACCOUNT? ",
//                                      style: TextStyle(color: blackColor)),
//                                  TextButton(
//                                    onPressed: () => {
//                                      SystemChannels.textInput
//                                          .invokeMethod('TextInput.hide'),
//                                      Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                          builder: (context) => SigninScreen(),
//                                        ),
//                                      )
//                                    },
//                                    child: Text(
//                                      'LOGIN',
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
