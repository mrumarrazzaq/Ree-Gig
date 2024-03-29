import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
                            .orderBy('Created At', descending: true)
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
                            id['id'] = document.id;
                          }).toList();
                          return Column(
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
