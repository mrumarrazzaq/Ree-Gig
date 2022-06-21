import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';

import 'admin_dashboard_screen.dart';
import 'admin_report_screen.dart';
import 'admin_request_screen.dart';
import 'admin_user_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  bool isAppBarVisible = true;

  final tabs = [
    AdminDashboardScreen(),
    AdminUserScreen(),
    AdminRequestScreen(),
    AdminReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    print('Home Screen Bulid Running.....');
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: neuColor,
        elevation: 10.0,
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        selectedItemColor: lightPurple,
        unselectedItemColor: blackColor,
//        unselectedLabelStyle: const TextStyle(fontFamily: 'SourceSansPro'),
        selectedFontSize: 10.0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_sharp),
            label: 'Reports',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: FloatingActionButton(
//        mini: true,
//        elevation: 3.0,
//        onPressed: () {},
//        tooltip: 'Increment',
//        child: const Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
