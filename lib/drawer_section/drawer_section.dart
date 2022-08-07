// ignore_for_file: avoid_print, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/drawer_section/buyer_order_analytics.dart';
import 'package:ree_gig/drawer_section/seller_order_analytics.dart';
import 'package:ree_gig/drawer_section/user_profile_section.dart';
import 'package:ree_gig/home_screen.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/report_screen.dart';
import 'package:ree_gig/security_section/signin_screen2.dart';
import 'settings_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'privacy_policy.dart';

final registeredEmail = FirebaseAuth.instance.currentUser!.email;

class DrawerSection extends StatefulWidget {
  const DrawerSection({Key? key}) : super(key: key);

  @override
  State<DrawerSection> createState() => _DrawerSectionState();
}

class _DrawerSectionState extends State<DrawerSection> {
  final Stream<QuerySnapshot> registeredUser =
      FirebaseFirestore.instance.collection('User Data').snapshots();
  final docUser = FirebaseFirestore.instance
      .collection('User Data')
      .doc('$registeredEmail');
  final storage = FlutterSecureStorage();

  bool status = false;
  String _userMode = 'User Mode';
  //FireBase firstName and lastName
  String personName = '';
  String imageURL = '';
  String lastNamePrefix = '';
  fetch() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user!.email);
    print('-------------------------------------');
    print('Current user data is fetching');
    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.email)
          .get()
          .then((ds) {
        personName = ds['personName'];
        imageURL = ds['imageUrl'];

//        for (int i = 0; i < personName.length; i++) {
//          if (personName[i].contains(" ")) {
//            print('--------------------------');
//            print('Name Contains empty spaces');
//            setState(() {
//              lastNamePrefix = personName[i + 1];
//            });
//          }
//        }
      });
      setState(() {
//        print(personName);
//        if (lastNamePrefix.isEmpty) {
//          print('Last Name is empty');
//          lastNamePrefix = '.';
//        }
//        print('lastNamePrefix : $lastNamePrefix');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  readUserMode() async {
    var _value = await readMode();
    print('DDDDDDDDDDDDDDDDDDDDDDDDDD');
    print(_value);
    print('DDDDDDDDDDDDDDDDDDDDDDDDDD');
    setState(() {
      status = _value;
      if (status == true) {
        _userMode = 'Freelancer Mode';
        print('Freelancer Mode is set');
      } else {
        _userMode = 'User Mode';
        print('User Mode is set');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
    readUserMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _CustomUserAccountsDrawerHeader(),
          FlatButton(
            color: defaultUIColor.withOpacity(0.2),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: defaultUIColor,
              ),
              title: const Text('Home'),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false);
            },
          ),
          const Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.5,
          ),
          FlatButton(
            child: const ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('Profile'),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileSection(
                      personName: personName, imageURL: imageURL),
                ),
              );
            },
          ),
          const Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.5,
          ),
          FlatButton(
            child: const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          const Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.5,
          ),
          FlatButton(
            child: const ListTile(
              leading: Icon(Icons.analytics_outlined),
              title: Text(
                // _userMode == 'User Mode' ? 'Buyer Orders' : 'Seller Orders'
                'Orders Analytics',
              ),
            ),
            onPressed: () {
              _userMode == 'User Mode'
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyerOrderAnalytics(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellerOrderAnalytics(),
                      ),
                    );
            },
          ),
          const Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.5,
          ),
          FlatButton(
            child: const ListTile(
              leading: Icon(Icons.report),
              title: Text('Report a Problem'),
            ),
            onPressed: () {
//              homeCategory = 'No';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(),
                ),
              );
            },
          ),
          const Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.5,
          ),
          FlatButton(
            child: const ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('About Us'),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicy(),
                ),
              );
            },
          ),
          const Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.5,
          ),
          FlatButton(
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
            onPressed: () async => {
              await FirebaseFirestore.instance
                  .collection('User Data')
                  .doc('$currentUserEmail')
                  .update({
                'User Current Status': 'Offline',
              }),
              await FirebaseAuth.instance.signOut(),
              isUserLogout = true,
              await storage.delete(key: 'uid'),
              // ignore: avoid_print
              print('signOut called'),
              await Fluttertoast.showToast(
                msg: 'User Logout Successfully', // message
                toastLength: Toast.LENGTH_SHORT, // length
                gravity: ToastGravity.BOTTOM, // location
                backgroundColor: Colors.green,
              ),
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                  (route) => false),
            },
          ),
          // Card(
          //   child: ListTile(
          //     leading: IconButton(
          //       icon: const Icon(Icons.account_balance_wallet_sharp),
          //       onPressed: () {},
          //     ),
          //     title: Text(_userMode),
          //     trailing: Switch(
          //         value: status,
          //         activeColor: lightPurple,
          //         onChanged: (value) {
          //           setState(() {
          //             status = value;
          //             saveMode(status);
          //             Vibrate.vibrate();
          //           });
          //           if (status == true) {
          //             _userMode = 'Freelancer Mode';
          //             Fluttertoast.showToast(
          //               msg: 'Freelancer Mode ON', // message
          //               toastLength: Toast.LENGTH_SHORT, // length
          //               gravity: ToastGravity.BOTTOM, // location
          //               backgroundColor: Colors.black,
          //             );
          //           } else {
          //             _userMode = 'User Mode';
          //             Fluttertoast.showToast(
          //               msg: 'User Mode ON', // message
          //               toastLength: Toast.LENGTH_SHORT, // length
          //               gravity: ToastGravity.BOTTOM, // location
          //               backgroundColor: lightPurple,
          //             );
          //           }
          //           Navigator.pushAndRemoveUntil(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => HomeScreen(),
          //               ),
          //               (route) => false);
          //         },
          //     ),
          //   ),
          // ),
          Column(
            children: [
              const Text('Selected Mode'),
              const SizedBox(
                height: 5.0,
              ),
              FlutterSwitch(
                width: 130.0,
                height: 35.0,
                valueFontSize: 10.0,
                toggleSize: 30.0,
                activeColor: blackColor,
                inactiveColor: darkPurple,
                activeText: 'User Mode', //_userMode
                inactiveText: 'Freelancer Mode', //_userMode
                value: status,
                borderRadius: 30.0,
                padding: 3.0,
                showOnOff: true,
                onToggle: (value) {
                  setState(() {
                    status = value;
                    saveMode(status);
                    Vibrate.vibrate();
                  });
                  if (status == true) {
                    _userMode = 'Freelancer Mode';
                    Fluttertoast.showToast(
                      msg: 'User Mode ON', // Freelancer Mode ON
                      toastLength: Toast.LENGTH_SHORT, // length
                      gravity: ToastGravity.BOTTOM, // location
                      backgroundColor: Colors.black,
                    );
                  } else {
                    _userMode = 'User Mode';
                    Fluttertoast.showToast(
                      msg: 'Freelancer Mode ON', // User Mode ON
                      toastLength: Toast.LENGTH_SHORT, // length
                      gravity: ToastGravity.BOTTOM, // location
                      backgroundColor: lightPurple,
                    );
                  }
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

//   ignore: non_constant_identifier_names
  _CustomUserAccountsDrawerHeader() {
    try {
      return UserAccountsDrawerHeader(
        currentAccountPictureSize: const Size.square(70.0),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('abstracts/abstract-background-1.jpg'),
          ),
        ),
        currentAccountPicture: imageURL == ""
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileSection(
                          personName: personName, imageURL: imageURL),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: defaultUIColor.withOpacity(0.4),
                          minRadius: 15.0,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'icons/default_profile.png',
                          height: 40,
                          width: 40,
                          color: darkPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileSection(
                          personName: personName, imageURL: imageURL),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageURL),
                ),
              ),
        accountName: Text(
          personName,
          style: const TextStyle(color: Colors.black),
        ),
        accountEmail: Text(
          '$registeredEmail',
          style: const TextStyle(color: Colors.black),
        ),
      );
    } catch (e) {
      return UserAccountsDrawerHeader(
        currentAccountPictureSize: const Size.square(70.0),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('abstracts/abstract-background-1.jpg'),
          ),
        ),
        currentAccountPicture: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: defaultUIColor.withOpacity(0.4),
                  minRadius: 15.0,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Center(
                  child: imageURL.isEmpty
                      ? Image.asset(
                          'icons/default_profile.png',
                          height: 40,
                          width: 40,
                          color: darkPurple,
                        )
                      : CircularProgressIndicator(
                          color: defaultUIColor,
                          strokeWidth: 2.0,
                        ),
                ),
              ),
            ),
          ],
        ),
        accountName: Text(
          personName,
          style: const TextStyle(color: Colors.black),
        ),
        accountEmail: Text(
          '$registeredEmail',
          style: const TextStyle(color: Colors.black),
        ),
      );
    }
  }
}
