import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/project_constants.dart';

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
          final List storeRequests = [];

          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map id = document.data() as Map<String, dynamic>;
            storeRequests.add(id);
//            print('==============================================');
//            print(storeRequests);
//            print('Document id : ${document.id}');
            id['id'] = document.id;
          }).toList();

          return Row(
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
                  dateTime: storeRequests[i]['Created AT'],
                ),
              ],
            ],
          );
        });
  }
}

class CustomPoster extends StatelessWidget {
  CustomPoster({
    Key? key,
    required this.name,
    required this.email,
    required this.url,
    required this.category,
    required this.requestTitle,
    required this.imagePath,
    required this.imageType,
    required this.description,
    required this.location,
    required this.dateTime,
  }) : super(key: key);
  String name;
  String email;
  String url;
  String imagePath;
  String category;
  String requestTitle;
  String description;
  String imageType;
  String location;
  Timestamp dateTime;
  @override
  Widget build(BuildContext context) {
    DateTime dt = dateTime.toDate();
    return GestureDetector(
      onTap: () {
        print('url-----------------');
        print(url);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FreelancerProfileScreen(
                userName: name,
                userEmail: email,
                userProfileUrl: url,
                requestCategory: category,
              ),
//                  RequestDetail(
//                userName: name,
//                userEmail: email,
//                userProfileUrl: url,
//                requestTitle: requestTitle,
//                requestDescription: description,
//                requestCategory: category,
//                requestImagePath: imagePath,
//                requestLocation: location,
//                imageType: imageType,
//              ),
            ));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 155,
            width: 150,
            margin: const EdgeInsets.only(
                left: 30.0, right: 20.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: imageType == 'Network'
                    ? FittedBox(
                        fit: BoxFit.fill, child: Image.network(imagePath))
                    : FittedBox(
                        fit: BoxFit.fill, child: Image.asset(imagePath))),
          ),
          Positioned.fill(
//          right: 30,
            top: 10,
            bottom: 10,
            left: 10,
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 140,
                  height: 145,
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
//                          backgroundColor: lightPurple,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          '${dt.hour.toString()} hr ago',
                          style: TextStyle(
                            color: whiteColor,
                            backgroundColor: lightPurple,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Text(requestTitle,
                            style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
//                              backgroundColor: lightPurple,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center),
                      ),
                      Text(description,
                          style: TextStyle(color: whiteColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                )),
          ),
//          Positioned.fill(
//            top: 15,
//            left: 40,
//            child: Align(
//                alignment: Alignment.topLeft,
//                child: Container(
////                width: 20,
////                height: 10,
//                  child: Text(
//                    category,
//                    style: TextStyle(color: whiteColor),
//                  ),
//                  color: lightPurple,
//                )),
//          ),
//          Positioned.fill(
//            top: 40,
//            left: 60,
//            child: Align(
//                alignment: Alignment.topCenter,
//                child: Container(
////                width: 20,
////                  height: 10,
//                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                  decoration: BoxDecoration(
//                    color: whiteColor,
//                    borderRadius: BorderRadius.circular(5.0),
//                  ),
//                  child: Text(
//                    '${dt.hour.toString()} hr ago',
//                    style: TextStyle(color: blackColor),
//                  ),
//                )),
//          ),
//          Positioned.fill(
////          right: 30,
//            bottom: 20,
//            child: Align(
//                alignment: Alignment.bottomCenter,
//                child: Container(
//                  width: 120,
//                  height: 80,
//                  padding: const EdgeInsets.all(5.0),
//                  child: Text(requestTitle,
//                      style: TextStyle(color: whiteColor),
//                      textAlign: TextAlign.center),
//                  decoration: BoxDecoration(
//                    color: Colors.black54,
//                    borderRadius: BorderRadius.circular(5.0),
//                  ),
//                )),
//          ),
        ],
      ),
    );
  }
}
