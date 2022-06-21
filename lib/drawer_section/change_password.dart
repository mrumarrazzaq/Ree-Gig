import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/security_section/signin_screen2.dart';

class ChangePassword extends StatefulWidget {
  static const String id = 'ChangePassword';
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  var newPassword = "";
  final newPasswordController = TextEditingController();

  String? validatePassword(value) {
    if (value.isEmpty) {
      return 'Please enter new password*';
    } else if (value.length < 8) {
      return 'Should be at least 8 characters';
    } else if (value.length > 25) {
      return 'Should not be more than 25 characters';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPasswordController.dispose();
    super.dispose();
  }

  // final currentUser = FirebaseAuth.instance.currentUser;
  // changePassword() async {
  //   try {
  //     await currentUser!.updatePassword(newPassword);
  //     FirebaseAuth.instance.signOut();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => Login()),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.orangeAccent,
  //         content: Text(
  //           'Your Password has been Changed. Login again !',
  //           style: TextStyle(fontSize: 18.0),
  //         ),
  //       ),
  //     );
  //   } catch (e) {}
  // }

  final currentUser = FirebaseAuth.instance.currentUser;

  //Update Password
  CollectionReference password =
      FirebaseFirestore.instance.collection('User Data');

  Future<void> updatePassword() {
    return password
        .doc(currentUserEmail)
        .update({
          'password': newPasswordController.text,
        })
        .then((value) => print('Password Update by email : $currentUserEmail'))
        .catchError((error) => print('Faild to Update Password $error'));
  }

  changePassword() async {
    try {
//      await currentUser!.updatePassword(newPasswordController.text);
      _isLoading = true;
      final ref = FirebaseAuth.instance.currentUser;
      await ref!.updatePassword(newPasswordController.text);
      if (ref == null) {}
      await updatePassword();
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
        msg: 'Password has been Changed', // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        backgroundColor: Colors.green,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );

//      ScaffoldMessenger.of(context).showSnackBar(
//        const SnackBar(
//          backgroundColor: Colors.green,
//          content: Text(
//            'Your Password has been Changed. Login again !',
//            style: TextStyle(fontSize: 18.0),
//          ),
//        ),
//      );

      // ignore: empty_catches
    } catch (e) {
      print("Password chages Fail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Change Password',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 20.0, top: 50.0),
                  child: TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      hintText: 'New Password',
                      labelText: 'New Password',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: lightPurple, width: 2.0),
                      ),
                      labelStyle: TextStyle(color: defaultUIColor),
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: defaultUIColor,
                      ),
                      prefixText: '  ',
                      suffixIcon: GestureDetector(
                        child: _obscureText
                            ? Icon(
                                Icons.visibility,
                                size: 20.0,
                                color: defaultUIColor,
                              )
                            : Icon(
                                Icons.visibility_off,
                                size: 20.0,
                                color: defaultUIColor,
                              ),
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    controller: newPasswordController,
                    validator: validatePassword,
                  ),
                ),
                // ignore: deprecated_member_use
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5.0),
                    backgroundColor: MaterialStateProperty.all(defaultUIColor),
                    minimumSize: MaterialStateProperty.all(const Size(180, 40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
//                            side: BorderSide(color: deffaultUIElemetsColour),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        newPassword = newPasswordController.text;
                      });
                      changePassword();
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
                                color: whiteColor,
                                strokeWidth: 2.0,
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              'Please Wait...',
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Change Password',
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                ),
//                  Material(
//                    color: deffaultUIElemetsColour,
//                    borderRadius: BorderRadius.circular(10.0),
//                    child: MaterialButton(
//                      minWidth: 200.0,
//                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                      onPressed: () {
//                        if (_formKey.currentState!.validate()) {
//                          setState(() {
//                            newPassword = newPasswordController.text;
//                          });
//                          changePassword();
//                        }
//                      },
//                      child: const Text('Change Password'),
//                    ),
//                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
