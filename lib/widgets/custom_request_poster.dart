import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/project_constants.dart';

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
    required this.timeStamp,
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
  Timestamp timeStamp;
  @override
  Widget build(BuildContext context) {
    String howManyAgo = 'min ago';
    int what = 0;
    DateTime dt = timeStamp.toDate();
    DateTime now = DateTime.now();
    int year = dt.year;
    int month = dt.month;
    int day = dt.day;
    int hr = dt.hour;
    // if (hr > 12) {
    //   hr = hr - 12;
    // }
    int min = dt.minute;
    int sec = dt.second;
    int nowYear = now.year;
    int nowMonth = now.month;
    int nowDay = now.day;
    int nowHr = now.hour;
    int nowMin = now.minute;
    int nowSec = now.second;
    int newSec = nowSec - sec;
    int newMin = nowMin - min;
    int newHr = nowHr - hr;
    int newDay = nowDay - day;
    int newMonth = nowMonth - month;
    int newYear = nowYear - year;

    if (newMin == 0 && (newSec >= 0 || newSec < 60) && newSec > 0) {
      howManyAgo = 'sec ago';
      what = newSec;
    } else if (newHr == 0 && (newMin >= 0 || newMin < 60) && newMin > 0) {
      howManyAgo = 'min ago';
      what = newMin;
    } else if (newDay == 0 && (newHr >= 1 || newHr <= 24) && newHr > 0) {
      howManyAgo = 'hr ago';
      what = newHr;
    } else if (newMonth == 0 && (newDay >= 1 || newDay <= 31) && newDay > 0) {
      howManyAgo = 'day ago';
      what = newDay;
    } else if (newYear == 0 &&
        (newMonth >= 1 || newMonth <= 12) &&
        newMonth > 0) {
      howManyAgo = 'mo ago';
      what = newMonth;
    } else if (newYear != 0) {
      howManyAgo = 'yr ago';
      what = newYear;
    }
    double height1 = MediaQuery.of(context).size.height * 0.23;
    double width1 = MediaQuery.of(context).size.width * 0.42;
    double height2 = MediaQuery.of(context).size.height * 0.21;
    double width2 = MediaQuery.of(context).size.width * 0.40;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FreelancerProfileScreen(
                userName: name,
                userEmail: email,
                userProfileUrl: url,
                requestCategory: category,
              ),
            ));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height1, //155 //0.25
            width: width1, //150  //0.45
            margin: const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 5.0, bottom: 5.0),
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
                  height: height2,
                  width: width2,
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
                          // '${dt.hour.toString()} hr ago'
                          '$what $howManyAgo',
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
        ],
      ),
    );
  }
}
