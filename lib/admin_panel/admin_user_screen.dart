import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';

class AdminUserScreen extends StatefulWidget {
  static const String id = 'UserScreen';
  @override
  _AdminUserScreenState createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  final Stream<QuerySnapshot> _registerdUsers =
      FirebaseFirestore.instance.collection('User Data').snapshots();

  @override
  Widget build(BuildContext context) {
    print('User Screen Bulid Running.....');
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Registered ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              TextSpan(
                  text: 'Users',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
        backgroundColor: neuColor,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _registerdUsers,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                        child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: lightPurple,
                        strokeWidth: 2.0,
                      ),
                    )),
                  );
                }
                final List storeUsers = [];

                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  storeUsers.add(id);
//                  print('==============================================');
//                  print(storeRequests);
//                  print('Document id : ${document.id}');
                  id['id'] = document.id;
                }).toList();
                print('Total Registerd Users ${storeUsers.length}');
                saveUsers(storeUsers.length.toDouble());
                return Column(
//                            shrinkWrap: true,
                  children: [
                    storeUsers.isEmpty
                        ? const Text('No User find')
                        : Container(),
                    for (int i = 0; i < storeUsers.length; i++) ...[
                      GestureDetector(
                        onTap: () {
                          storeUsers[i]['imageUrl'] == ''
                              ? null
                              : showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    content: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.network(
                                          '${storeUsers[i]['imageUrl']}'),
                                    ),
                                  ),
                                );
                        },
                        child: ListTile(
                          dense: true,
                          minLeadingWidth: 0.0,
                          leading: CircleAvatar(
                            backgroundImage: storeUsers[i]['imageUrl'] == ''
                                ? null
                                : NetworkImage('${storeUsers[i]['imageUrl']}'),
                            radius: 50,
                            backgroundColor: lightPurple.withOpacity(0.4),
                          ),
                          title: Text('${storeUsers[i]['personName']}'),
                          subtitle: Text('${storeUsers[i]['email']}'),
                        ),
                      ),
                    ],
                  ],
                );
              }),
        ],
      ),
    );
  }
}
