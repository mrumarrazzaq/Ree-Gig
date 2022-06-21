//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/Profile/profile_header.dart';
//import 'package:ree_gig/Profile/profile_header.dart';

//final registeredEmail = FirebaseAuth.instance.currentUser!.email;

// ignore: must_be_immutable
class UserProfileSection extends StatefulWidget {
  static const String id = 'UserProfile';
  String personName;
  String imageURL;
  UserProfileSection({
    required this.personName,
    required this.imageURL,
    Key? key,
  }) : super(key: key);

  @override
  _UserProfileSectionState createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//  final uid = FirebaseAuth.instance.currentUser!.uid;
//  final email = FirebaseAuth.instance.currentUser!.email;
//  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;
//  User? user = FirebaseAuth.instance.currentUser;
//
//  final Stream<QuerySnapshot> registeredUser =
//      FirebaseFirestore.instance.collection('$registeredEmail').snapshots();

//  verifyEmail() async {
//    if (user != null && !user!.emailVerified) {
//      await user!.sendEmailVerification();
//
//      // ignore: deprecated_member_use
//      _scaffoldKey.currentState!.showSnackBar(
//        const SnackBar(
//          backgroundColor: Colors.green,
//          content: Text(
//            'Verification Email has been sent',
//            style: TextStyle(
//              fontSize: 18.0,
//            ),
//          ),
//        ),
//      );
//    }
//  }

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
                  text: 'User Profile ',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileHeader(
                personName: widget.personName, imageURL: widget.imageURL),

//              ListTile(
//                title: Text(
//                  'User ID: $uid',
//                  style: const TextStyle(fontSize: 15.0),
//                ),
//              ),
//              ListTile(
//                title: Text(
//                  'First Name : ${widget.firstName}',
//                  style: const TextStyle(fontSize: 15.0),
//                ),
//              ),
//              ListTile(
//                title: Text(
//                  'Last Name : ${widget.lastName}',
//                  style: TextStyle(fontSize: 15.0),
//                ),
//              ),
//              ListTile(
//                title: Text(
//                  'Email: $email',
//                  style: TextStyle(fontSize: 18.0),
//                ),
//              ),
//              user!.emailVerified
//                  ? const Text(
//                      'verified',
//                      style: TextStyle(fontSize: 10.0, color: Colors.blueGrey),
//                    )
//                  : TextButton(
//                      onPressed: () => {verifyEmail()},
//                      child: const Text('Verify Email'),
//                    ),
//              const ProfileMenuSection(),
//              ListTile(
//                title: Text(
//                  'Created: $creationTime',
//                  style: TextStyle(fontSize: 18.0),
//                ),
//              ),
          ],
        ),
      ),
    );
  }
}
