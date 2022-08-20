// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/widgets/custom_request_poster.dart';

class RecommendedForYou extends StatefulWidget {
  @override
  _RecommendedForYouState createState() => _RecommendedForYouState();
}

class _RecommendedForYouState extends State<RecommendedForYou> {
  final Stream<QuerySnapshot> _dailyUpdated = FirebaseFirestore.instance
      .collection('Requests')
      .orderBy('Created AT', descending: true)
      .snapshots();

  String _userRecommended = '';
  readRecommendation() async {
    _userRecommended = await readUserRecommendations();
    setState(() {
      _userRecommended = _userRecommended;
    });
  }

  @override
  void initState() {
    readRecommendation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _dailyUpdated,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          if (snapshot.hasData) {
            final List storeRequests = [];

            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map id = document.data() as Map<String, dynamic>;
              storeRequests.add(id);
              id['id'] = document.id;
            }).toList();
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                storeRequests.isEmpty
                    ? const Text('No Recommendation Item Find')
                    : Container(),
                for (int i = 0; i < storeRequests.length; i++) ...[
                  storeRequests[i]['Selected Category'] == _userRecommended
                      ? CustomPoster(
                          name: storeRequests[i]['User Name'],
                          email: storeRequests[i]['User Email'],
                          url: storeRequests[i]['Profile Image URL'],
                          category: storeRequests[i]['Selected Category'],
                          requestTitle: storeRequests[i]['Request Title'],
                          description: storeRequests[i]['Request Description'],
                          imagePath: storeRequests[i]['Request Image URL'],
                          location: storeRequests[i]['Current Address'],
                          imageType: 'Network',
                          timeStamp: storeRequests[i]['Created AT'],
                        )
                      : Container(),
                ],
              ],
            );
          }
          return Center(
              child: CircularProgressIndicator(
            color: lightPurple,
            strokeWidth: 2.0,
          ));
        });
  }
}
