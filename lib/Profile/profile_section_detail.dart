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
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    fetch();
  }

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
      });
      setState(() {});
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
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 30.0,
                                                  width: 30.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: blackColor,
                                                    strokeWidth: 2.0,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15.0,
                                                ),
                                                Text(
                                                  'Please Wait...',
                                                  style: TextStyle(
                                                    color: blackColor,
                                                  ),
                                                ),
                                              ],
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
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 30.0,
                                                  width: 30.0,
                                                  child:
                                                      CircularProgressIndicator(
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
                                  child: TextFormField(
                                    controller: passwordController,
                                    validator: validatePassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: '********',
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

  //Update Passwrd
  CollectionReference password =
      FirebaseFirestore.instance.collection('User Data');
  Future<void> updatePassword() {
    return password
        .doc(currentUserEmail)
        .update({
          'password': passwordController.text,
        })
        .then((value) => print('Password Update by email : $currentUserEmail'))
        .catchError((error) => print('Faild to Update Password $error'));
  }

  updateData({required String title}) async {
    final user = FirebaseAuth.instance.currentUser;
    print(user!.email);

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
      } catch (e) {
        print("Name chages Fail");
      }
    } else if (title == 'password') {
      try {
        final ref = FirebaseAuth.instance.currentUser;
        await ref!.updatePassword(passwordController.text);
        await updatePassword();
        Fluttertoast.showToast(
          msg: 'Password Changed Successfully', // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
          backgroundColor: Colors.green,
        );
        if (ref == null) {}
      } catch (e) {
        print("Password chages Fail");
      }
    }
    Navigator.pop(context);
  }
}
