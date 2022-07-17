import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';

class SellerOrderAnalytics extends StatefulWidget {
  const SellerOrderAnalytics({Key? key}) : super(key: key);

  @override
  State<SellerOrderAnalytics> createState() => _SellerOrderAnalyticsState();
}

class _SellerOrderAnalyticsState extends State<SellerOrderAnalytics> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              text: '', // default text style
              children: <TextSpan>[
                TextSpan(
                    text: 'Seller ',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text: 'Orders',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size(50.0, 50.0),
            child: TabBar(
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
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            //Pending Orders
            pendingOrders(),
            //Completed Orders
            completedOrders(),
          ],
        ),
      ),
    );
  }
}

class pendingOrders extends StatelessWidget {
  final Stream<QuerySnapshot> firebaseData = FirebaseFirestore.instance
      .collection('Seller $currentUserEmail')
      .orderBy('Created AT', descending: true)
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
              stream: firebaseData,
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
                  children: [
                    storeRequests.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text(
                              'No Pending Order',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    for (int i = 0; i < storeRequests.length; i++) ...[
                      storeRequests[i]['Is Job Complete'] == false
                          ? CustomContainer1(
                              userName: storeRequests[i]['Seller Name'],
                              userEmail: storeRequests[i]
                                  ['Request Seller Email'],
                              userProfileUrl: storeRequests[i]
                                  ['Profile Image URL'],
                              requestCategory: storeRequests[i]
                                  ['Request Category'],
                              title: storeRequests[i]['Request Title'],
                              description: storeRequests[i]
                                  ['Request Description'],
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
        ],
      ),
    );
  }
}

class completedOrders extends StatelessWidget {
  final Stream<QuerySnapshot> firebaseData = FirebaseFirestore.instance
      .collection('Seller $currentUserEmail')
      .orderBy('Created AT', descending: true)
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
              stream: firebaseData,
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
                  children: [
                    storeRequests.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text(
                              'No Completed Order',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    for (int i = 0; i < storeRequests.length; i++) ...[
                      storeRequests[i]['Is Job Complete'] == true
                          ? CustomContainer1(
                              userName: storeRequests[i]['Seller Name'],
                              userEmail: storeRequests[i]
                                  ['Request Seller Email'],
                              userProfileUrl: storeRequests[i]
                                  ['Profile Image URL'],
                              requestCategory: storeRequests[i]
                                  ['Request Category'],
                              title: storeRequests[i]['Request Title'],
                              description: storeRequests[i]
                                  ['Request Description'],
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
        ],
      ),
    );
  }
}
