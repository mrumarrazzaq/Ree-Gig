import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';
import 'package:ree_gig/search_screen.dart';

class HomeScreenOptions extends StatefulWidget {
  HomeScreenOptions({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  _HomeScreenOptionsState createState() => _HomeScreenOptionsState();
}

class _HomeScreenOptionsState extends State<HomeScreenOptions> {
  final Stream<QuerySnapshot> _dailyUpdated = FirebaseFirestore.instance
      .collection('Requests')
      .orderBy('Created AT', descending: true)
      .snapshots();

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
    readUserMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("================");
    print(widget.title);
    return Scaffold(
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
                                Text(widget.title,
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
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(widget.title)
                                .orderBy('priority', descending: false)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                print('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: lightPurple,
                                  strokeWidth: 2.0,
                                ));
                              }
                              final List storeSubCategories = [];

                              snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map id =
                                    document.data() as Map<String, dynamic>;
                                storeSubCategories.add(id);
                                id['id'] = document.id;
                              }).toList();
                              return Row(
                                children: [
                                  storeSubCategories.isEmpty
                                      ? const Text('No SubCategory Find')
                                      : Container(),
                                  for (int i = 0;
                                      i < storeSubCategories.length;
                                      i++) ...[
                                    HomeCircularOptions(
                                        categoryTitle: widget.title,
                                        subCategoryTitle: storeSubCategories[i]
                                            ['SubCategory Name'],
                                        imageUrl: storeSubCategories[i]
                                            ['SubCategory Image URL']),
//                      CustomPoster(
//                      name: storeRequests[i]['User Name'],
//                      email: storeRequests[i]['User Email'],
//                      url: storeRequests[i]['Profile Image URL'],
//                      category: storeRequests[i]['Selected Category'],
//                      requestTitle: storeRequests[i]['Request Title'],
//                      description: storeRequests[i]['Request Description'],
//                      imagePath: storeRequests[i]['Request Image URL'],
//                      location: storeRequests[i]['Current Address'],
//                      imageType: 'Network',
//                      ),
                                  ],
                                ],
                              );
                            }),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     HomeCircularOptions(title: '1000'),
                        //     HomeCircularOptions(title: '1001'),
                        //     HomeCircularOptions(title: '1002'),
                        //     HomeCircularOptions(title: '1003'),
                        //     HomeCircularOptions(title: '1004'),
                        //     HomeCircularOptions(title: '1005'),
                        //     HomeCircularOptions(title: '1006'),
                        //     HomeCircularOptions(title: '1007'),
                        //     HomeCircularOptions(title: '1008'),
                        //   ],
                        // ),
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
              padding: const EdgeInsets.only(top: 150.0),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                ),
                child: StreamBuilder<QuerySnapshot>(
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
//                        print('==============================================');
//                        print(storeRequests);
//                        print('Document id : ${document.id}');
                        id['id'] = document.id;
                      }).toList();
                      return ListView(
                        children: [
                          storeRequests.isEmpty
                              ? const Text('No daily Update')
                              : Container(),
                          for (int i = 0; i < storeRequests.length; i++) ...[
                            storeRequests[i]['Selected Category'] ==
                                    widget.title
                                ? CustomContainer1(
                                    userName: storeRequests[i]['User Name'],
                                    userEmail: storeRequests[i]['User Email'],
                                    userProfileUrl: storeRequests[i]
                                        ['Profile Image URL'],
                                    requestCategory: storeRequests[i]
                                        ['Selected Category'],
                                    title: storeRequests[i]['Request Title'],
                                    description: storeRequests[i]
                                        ['Request Description'],
                                    imagePath: storeRequests[i]
                                        ['Request Image URL'],
                                    imageType: 'Network',
                                    location: storeRequests[i]
                                        ['Current Address'],
                                    innerBorder: 20.0,
                                    smallBoxWidth: 110,
                                    smallBoxHeight: 80)
                                : Container(),
                          ],
                        ],
                      );
                    }),
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
  HomeCircularOptions(
      {Key? key,
      required this.categoryTitle,
      required this.subCategoryTitle,
      required this.imageUrl})
      : super(key: key);
  String categoryTitle;
  String subCategoryTitle;
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(imageUrl),
            ),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
          ),
          const SizedBox(height: 5.0),
          Text(subCategoryTitle, style: TextStyle(color: whiteColor)),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RequestFillerBySubCategory(subCategoryTitle: subCategoryTitle),
          ),
        );
      },
    );
  }
}

class RequestFillerBySubCategory extends StatefulWidget {
  RequestFillerBySubCategory({Key? key, required this.subCategoryTitle})
      : super(key: key);
  String subCategoryTitle;
  @override
  State<RequestFillerBySubCategory> createState() =>
      _RequestFillerBySubCategoryState();
}

class _RequestFillerBySubCategoryState
    extends State<RequestFillerBySubCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategoryTitle),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Requests')
              .orderBy('Created AT', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              id['id'] = document.id;
            }).toList();
            return ListView(
              children: [
                storeRequests.isEmpty
                    ? const Text('No Request Find')
                    : Container(),
                for (int i = 0; i < storeRequests.length; i++) ...[
                  storeRequests[i]['Selected SubCategory'] ==
                          widget.subCategoryTitle
                      ? CustomContainer1(
                          userName: storeRequests[i]['User Name'],
                          userEmail: storeRequests[i]['User Email'],
                          userProfileUrl: storeRequests[i]['Profile Image URL'],
                          requestCategory: storeRequests[i]
                              ['Selected Category'],
                          title: storeRequests[i]['Request Title'],
                          description: storeRequests[i]['Request Description'],
                          imagePath: storeRequests[i]['Request Image URL'],
                          imageType: 'Network',
                          location: storeRequests[i]['Current Address'],
                          innerBorder: 20.0,
                          smallBoxWidth: 110,
                          smallBoxHeight: 80)
                      : Container(),
                ],
              ],
            );
          }),
    );
  }
}
