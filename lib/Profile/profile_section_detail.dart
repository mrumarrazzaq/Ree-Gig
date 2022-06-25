// ignore_for_file: prefer_const_constructors

//import 'package:authentication/pages/user/Profile/user_profile_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/project_constants.dart';
//import 'package:velocity_x/velocity_x.dart';

class ProfileSectionDetail extends StatefulWidget {
  const ProfileSectionDetail({Key? key}) : super(key: key);

  @override
  State<ProfileSectionDetail> createState() => _ProfileSectionDetailState();
}

class _ProfileSectionDetailState extends State<ProfileSectionDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  String _currentPassword = '';
  fetch() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user!.email);

    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.email)
          .get()
          .then((ds) {
        personName = ds['personName'];
        _currentPassword = ds['password'];
      });
      print('---------------');
      print(_currentPassword);
      setState(() {
        _currentPassword = _currentPassword;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String? personName;
  String? email;

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

  String? validateCurrentPassword(value) {
    print('======================');
    print('_currentPassword : $_currentPassword');
    print('currentPasswordController.text : ${currentPasswordController.text}');

    if (value.isEmpty) {
      return 'Please enter current password';
    } else if (_currentPassword != currentPasswordController.text) {
      return 'Wrong current password';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Account Detail ',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Person Name
              GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    builder: (BuildContext context) {
                      return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Container(
                              child: Wrap(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          size: 15,
                                        )),
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          updateData(title: 'personName');
                                        }
                                      },
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 10.0,
                                              width: 10.0,
                                              child: CircularProgressIndicator(
                                                color: blackColor,
                                                strokeWidth: 1.0,
                                              ),
                                            )
                                          : Text(
                                              "Done",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: personNameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter name";
                                      }
                                    },
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        hintText: personName,
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 0.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
                                        )),
                                  ),
                                ),
                              ),
                              Text(' '),
                            ],
                          )));
                    },
                  );
                },
                child: ListTile(
                  title: Text(
                    'Name',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  subtitle: Text(
                    '$personName',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
              ),

              Divider(
                thickness: 2,
              ),
              //Password
              GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    builder: (BuildContext context) {
                      return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Container(
                              child: Wrap(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          newPasswordController.clear();
                                          currentPasswordController.clear();
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          size: 15,
                                        )),
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          updateData(title: 'password');
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                        }
                                      },
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 10.0,
                                              width: 10.0,
                                              child: CircularProgressIndicator(
                                                color: blackColor,
                                                strokeWidth: 1.0,
                                              ),
                                            )
                                          : Text(
                                              'Done',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: TextFormField(
                                          obscureText: _obscureText1,
                                          controller: currentPasswordController,
                                          validator: validateCurrentPassword,
                                          decoration: InputDecoration(
                                            hintText: 'Current Password',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0),
                                            ),
                                            // suffixIcon: GestureDetector(
                                            //   child: _obscureText1
                                            //       ? Icon(
                                            //           Icons.visibility,
                                            //           size: 20.0,
                                            //           color: blackColor,
                                            //         )
                                            //       : Icon(
                                            //           Icons.visibility_off,
                                            //           size: 20.0,
                                            //           color: blackColor,
                                            //         ),
                                            //   onTap: () {
                                            //     setState(() {
                                            //       _obscureText1 =
                                            //           !_obscureText1;
                                            //     });
                                            //   },
                                            // ),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        obscureText: _obscureText2,
                                        controller: newPasswordController,
                                        validator: validatePassword,
                                        decoration: InputDecoration(
                                          hintText: 'New Password',
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2.0),
                                          ),
                                          // suffixIcon: GestureDetector(
                                          //   child: _obscureText2
                                          //       ? Icon(
                                          //           Icons.visibility,
                                          //           size: 18.0,
                                          //           color: blackColor,
                                          //         )
                                          //       : Icon(
                                          //           Icons.visibility_off,
                                          //           size: 18.0,
                                          //           color: blackColor,
                                          //         ),
                                          //   onTap: () {
                                          //     setState(() {
                                          //       _obscureText2 = !_obscureText2;
                                          //     });
                                          //   },
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(' '),
                            ],
                          )));
                    },
                  );
                },
                child: ListTile(
                  title: Text(
                    'Password',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  subtitle: Text(
                    '*********',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              //Email
              ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                subtitle: Text(
                  '$currentUserEmail',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        .catchError((error) => print('Failed to Update Password $error'));
  }

  updateData({required String title}) async {
    final user = FirebaseAuth.instance.currentUser;
    print(user!.email);
    _isLoading = true;
    if (title == 'personName') {
      try {
        await FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .update({'personName': personNameController.text});
        Fluttertoast.showToast(
          msg: 'Name Changed Successfully', // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
          backgroundColor: Colors.green,
        );
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print("Name changes Fail");
      }
    } else if (title == 'password') {
      try {
        final ref = FirebaseAuth.instance.currentUser;
        await ref!.updatePassword(newPasswordController.text);
        await updatePassword();
        Fluttertoast.showToast(
          msg: 'Password Changed Successfully', // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
          backgroundColor: Colors.green,
        );

        if (ref == null) {}
        setState(() {
          _isLoading = false;
        });
        currentPasswordController.clear();
        newPasswordController.clear();
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Something went wrong', // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
          backgroundColor: Colors.black,
        );
        print("Password changes Fail");
      }
    }
    Navigator.pop(context);
  }
}
