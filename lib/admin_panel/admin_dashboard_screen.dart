// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/security_section/signin_screen2.dart';

class AdminDashboardScreen extends StatefulWidget {
  static const String id = 'DashboardScreen';

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isTrue = true;

  int index = 0;

  double users = 50;
  double requests = 50;
  double reports = 50;

  readTotals() async {
    String _userValue = await readUsers();
    String _userRequests = await readRequests();
    String _userReports = await readReports();
    setState(() {
      users = double.parse(_userValue);
      requests = double.parse(_userRequests);
      reports = double.parse(_userReports);

      print('=============================');
      print(users);
      print(requests);
      print(reports);
      print('=============================');
    });
  }

  @override
  void initState() {
    readTotals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Dashboard Bulid Running.....');
//    if (_isTrue) {
//      readTotals();
//      _isTrue = false;
//    }
    return Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              text: '', // default text style
              children: <TextSpan>[
                TextSpan(
                    text: 'REE ',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text: 'GIG', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async => {
                      await FirebaseAuth.instance.signOut(),
                      isUserLogout = true,
                      await storage.delete(key: 'uid'),
                      await saveAdminLogin(false),
                      // ignore: avoid_print
                      print('SignOut called'),
                      await Fluttertoast.showToast(
                        msg: 'Admin Logout Successfully', // message
                        toastLength: Toast.LENGTH_SHORT, // length
                        gravity: ToastGravity.BOTTOM, // location
                        backgroundColor: Colors.green,
                      ),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                          (route) => false),
                    },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          ],
        ),
        backgroundColor: neuColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: Text.rich(
                  TextSpan(
                    text: '', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Admin ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0)),
                      TextSpan(
                          text: 'Panel',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 30.0)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 40.0),
                child: PieChart(
                  dataMap: {
                    'Users': users,
                    'Requests': requests,
                    'Reports': reports,
                  },
                  chartRadius: 200,
                  chartLegendSpacing: 100,
                  ringStrokeWidth: 12.0,
                  chartType: ChartType.ring,
                  emptyColor: Colors.transparent,
                  centerTextStyle: const TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                  centerText: 'Dashboard',
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true,
                    showChartValues: false,
                    showChartValuesOutside: false,
                    showChartValueBackground: false,
                  ),
                  degreeOptions:
                      const DegreeOptions(initialAngle: 0.0, totalDegrees: 360),
                  legendOptions: const LegendOptions(
                    showLegends: false,
                  ),
                  colorList: const [
                    Colors.cyan,
                    Colors.yellow,
                    Colors.pink,
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        CustomCard(
                          color: Colors.cyan,
                          circleColor: Colors.cyan.withOpacity(0.3),
                          icon: Icons.supervisor_account,
                          title: 'Users',
                          value: '$users ',
                          topPadding: 12.0,
                          height: 120,
                          width: 100,
                        ),
                        CustomCard(
                          color: Colors.yellow,
                          circleColor: Colors.yellow.withOpacity(0.3),
                          icon: Icons.request_page,
                          title: 'Requests',
                          value: '$requests ',
                          topPadding: 12.0,
                          height: 120,
                          width: 100,
                        ),
                        CustomCard(
                          color: Colors.pink,
                          circleColor: Colors.pink.withOpacity(0.3),
                          icon: Icons.report_sharp,
                          title: 'Reports',
                          value: '$reports ',
                          topPadding: 12.0,
                          height: 120,
                          width: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.width,
    this.height,
    this.circleColor,
    required this.topPadding,
  }) : super(key: key);

  String title;
  String value;
  Color color;
  IconData icon;
  double? height = 95;
  double? width = 120;
  double topPadding = 12.0;
  Color? circleColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(6.0),
      padding: const EdgeInsets.only(left: 12.0, top: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 0.3,
            offset: const Offset(0.5, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: circleColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Icon(icon, color: color)),
          Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: 3.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
                color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
