import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/freelancer_reviews.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';

class FollowProfileScreen extends StatefulWidget {
  @override
  _FollowProfileScreenState createState() => _FollowProfileScreenState();
}

class _FollowProfileScreenState extends State<FollowProfileScreen> {
  bool _isFollowButtonPressed = false;
  String _imageURL = '';
  String _email = '';
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
        _email = ds['email'];
        _imageURL = ds['imageUrl'];
      });
      setState(() {
//        print('_imageURL : $_imageURL');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  int intFollowers = 0;
  String stringFollowers = '10';
  int intFollowings = 0;
  String stringFollowings = '37';
  void generateRandom() {
    setState(() {
      intFollowers = Random().nextInt(200) + 1;
      intFollowings = Random().nextInt(600) + 1;
      stringFollowers = intFollowers.toString();
      stringFollowings = intFollowings.toString();
    });
  }

  @override
  void initState() {
    fetch();
    generateRandom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('=====================');
    print(_email);
    print(_imageURL);
    print('=====================');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              text: '', // default text style
              children: <TextSpan>[
                TextSpan(
                    text: 'REE ',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text: 'GIG', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size(180.0, 180.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: _imageURL == ''
                          ? CircleAvatar(
                              foregroundImage: const AssetImage(
                                'icons/default_profile.png',
                              ),
                              backgroundColor: lightPurple,
                              radius: 30,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(_imageURL),
                              backgroundColor: lightPurple.withOpacity(0.5),
                              radius: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: '',
                              style: TextStyle(
                                color: whiteColor,
                              ), // default text style
                              children: <TextSpan>[
                                TextSpan(
                                    text: '$currentUserEmail \n',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: '$stringFollowers Follwers\n',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic)),
                                TextSpan(
                                    text: '$stringFollowings Following',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
//                          Padding(
//                            padding: const EdgeInsets.only(top: 10.0),
//                            child: Material(
//                              color: _isFollowButtonPressed
//                                  ? Colors.black
//                                  : lightPurple,
//                              clipBehavior: Clip.antiAlias,
//                              elevation: 2.0,
//                              borderRadius: BorderRadius.circular(30.0),
//                              child: MaterialButton(
//                                minWidth: 150.0,
//                                height: 30.0,
//                                elevation: 2.0,
//                                padding:
//                                    const EdgeInsets.symmetric(vertical: 10.0),
//                                onPressed: () {
//                                  setState(() {
//                                    _isFollowButtonPressed =
//                                        !_isFollowButtonPressed;
//                                  });
//                                },
//                                child: Text(
//                                  _isFollowButtonPressed
//                                      ? 'UnFollow'
//                                      : 'Follow',
//                                  style: TextStyle(
//                                    color: whiteColor,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TabBar(
                  indicatorColor: whiteColor,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 5.0, color: whiteColor),
                      insets: const EdgeInsets.symmetric(horizontal: 20.0)),

//            const BoxDecoration(
//              borderRadius: BorderRadius.only(
//                bottomLeft: Radius.circular(20.0),
//                bottomRight: Radius.circular(20.0),
//              ),
//            ),
                  tabs: const [
                    Tab(text: 'Request'),
                    Tab(text: 'Aids'),
                    Tab(text: 'Reviews'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            //Requests
            FreelancerProfileRequestsAndAids(),
            //Aids
            FreelancerProfileRequestsAndAids(),
            //Reviews
            FreelancersReviews(email: _email),
          ],
        ),
//        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}

class FreelancerProfileRequestsAndAids extends StatelessWidget {
  final Stream<QuerySnapshot> _dailyUpdated = FirebaseFirestore.instance
      .collection('$currentUserEmail Requests')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
                color: darkPurple,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _dailyUpdated,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: lightPurple,
                    strokeWidth: 2.0,
                  ));
                }
                final List storeRequests = [];

                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  storeRequests.add(id);
//                  print('==============================================');
//                  print(storeRequests);
//                  print('Document id : ${document.id}');
                  id['id'] = document.id;
                }).toList();
                return Column(
//                            shrinkWrap: true,
                  children: [
                    storeRequests.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text(
                              'No Item Find',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    for (int i = 0; i < storeRequests.length; i++) ...[
                      CustomContainer1(
                          userName: storeRequests[i]['User Name'],
                          userEmail: storeRequests[i]['User Email'],
                          userProfileUrl: storeRequests[i]['Profile Image URL'],
                          requestCategory: storeRequests[i]
                              ['Selected Category'],
                          title: storeRequests[i]['User Name'],
                          description: storeRequests[i]['Request Description'],
                          imagePath: storeRequests[i]['Request Image URL'],
                          imageType: 'Network',
                          location: storeRequests[i]['Current Address'],
                          innerBorder: 20.0,
                          smallBoxWidth: 110,
                          smallBoxHeight: 80),
                    ],
                  ],
                );
              }),
//                    ListView(
//                      shrinkWrap: true,
//                      children: [
//                        CustumContainer(
//                            title: 'Admin',
//                            description:
//                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//                            innerBorder: 10.0,
//                            location: 'London',
//                            imagePath: 'images/samplePerson3.jpg',
//                            imageType: '',
//                            smallBoxWidth: 100,
//                            smallBoxHeight: 70),
//                      ],
//                    ),
        ],
      ),
    );
  }
}
