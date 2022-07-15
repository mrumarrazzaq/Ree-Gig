import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';

class RecentChats extends StatefulWidget {
  RecentChats({
    Key? key,
  }) : super(key: key);

  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
//  String receiverEmail = '';
//  String receiverName = '';
//  String receiverProfileImageUrl = '';
//  Timestamp timestamp = Timestamp.now();
//  fetch() async {
//    final user = FirebaseAuth.instance.currentUser;
//    print(user!.email);
//    print('-------------------------------------');
//    print('Current user data is fetching');
//    try {
//      await FirebaseFirestore.instance
//          .collection('Recent Chats ${currentUserEmail.toString()}')
//          .doc(user.email)
//          .get()
//          .then((ds) {
//        receiverEmail = ds['Receiver Email'];
//        receiverName = ds['Receiver Name'];
//        receiverProfileImageUrl = ds['Receiver profileImageUrl'];
//        timestamp = ds['Created At'];
//      });
//      setState(() {});
//    } catch (e) {
//      print(e.toString());
//    }
//  }

  @override
  Widget build(BuildContext context) {
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
                  width: double.infinity,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Message',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: whiteColor, fontSize: 20),
                    ),
                  )),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('User Data')
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
                          final List recentMassages = [];

                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map id = document.data() as Map<String, dynamic>;
                            recentMassages.add(id);
//                  print('==============================================');
//                  print(storeRequests);
//                  print('Document id : ${document.id}');
                            id['id'] = document.id;
//                            storedMassages.sort((a, b) => b.value["Created At"]
//                                .compareTo(a.value["Created At"]));
                          }).toList();
                          return Column(
//                            shrinkWrap: true,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              recentMassages.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 30.0),
                                      child: Center(
                                        child: Text(
                                          'No Recent Chats',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              for (int i = 0;
                                  i < recentMassages.length;
                                  i++) ...[
                                recentMassages[i]['email'] == currentUserEmail
                                    ? Container()
                                    : CustomRecentChatsTile(
                                        name: recentMassages[i]['personName'],
                                        email: recentMassages[i]['email'],
                                        massage: recentMassages[i]['email'],
                                        imagePath: recentMassages[i]
                                            ['imageUrl'],
                                        time: '8:37 PM',
                                        currentStatus: recentMassages[i]
                                            ['User Current Status'],
                                        noOfMassages: 0,
                                      ),
                              ],
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
//      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
