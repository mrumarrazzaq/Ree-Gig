import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/widgets/custom_request_poster.dart';

class DailyUpdates extends StatefulWidget {
  @override
  _DailyUpdatesState createState() => _DailyUpdatesState();
}

class _DailyUpdatesState extends State<DailyUpdates> {
  final Stream<QuerySnapshot> _dailyUpdated = FirebaseFirestore.instance
      .collection('Requests')
      .orderBy('Created AT', descending: true)
      .snapshots();

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
            return
                //   CarouselSlider.builder(
                //   itemCount: storeRequests.length,
                //   itemBuilder:
                //       (BuildContext context, int itemIndex, int pageViewIndex) {
                //     return CustomPoster(
                //       name: storeRequests[itemIndex]['User Name'],
                //       email: storeRequests[itemIndex]['User Email'],
                //       url: storeRequests[itemIndex]['Profile Image URL'],
                //       category: storeRequests[itemIndex]['Selected Category'],
                //       requestTitle: storeRequests[itemIndex]['Request Title'],
                //       description: storeRequests[itemIndex]['Request Description'],
                //       imagePath: storeRequests[itemIndex]['Request Image URL'],
                //       location: storeRequests[itemIndex]['Current Address'],
                //       imageType: 'Network',
                //       timeStamp: storeRequests[itemIndex]['Created AT'],
                //     );
                //   },
                //   options: CarouselOptions(
                //     enlargeCenterPage: true,
                //     // height: 400,
                //     // aspectRatio: 2,
                //     // viewportFraction: 0.8,
                //     initialPage: 0,
                //     // enableInfiniteScroll: true,
                //     // reverse: false,
                //     // autoPlay: true,
                //     // autoPlayInterval: const Duration(seconds: 3),
                //     // autoPlayAnimationDuration:
                //     //     const Duration(milliseconds: 800),
                //     // autoPlayCurve: Curves.fastOutSlowIn,
                //     // enlargeCenterPage: true,
                //     // scrollDirection: Axis.horizontal,
                //   ),
                // );

                Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                storeRequests.isEmpty
                    ? const Text('No daily Update')
                    : Container(),
                for (int i = 0; i < storeRequests.length; i++) ...[
                  CustomPoster(
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
        });
  }
}
