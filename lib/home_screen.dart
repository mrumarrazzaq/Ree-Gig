// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_slider.dart';
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
                                            horizontal: 0.0),
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: RecommendedForYou(),
                      ),

                      //Daily Updates
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
                        physics: const BouncingScrollPhysics(),
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
        width: MediaQuery.of(context).size.width * 0.25, //120.0
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: lightPurple,
              backgroundImage: NetworkImage(imageUrl),
              maxRadius: 25.0,
            ),
            const SizedBox(height: 2.0),
            Container(
              height: 100,
              child: Text(title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(color: whiteColor, fontSize: 13.0)),
            ),
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
