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
//import 'package:ree_gig/security_section/signin_screen2.dart';
//import 'package:ree_gig/security_section/signin_screen3.dart';
//
////final user = FirebaseFirestore.instance;
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
//      return 'required*';
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
////          'firstname': personName,
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
//    return Scaffold(
//      key: _scaffoldKey,
//      backgroundColor: whiteColor,
//      body: Center(
//        child: ListView(
//          shrinkWrap: true,
//          children: [
//            Form(
//              key: _formKey,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                  SizedBox(
//                    width: 150.0,
//                    height: 150.0,
//                    child: Image.asset(
//                      'images/credentials.png',
////                        color: defaultUIColor,
////                        width: 100.0,
////                        height: 100.0,
//                    ),
//                  ),
////                  Text.rich(
////                    TextSpan(
////                      text: '', // default text style
////                      style: const TextStyle(fontSize: 30.0),
////                      children: <TextSpan>[
////                        TextSpan(
////                            text: 'REE ',
////                            style: TextStyle(
////                                fontStyle: FontStyle.italic,
////                                color: whiteColor)),
////                        TextSpan(
////                            text: 'GIG',
////                            style: TextStyle(
////                                fontWeight: FontWeight.bold,
////                                color: whiteColor)),
////                      ],
////                    ),
////                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(bottom: 10.0),
//                    child: Text(
//                      'REGISTER',
//                      style: TextStyle(
//                        fontSize: 30,
//                        color: lightPurple,
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        left: 20.0, right: 20.0, bottom: 20.0),
//                    child: TextFormField(
//                      keyboardType: TextInputType.text,
////                      cursorColor: Colors.white,
//                      style: TextStyle(color: lightPurple),
//                      decoration: InputDecoration(
//                        isDense: true,
////                        fillColor: lightPurple,
////                        filled: true,
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                        ),
//                        focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                          borderSide: BorderSide(color: darkPurple, width: 1.5),
//                        ),
//                        enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                          borderSide:
//                              BorderSide(color: lightPurple, width: 1.5),
//                        ),
//                        hintText: 'Name',
//                        hintStyle: TextStyle(color: lightPurple),
////                        labelText: 'First Name',
////                        labelStyle: TextStyle(color: whiteColor),
//                        prefixIcon: Icon(
//                          Icons.person,
//                          color: lightPurple,
//                        ),
//                        prefixText: '  ',
//                      ),
//                      controller: personNameController,
//                      validator: (String? val) {
//                        if (val!.isEmpty) {
//                          return "Please enter name";
//                        } else if (double.tryParse(val) != null) {
//                          return 'numbers not allowed';
//                        }
//                        return null;
//                      },
//                    ),
//                  ),
//
//                  //Email Address
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        left: 20.0, right: 20.0, bottom: 20.0),
//                    child: TextFormField(
//                      keyboardType: TextInputType.emailAddress,
//                      cursorColor: lightPurple,
//                      style: TextStyle(color: lightPurple),
//                      decoration: InputDecoration(
//                        isDense: true,
////                        fillColor: lightPurple,
////                        filled: true,
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                        ),
//                        focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                          borderSide: BorderSide(color: darkPurple, width: 1.5),
//                        ),
//                        enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                          borderSide:
//                              BorderSide(color: lightPurple, width: 1.5),
//                        ),
//                        hintText: 'Email',
//                        hintStyle: TextStyle(color: lightPurple),
////                        labelText: 'Email',
////                        labelStyle: TextStyle(color: defaultUIColor),
//                        prefixIcon: Icon(
//                          Icons.email,
//                          color: lightPurple,
//                        ),
//                        prefixText: '  ',
//                        suffixIcon: isValidEmail
//                            ? const Icon(Icons.check,
//                                color: Colors.green, size: 20.0)
//                            : null,
//                      ),
//                      controller: emailController,
//                      validator: MultiValidator(
//                        [
//                          RequiredValidator(errorText: 'Please enter a email*'),
//                          EmailValidator(errorText: 'Not a Valid Email'),
//                        ],
//                      ),
//                    ),
//                  ),
//                  //Password
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        left: 20.0, right: 20.0, bottom: 20.0),
//                    child: TextFormField(
//                      obscureText: _obscurePassword,
//                      cursorColor: lightPurple,
//                      style: TextStyle(color: lightPurple),
//                      decoration: InputDecoration(
//                        isDense: true,
////                        fillColor: lightPurple,
////                        filled: true,
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                        ),
//                        hintText: 'Password',
//                        hintStyle: TextStyle(color: lightPurple),
////                        labelText: 'Password',
//                        focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                          borderSide: BorderSide(color: darkPurple, width: 1.5),
//                        ),
//                        enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                          borderSide:
//                              BorderSide(color: lightPurple, width: 1.5),
//                        ),
////                        labelStyle: TextStyle(color: defaultUIColor),
//                        prefixIcon: Icon(
//                          Icons.vpn_key,
//                          color: lightPurple,
//                        ),
//                        prefixText: '  ',
//                        suffixIcon: GestureDetector(
//                          child: _obscurePassword
//                              ? Icon(
//                                  Icons.visibility,
//                                  size: 15.0,
//                                  color: lightPurple,
//                                )
//                              : Icon(
//                                  Icons.visibility_off,
//                                  size: 15.0,
//                                  color: lightPurple,
//                                ),
//                          onTap: () {
//                            setState(() {
//                              _obscurePassword = !_obscurePassword;
//                            });
//                          },
//                        ),
//                      ),
//                      controller: passwordController,
//                      validator: validatePassword,
//                    ),
//                  ),
//                  //Confirm Password
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        left: 20.0, right: 20.0, bottom: 20.0),
//                    child: TextFormField(
//                      obscureText: _obscureConfirmPassword,
//                      cursorColor: lightPurple,
//                      style: TextStyle(color: lightPurple),
//                      decoration: InputDecoration(
//                        isDense: true,
////                        fillColor: lightPurple,
////                        filled: true,
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                        ),
//                        hintText: 'Confirm Password',
//                        hintStyle: TextStyle(color: lightPurple),
////                        labelText: 'Confirm Password',
//                        focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                          borderSide: BorderSide(color: darkPurple, width: 1.5),
//                        ),
//                        enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                          borderSide:
//                              BorderSide(color: lightPurple, width: 1.5),
//                        ),
////                        labelStyle: TextStyle(color: whiteColor),
//                        prefixIcon: Icon(
//                          Icons.vpn_key,
//                          color: lightPurple,
//                        ),
//                        prefixText: '  ',
//                        suffixIcon: GestureDetector(
//                          child: _obscureConfirmPassword
//                              ? Icon(
//                                  Icons.visibility,
//                                  size: 15.0,
//                                  color: lightPurple,
//                                )
//                              : Icon(
//                                  Icons.visibility_off,
//                                  size: 15.0,
//                                  color: lightPurple,
//                                ),
//                          onTap: () {
//                            setState(() {
//                              _obscureConfirmPassword =
//                                  !_obscureConfirmPassword;
//                            });
//                          },
//                        ),
//                      ),
//                      controller: confirmPasswordController,
//                      validator: validatePassword,
//                    ),
//                  ),
//                  //Register Button
//                  Material(
//                    color: lightPurple,
//                    borderRadius: BorderRadius.circular(30.0),
//                    child: MaterialButton(
//                      minWidth: 160.0,
//                      height: 40.0,
//                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                      onPressed: () {
//                        SystemChannels.textInput.invokeMethod('TextInput.hide');
//                        if (_formKey.currentState!.validate()) {
//                          setState(() {
//                            isValidEmail = true;
//                            personName = personNameController.text;
//                            email = emailController.text;
//                            password = passwordController.text;
//                            confirmPassword = confirmPasswordController.text;
//                          });
////                          registration();
//                        }
//                      },
//                      child: isLoading
//                          ? Row(
//                              mainAxisSize: MainAxisSize.min,
//                              children: [
//                                SizedBox(
//                                  height: 30.0,
//                                  width: 30.0,
//                                  child: CircularProgressIndicator(
//                                    color: whiteColor,
//                                    strokeWidth: 2.0,
//                                  ),
//                                ),
//                                const SizedBox(
//                                  width: 15.0,
//                                ),
//                                Text(
//                                  'Please Wait...',
//                                  style: TextStyle(
//                                    color: whiteColor,
//                                  ),
//                                ),
//                              ],
//                            )
//                          : Text(
//                              'Register',
//                              style: TextStyle(
//                                color: whiteColor,
//                              ),
//                            ),
//                    ),
//                  ),
//
//                  //Other options
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      Text("Already have an Account? ",
//                          style: TextStyle(color: blackColor)),
//                      TextButton(
//                          onPressed: () => {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                    builder: (context) => SigninScreen(),
//                                  ),
//                                )
//                              },
//                          child: const Text('Signin'))
//                    ],
//                  ),
//                  Text(
//                    "___________     OR     ___________",
//                    style: TextStyle(
////                        backgroundColor: darkPurple,
//                        color: blackColor,
//                        fontFamily: 'SourceSansPro',
//                        fontWeight: FontWeight.bold),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(top: 8.0),
//                    child:
//                        Text('Login with', style: TextStyle(color: blackColor)),
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      MaterialButton(
//                        clipBehavior: Clip.antiAlias,
//                        shape: const CircleBorder(),
//                        minWidth: 10.0,
//                        onPressed: () {},
//                        child: Container(
//                          decoration: BoxDecoration(
//                              color: whiteColor,
//                              borderRadius: BorderRadius.circular(30.0)),
//                          child: Image.asset(
//                            'icons/google-plus.png',
//                            height: 30.0,
//                            width: 30.0,
//                          ),
//                        ),
//                      ),
//                      MaterialButton(
//                        clipBehavior: Clip.antiAlias,
//                        shape: const CircleBorder(),
//                        minWidth: 10.0,
//                        onPressed: () {},
//                        child: Image.asset(
//                          'icons/facebook.png',
//                          height: 35.0,
//                          width: 35.0,
//                        ),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
