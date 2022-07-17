// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'admin_categories_screen.dart';
import 'admin_dashboard_screen.dart';
import 'admin_home_screen.dart';
import 'admin_report_screen.dart';
import 'admin_request_screen.dart';
import 'admin_user_screen.dart';

class StartMyAdminPanel extends StatelessWidget {
  StartMyAdminPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("MyApp Bulid Run");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'REE GIG',
      theme: ThemeData(
        primaryColor: const Color(0xff821591),
        splashColor: const Color(0xff821591),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff540E79),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
        ),
      ),
      initialRoute: AdminHomeScreen.id,
      routes: {
        AdminHomeScreen.id: (context) => const AdminHomeScreen(),
        AdminDashboardScreen.id: (context) => AdminDashboardScreen(),
        AdminCategoriesScreen.id: (context) => AdminCategoriesScreen(),
        CreateRequestCategory.id: (context) =>
            CreateRequestCategory(isCallForUpdate: false, docId: 'NULL'),
        AdminUserScreen.id: (context) => AdminUserScreen(),
        AdminRequestScreen.id: (context) => AdminRequestScreen(),
        AdminReportScreen.id: (context) => AdminReportScreen(),
      },
    );
  }
}
