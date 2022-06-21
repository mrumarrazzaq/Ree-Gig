// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ree_gig/admin_panel/start_myadmin_panel.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/security_section/forgot_password.dart';
import 'package:ree_gig/security_section/register_screen2.dart';

class AdminSignInScreen extends StatefulWidget {
  static const String id = 'SigninScreen';

  AdminSignInScreen({Key? key}) : super(key: key);

  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool isValidEmail = false;
  bool _isLoading = false;

  var email = "";
  var password = "";
  var adminKey = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final adminKeyController = TextEditingController();
  final storage = FlutterSecureStorage();

  String? validatePassword(value) {
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (value.length < 8) {
      return 'Should be at least 8 characters';
    } else if (value.length > 25) {
      return 'Should not be more than 25 characters';
    } else {
      return null;
    }
  }

  String? validateAdminKey(value) {
    if (value.isEmpty) {
      return 'Please enter admin key';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    adminKeyController.dispose();
    super.dispose();
  }

  userSignIn() async {
    try {
      _isLoading = true;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
//      //______________________________________________________________________//
      print('user credential email : ${userCredential.user?.email}');
//      //STORE user id into the Local Database
      await storage.write(key: 'uid', value: userCredential.user?.uid);
      //______________________________________________________________________//
      // ignore: deprecated_member_use
//      _scaffoldKey.currentState!.showSnackBar(
//        const SnackBar(
//          backgroundColor: Colors.green,
//          content: Text(
//            "Login Successfully",
//            style: TextStyle(fontSize: 10.0, color: Colors.white),
//          ),
//          duration: Duration(seconds: 30),
//        ),
//      );
      Fluttertoast.showToast(
        msg: 'Admin Login Successfully', // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        backgroundColor: Colors.green,
      );

      saveAdminLogin(true);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => StartMyAdminPanel(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.code == 'user-not-found') {
        // ignore: deprecated_member_use
        _scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No Admin Found for that Email",
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        setState(() {
          _isLoading = false;
        });
        // ignore: deprecated_member_use
        _scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Wrong Password Provided by Admin",
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("SigninScreen Bulid Run");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: darkPurple,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 80.0,
                    foregroundImage: AssetImage(
                      'images/access_account.png',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Admin Login',
                      style: TextStyle(
                        fontSize: 25,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: lightPurple,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: whiteColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: lightPurple, width: 1.5),
                        ),

                        hintText: 'Email',
//                        labelText: 'Email',
                        hintStyle: TextStyle(color: whiteColor),

//                        labelStyle: TextStyle(color: whiteColor),
                        prefixIcon: Icon(
                          Icons.email,
                          color: whiteColor,
                        ),
                        prefixText: '  ',
                        suffixIcon: isValidEmail
                            ? const Icon(Icons.check,
                                color: Colors.green, size: 20.0)
                            : null,
                      ),
                      controller: emailController,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Please enter email'),
                        EmailValidator(errorText: 'Not a Valid Email'),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 20.0),
                    child: TextFormField(
                      obscureText: _obscureText,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: lightPurple,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: whiteColor),
//                        labelText: 'Password',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: whiteColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: lightPurple, width: 1.5),
                        ),
//                        labelStyle: TextStyle(color: defaultUIColor),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: whiteColor,
                        ),
                        prefixText: '  ',
                        suffixIcon: GestureDetector(
                          child: _obscureText
                              ? Icon(
                                  Icons.visibility,
                                  size: 18.0,
                                  color: whiteColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  size: 18.0,
                                  color: whiteColor,
                                ),
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      controller: passwordController,
                      validator: validatePassword,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 20.0),
                    child: TextFormField(
                      obscureText: _obscureText2,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: lightPurple,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: 'Admin Key',
                        hintStyle: TextStyle(color: whiteColor),
//                        labelText: 'Password',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: whiteColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: lightPurple, width: 1.5),
                        ),
//                        labelStyle: TextStyle(color: defaultUIColor),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: whiteColor,
                        ),
                        prefixText: '  ',
                        suffixIcon: GestureDetector(
                          child: _obscureText2
                              ? Icon(
                                  Icons.visibility,
                                  size: 18.0,
                                  color: whiteColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  size: 18.0,
                                  color: whiteColor,
                                ),
                          onTap: () {
                            setState(() {
                              _obscureText2 = !_obscureText2;
                            });
                          },
                        ),
                      ),
                      controller: adminKeyController,
                      validator: validateAdminKey,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  Material(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(30.0),
                    clipBehavior: Clip.antiAlias,
                    child: MaterialButton(
                      minWidth: 160.0,
                      elevation: 3.0,
                      height: 40.0,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      onPressed: () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isValidEmail = true;
                            email = emailController.text;
                            password = passwordController.text;
                            adminKey = adminKeyController.text;
                          });
                          if (adminKey == "yeKeruceSyM") {
                            userSignIn();
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Not a valid Admin Key', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              backgroundColor: Colors.black,
                            );
                          }
                        }
                      },
                      child: _isLoading
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child: CircularProgressIndicator(
                                    color: lightPurple,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  'Please Wait...',
                                  style: TextStyle(
                                    color: lightPurple,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Login',
                              style: TextStyle(
                                color: lightPurple,
                              ),
                            ),
                    ),
                  ),

                  TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      )
                    },
                    child: const Text(
                      'Forgot Password ?',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account? ",
                          style: TextStyle(color: whiteColor)),
                      TextButton(
                          onPressed: () => {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide'),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                )
                              },
                          child: const Text('Register'))
                    ],
                  ),
                  Text(
                    "___________     OR     ___________",
                    style: TextStyle(
                        backgroundColor: darkPurple,
                        color: whiteColor,
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child:
                        Text('Login with', style: TextStyle(color: whiteColor)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        clipBehavior: Clip.antiAlias,
                        minWidth: 10.0,
                        shape: const CircleBorder(),
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Image.asset(
                            'icons/google-plus.png',
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                      ),
                      MaterialButton(
                        clipBehavior: Clip.antiAlias,
                        minWidth: 10.0,
                        shape: const CircleBorder(),
                        onPressed: () {},
                        child: Image.asset(
                          'icons/facebook.png',
                          height: 35.0,
                          width: 35.0,
                        ),
                      ),
                    ],
                  ),

//                  Padding(
//                    padding: const EdgeInsets.only(bottom: 8.0),
//                    child: Material(
//                      color: Colors.red[500],
//                      clipBehavior: Clip.antiAlias,
//                      borderRadius: BorderRadius.circular(5.0),
//                      child: MaterialButton(
//                        minWidth: 200.0,
//                        height: 40.0,
//                        padding: const EdgeInsets.symmetric(vertical: 10.0),
//                        onPressed: () {
//                          SystemChannels.textInput
//                              .invokeMethod('TextInput.hide');
//                        },
//                        child: Text(
//                          'Log In With Google+',
//                          style: TextStyle(
//                            color: whiteColor,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(bottom: 8.0),
//                    child: Material(
//                      color: Colors.blue[900],
//                      clipBehavior: Clip.antiAlias,
//                      borderRadius: BorderRadius.circular(5.0),
//                      child: MaterialButton(
//                        minWidth: 200.0,
//                        height: 40.0,
//                        padding: const EdgeInsets.symmetric(vertical: 10.0),
//                        onPressed: () {
//                          SystemChannels.textInput
//                              .invokeMethod('TextInput.hide');
//                        },
//                        child: Text(
//                          'Log In With Facebook',
//                          style: TextStyle(
//                            color: whiteColor,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
