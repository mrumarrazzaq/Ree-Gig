//Scaffold(
//body: ListView(
//shrinkWrap: true,
//children: [
//Container(
//height: 8,
//decoration: BoxDecoration(
//color: darkPurple,
//borderRadius: const BorderRadius.only(
//bottomLeft: Radius.circular(20.0),
//bottomRight: Radius.circular(20.0))),
//),
//StreamBuilder<QuerySnapshot>(
//stream: _dailyUpdated,
//builder: (BuildContext context,
//    AsyncSnapshot<QuerySnapshot> snapshot) {
//if (snapshot.hasError) {
//print('Something went wrong');
//}
//if (snapshot.connectionState == ConnectionState.waiting) {
//return Center(
//child: CircularProgressIndicator(
//color: lightPurple,
//strokeWidth: 2.0,
//));
//}
//final List storeRequests = [];
//
//snapshot.data!.docs.map((DocumentSnapshot document) {
//Map id = document.data() as Map<String, dynamic>;
//storeRequests.add(id);
////                      print('==============================================');
////                      print(storeRequests);
//print('Document id : ${document.id}');
//id['id'] = document.id;
//}).toList();
//return ListView(
//shrinkWrap: true,
//children: [
//storeRequests.isEmpty
//? const Text('No Item Find')
//    : Container(),
//for (int i = 0; i < storeRequests.length; i++) ...[
//storeRequests[i]['Selected Category'] ==
//requestCategory &&
//storeRequests[i]['User Email'] == userEmail
//? CustomContainer2(
//userName: storeRequests[i]['User Name'],
//userEmail: storeRequests[i]['User Email'],
//userProfileUrl: storeRequests[i]
//['Profile Image URL'],
//requestCategory: storeRequests[i]
//['Selected Category'],
//title: storeRequests[i]['User Name'],
//description: storeRequests[i]
//['Request Description'],
//imagePath: storeRequests[i]['Request Image URL'],
//imageType: 'Network',
//location: storeRequests[i]['Current Address'],
//innerBorder: 20.0,
//smallBoxWidth: 110,
//smallBoxHeight: 80)
//    : Container(),
//],
//],
//);
//}),
//
//
//
//
////                    ListView(
////                      shrinkWrap: true,
////                      children: [
////                        CustumContainer(
////                            title: 'Admin',
////                            description:
////                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
////                            innerBorder: 10.0,
////                            location: 'London',
////                            imagePath: 'images/samplePerson3.jpg',
////                            imageType: '',
////                            smallBoxWidth: 100,
////                            smallBoxHeight: 70),
////                      ],
////                    ),
//],
//),
//)
