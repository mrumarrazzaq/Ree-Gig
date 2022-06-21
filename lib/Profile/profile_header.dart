// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ree_gig/Profile/profile_section_detail.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:ree_gig/security_section/signin_screen2.dart';

String image = '';

class ProfileHeader extends StatefulWidget {
  String personName;
  String imageURL;

  ProfileHeader({required this.personName, required this.imageURL, Key? key})
      : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  bool _isLoading = false;

  void initState() {
    imageUrl = widget.imageURL;
    fetch();
    super.initState();
  }

  uploadImage(String path) async {
//    final user = FirebaseAuth.instance.currentUser;
//    close = context.showLoading(msg: "Uploading", textColor: Colors.white);
    setState(() {
      _isLoading = true;
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("profileImages/$currentUserEmail");
    UploadTask uploadTask = ref.putFile(File(path));
    await uploadTask.whenComplete(() async {
      String url = await ref.getDownloadURL();
      print('----------------------------------');
      print('url : $url');
      updateImage(url);
      setState(() {});
    }).catchError((onError) {
      print('---------------------------------------');
      print('Error while uploading image');
      print(onError);
    });
  }

  updateImage(url) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user!.email)
          .update({'imageUrl': url});
    } catch (e) {
      print(e.toString());
    }
    await Future.delayed(Duration(milliseconds: 500), close);
    setState(() {
      _isLoading = false;
      imageUrl = url;
    });
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
        imageUrl = ds['imageUrl'];
      });
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final result = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    final path = result!.path;
    print('------------------------------------');
    print('Image Path : $path');
    image = path;
    uploadImage(path);
  }

  dynamic close;
  String imageUrl = "";
  String personName = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          Container(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                //main container
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: defaultUIColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        )),
                  ),
                ),
                Positioned.fill(
                    top: -50,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: widget.imageURL == ''
                          ? Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: defaultUIColor,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 5, color: Colors.white),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${widget.personName[0]} ${widget.personName[1]}',
                                  style: GoogleFonts.righteous(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            )
                          : Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl.toString()),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 5, color: Colors.white),
                              ),
                            ),
                    )),
                //Pick a image from gallery
                Positioned.fill(
                  left: 95.0,
                  top: 30.0,
                  child: GestureDetector(
                    onTap: () async {
                      pickImage();
                    },
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 85,
                      ),
                      Text(
                        widget.personName,
                        style: GoogleFonts.righteous(
                            fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                _isLoading == true
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: 150,
                                height: 95,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                )),
                          ),
                          Positioned.fill(
                            top: -10,
                            child: Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: lightPurple,
                                backgroundColor: whiteColor,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            top: 58,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Uploading Image',
                                  style: TextStyle(color: whiteColor)),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 22),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileSectionDetail()));
                    },
                    child: ListTile(
                      title: Text('Account'),
                      leading: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.black,
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
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text('About Us'),
                      leading: Icon(
                        Icons.info,
                        size: 30,
                        color: Colors.black,
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
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                          (route) => false);
                    },
                    child: ListTile(
                      title: Text("Log Out"),
                      leading: Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.black,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
