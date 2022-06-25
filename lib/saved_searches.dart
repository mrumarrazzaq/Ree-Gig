import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/project_constants.dart';

class SavedSearches extends StatefulWidget {
  const SavedSearches({Key? key}) : super(key: key);

  @override
  State<SavedSearches> createState() => _SavedSearchesState();
}

class _SavedSearchesState extends State<SavedSearches> {
  Future<void> deleteSavedFavourite(id) {
    return FirebaseFirestore.instance
        .collection('$currentUserEmail Favourite')
        .doc(id)
        .delete()
        .then((value) => print('Event deleted '))
        .catchError((error) => print('Faild to delet Evnet $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Saved ',
                  style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(
                  text: 'Searches',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('$currentUserEmail Favourite')
                  .orderBy('userEmail', descending: false)
                  .snapshots(),
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
                final List savedFavourites = [];

                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  savedFavourites.add(id);
//            print('==============================================');
//            print(storeRequests);
//            print('Document id : ${document.id}');
                  id['id'] = document.id;
                }).toList();

                return savedFavourites.isEmpty
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text(
                          'No Saved Search',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ))
                    : Column(
                        children: [
                          for (int i = 0; i < savedFavourites.length; i++) ...[
                            GestureDetector(
                              child: ListTile(
                                leading:
                                    savedFavourites[i]['userProfileUrl'] == ''
                                        ? CircleAvatar(
                                            backgroundImage: const AssetImage(
                                                'icons/default_profile.png'),
                                            backgroundColor:
                                                lightPurple.withOpacity(0.4),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                savedFavourites[i]
                                                    ['userProfileUrl']),
                                            backgroundColor:
                                                lightPurple.withOpacity(0.4),
                                          ),
                                title: Text(savedFavourites[i]['userName']),
                                subtitle: Text(savedFavourites[i]['userEmail']),
                                trailing: IconButton(
                                  splashRadius: 20,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await deleteSavedFavourite(
                                        savedFavourites[i]['id']);
                                    await Fluttertoast.showToast(
                                      msg: 'Delete Saved Favourite', // message
                                      toastLength: Toast.LENGTH_SHORT, // length
                                      gravity: ToastGravity.BOTTOM, // location
                                      backgroundColor: Colors.green,
                                    );
                                  },
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FreelancerProfileScreen(
                                        userName: savedFavourites[i]
                                            ['userName'],
                                        userEmail: savedFavourites[i]
                                            ['userEmail'],
                                        userProfileUrl: savedFavourites[i]
                                            ['userProfileUrl'],
                                        requestCategory: savedFavourites[i]
                                            ['requestCategory'],
                                      ),
                                    ));
                              },
                            ),
                            const Divider(),
                          ],
                        ],
                      );
              }),
        ],
      ),
    );
  }
}
