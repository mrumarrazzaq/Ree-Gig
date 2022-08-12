// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/daily_updates.dart';
import 'package:ree_gig/drawer_section/drawer_section.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/home_screen_options.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';
import 'package:ree_gig/recommended_for_you.dart';
import 'package:ree_gig/request_detail.dart';
import 'package:ree_gig/search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  bool _isVisibleBottomNavigation = false;

  readUserMode() async {
    var _value = await readMode();
    print('--------------------------');
    print(_value);
    print('--------------------------');

    setState(() {
      _isVisibleBottomNavigation = _value;
      if (_value == true) {
        print('Freelancer Mode is set');
        print('Enable Bottom Navigation set to $_isVisibleBottomNavigation');
      } else {
        print('User Mode is set');
        print('Disable Bottom Navigation set to $_isVisibleBottomNavigation');
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setUserStatus(status: 'Online');
    readUserMode();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //User Status online
      setUserStatus(status: 'Online');
    } else {
      //User Status offLine
      setUserStatus(status: 'Offline');
    }
  }

  void setUserStatus({required String status}) async {
    await _fireStore.collection('User Data').doc('$currentUserEmail').update({
      'User Current Status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Home Screen build is running');
    return Scaffold(
      drawer: const Drawer(
        elevation: 10,
        child: SafeArea(
          child: DrawerSection(),
        ),
      ),
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'REE ', style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(
                  text: 'GIG', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
//        actions: const [
//          IconButton(
//            icon: Icon(
//              Icons.settings_outlined,
//              color: Colors.white,
//            ),
//            onPressed: null,
////                () => Scaffold.of(context).openDrawer()
//          ),
//        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: darkPurple,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 15.0, top: 2.0),
                      child: GestureDetector(
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: whiteColor, size: 20),
                                const SizedBox(width: 10.0),
                                Text('Search',
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 15)),
                              ],
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: lightPurple,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Categories')
                                .orderBy('priority', descending: false)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                print('Something went wrong');
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: lightPurple,
                                  strokeWidth: 2.0,
                                ));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: lightPurple,
                                  strokeWidth: 2.0,
                                ));
                              }
                              if (snapshot.hasData) {
                                final List storeCategories = [];

                                snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map id =
                                      document.data() as Map<String, dynamic>;
                                  storeCategories.add(id);
                                  id['id'] = document.id;
                                }).toList();
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    storeCategories.isEmpty
                                        ? const Text('No Category Find')
                                        : Container(),
                                    for (int i = 0;
                                        i < storeCategories.length;
                                        i++) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: HomeCircularOptions(
                                          title: storeCategories[i]
                                              ['Category Name'],
                                          imageUrl: storeCategories[i]
                                              ['Category Image URL'],
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              }
                              return Center(
                                  child: CircularProgressIndicator(
                                color: lightPurple,
                                strokeWidth: 2.0,
                              ));
                            }),
                      ),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 12.0),
                      //         child: Column(
                      //           children: [
                      //             HomeCircularOptions(
                      //                 title: 'Admin',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1554224154-26032ffc0d07?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fGFkbWlufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
                      //             const SizedBox(height: 15),
                      //             HomeCircularOptions(
                      //                 title: 'Business',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1537511446984-935f663eb1f4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGJ1c2luZXNzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
                      //           ],
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 12.0),
                      //         child: Column(
                      //           children: [
                      //             HomeCircularOptions(
                      //                 title: 'Arts & Crafts',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1590853566724-83bc9da30d15?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXJ0JTIwYW5kJTIwY3JhZnR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                      //             const SizedBox(height: 15),
                      //             HomeCircularOptions(
                      //                 title: 'Events',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1561489396-888724a1543d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fGV2ZW50fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
                      //           ],
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 12.0),
                      //         child: Column(
                      //           children: [
                      //             HomeCircularOptions(
                      //                 title: 'Cleaning Service',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1528740561666-dc2479dc08ab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8Y2xlYW5pbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                      //             const SizedBox(height: 15),
                      //             HomeCircularOptions(
                      //                 title: 'Education',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGVkdWNhdGlvbmFsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
                      //           ],
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 12.0),
                      //         child: Column(
                      //           children: [
                      //             HomeCircularOptions(
                      //                 title: 'Construction',
                      //                 imageUrl:
                      //                     'https://media.istockphoto.com/photos/engineer-meeting-for-an-architectural-project-working-with-partner-picture-id1330168130?b=1&k=20&m=1330168130&s=170667a&w=0&h=vM84Dd1d3N4hhUDvf2mcOGQGaK_vBhljyQrsp17jOoE='),
                      //             const SizedBox(height: 15),
                      //             HomeCircularOptions(
                      //                 title: 'Fashin',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1601762603339-fd61e28b698a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjl8fGZhc2hpb258ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                      //           ],
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 12.0),
                      //         child: Column(
                      //           children: [
                      //             HomeCircularOptions(
                      //                 title: 'House Related',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8aG91c2V8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                      //             const SizedBox(height: 15),
                      //             HomeCircularOptions(
                      //                 title: 'IT',
                      //                 imageUrl:
                      //                     'https://media.istockphoto.com/photos/investment-technology-with-a-global-internet-connection-financial-picture-id1392046953?b=1&k=20&m=1392046953&s=170667a&w=0&h=cngtm8gJ_NBp6CgaUbUqUYlWmydEQnlfV2hKOerucKs='),
                      //           ],
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 12.0),
                      //         child: Column(
                      //           children: [
                      //             HomeCircularOptions(
                      //                 title: 'Recruitment',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1543269664-56d93c1b41a6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8cmVjcnVpdG1lbnR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                      //             const SizedBox(height: 15),
                      //             HomeCircularOptions(
                      //                 title: 'Logistics',
                      //                 imageUrl:
                      //                     'https://images.unsplash.com/photo-1559297434-fae8a1916a79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fGxvZ2lzdGljc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'),
                      //           ],
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 12.0),
                      //         child: Column(
                      //           children: [
                      //             HomeCircularOptions(
                      //               title: 'Food & Beverages',
                      //               imageUrl:
                      //                   'https://images.unsplash.com/photo-1565958011703-44f9829ba187?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8Zm9vZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                      //             ),
                      //             const SizedBox(height: 15),
                      //             HomeCircularOptions(
                      //               title: 'Others',
                      //               imageUrl:
                      //                   'https://images.unsplash.com/photo-1633613286848-e6f43bbafb8d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      //Recommended For You
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 20.0, bottom: 10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                color: darkPurple,
                                height: 20,
                                width: 3.0,
                              ),
                            ),
                            const Text.rich(
                              TextSpan(
                                text: 'Recommended',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20), // default text style
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' For You',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Daily Updates

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: RecommendedForYou(),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 20.0, bottom: 10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                color: darkPurple,
                                height: 20,
                                width: 3.0,
                              ),
                            ),
                            const Text.rich(
                              TextSpan(
                                text: 'Daily',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20), // default text style
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Updates',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: DailyUpdates(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
          visible: _isVisibleBottomNavigation,
          child: const CustomNavigationBar()),
    );
  }
}

class HomeCircularOptions extends StatelessWidget {
  HomeCircularOptions({Key? key, required this.title, required this.imageUrl})
      : super(key: key);
  String title;
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: 120.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: lightPurple,
              backgroundImage: NetworkImage(imageUrl),
              maxRadius: 25.0,
            ),
            const SizedBox(height: 2.0),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(color: whiteColor, fontSize: 13.0)),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreenOptions(title: title),
            ));
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(imageUrl),
            ),
          ),
        );
      },
    );
  }
}
