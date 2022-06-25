import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/project_constants.dart';

class SearchByName extends StatefulWidget {
  const SearchByName({Key? key}) : super(key: key);

  @override
  State<SearchByName> createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  final TextEditingController _searchController = TextEditingController();
  String search = '';
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
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               SystemChannels.textInput.invokeMethod('TextInput.hide');
// //              searchItems.clear();
//               _searchController.clear();
//               Navigator.pop(context);
//             }),
//
//       ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      darkPurple,
                      const Color(0xffcd87d6),
                    ],
                    begin: Alignment.topCenter,
//                    FractionalOffset(1.0, 1.5),
                    end: Alignment.bottomCenter,
//                    FractionalOffset(0.0, 0.5),
                    stops: [0.1, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 50.0, top: 2.0),
                  child: SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      style: TextStyle(color: whiteColor),
                      decoration: InputDecoration(
                        fillColor: lightPurple,
                        filled: true,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: whiteColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: lightPurple, width: 1.5),
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: whiteColor),
                        prefixIcon: Icon(
                          Icons.search,
                          color: whiteColor,
                        ),
                        prefixText: '  ',
                      ),
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
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
                            .orderBy('email', descending: false)
                            // .where(
                            //   'personName',
                            //   isEqualTo: 'Umar Razzaq',
                            // )
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: lightPurple,
                                strokeWidth: 2.0,
                              ),
                            ));
                          }
                          final List userDataSearch = [];
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map id = document.data() as Map<String, dynamic>;
                            userDataSearch.add(id);
//            print('==============================================');
//            print(storeRequests);
//            print('Document id : ${document.id}');
                            id['id'] = document.id;
                          }).toList();

                          return Column(
                            children: [
                              for (int i = 0;
                                  i < userDataSearch.length;
                                  i++) ...[
                                search.isEmpty
                                    ? CustomSearchTile(
                                        userName: userDataSearch[i]
                                            ['personName'],
                                        userEmail: userDataSearch[i]['email'],
                                        imageUrl: userDataSearch[i]['imageUrl'],
                                        category: 'Food & Beverages',
                                      )
                                    : search ==
                                            userDataSearch[i]['personName'][0]
                                                .toLowerCase()
                                        ? CustomSearchTile(
                                            userName: userDataSearch[i]
                                                ['personName'],
                                            userEmail: userDataSearch[i]
                                                ['email'],
                                            imageUrl: userDataSearch[i]
                                                ['imageUrl'],
                                            category: 'Food & Beverages',
                                          )
                                        : search ==
                                                userDataSearch[i]['personName']
                                                        [0]
                                                    .toUpperCase()
                                            ? CustomSearchTile(
                                                userName: userDataSearch[i]
                                                    ['personName'],
                                                userEmail: userDataSearch[i]
                                                    ['email'],
                                                imageUrl: userDataSearch[i]
                                                    ['imageUrl'],
                                                category: 'Food & Beverages',
                                              )
                                            : search ==
                                                    userDataSearch[i]
                                                            ['personName']
                                                        .toUpperCase()
                                                ? CustomSearchTile(
                                                    userName: userDataSearch[i]
                                                        ['personName'],
                                                    userEmail: userDataSearch[i]
                                                        ['email'],
                                                    imageUrl: userDataSearch[i]
                                                        ['imageUrl'],
                                                    category:
                                                        'Food & Beverages',
                                                  )
                                                : search ==
                                                        userDataSearch[i]
                                                                ['personName']
                                                            .toLowerCase()
                                                    ? CustomSearchTile(
                                                        userName:
                                                            userDataSearch[i]
                                                                ['personName'],
                                                        userEmail:
                                                            userDataSearch[i]
                                                                ['email'],
                                                        imageUrl:
                                                            userDataSearch[i]
                                                                ['imageUrl'],
                                                        category:
                                                            'Food & Beverages',
                                                      )
                                                    : Container(),
                              ]
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
    );
  }
}

class CustomSearchTile extends StatelessWidget {
  CustomSearchTile(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.imageUrl,
      required this.category})
      : super(key: key);
  String userName;
  String userEmail;
  String imageUrl;
  String category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: imageUrl == ''
            ? CircleAvatar(
                backgroundImage: const AssetImage('icons/default_profile.png'),
                backgroundColor: lightPurple.withOpacity(0.4),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: lightPurple.withOpacity(0.4),
              ),
        title: Text(userName),
        subtitle: Text(userEmail),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FreelancerProfileScreen(
                userName: userName,
                userEmail: userEmail,
                userProfileUrl: imageUrl,
                requestCategory: 'Special Category',
              ),
            ));
      },
    );
  }
}
