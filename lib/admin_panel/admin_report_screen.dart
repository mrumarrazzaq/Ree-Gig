import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';

class AdminReportScreen extends StatefulWidget {
  static const String id = 'HistoryScreen';
  @override
  _AdminReportScreenState createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  final Stream<QuerySnapshot> _reports =
      FirebaseFirestore.instance.collection('Reports').snapshots();
  @override
  Widget build(BuildContext context) {
    print('Report Screen Bulid Running.....');
    return Scaffold(
      backgroundColor: neuColor,
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Users ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              TextSpan(
                  text: 'Reports',
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
              stream: _reports,
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
                final List storeReports = [];

                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  storeReports.add(id);
//                  print('==============================================');
//                  print(storeRequests);
//                  print('Document id : ${document.id}');
                  id['id'] = document.id;
                }).toList();
                print('Total Registerd Reports ${storeReports.length}');
                saveReports(storeReports.length.toDouble());
                return Column(
//                            shrinkWrap: true,
                  children: [
                    storeReports.isEmpty
                        ? const Text('No User find')
                        : Container(),
                    for (int i = 0; i < storeReports.length; i++) ...[
                      Card(
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          side: BorderSide(width: 1, color: lightPink),
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${storeReports[i]['User Name']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${storeReports[i]['User Email']}'),
                                const Divider(),
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('${storeReports[i]['Report Text']}',
                                textAlign: TextAlign.justify),
                          ),
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
