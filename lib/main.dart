// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ree_gig/admin_panel/start_myadmin_panel.dart';
import 'package:ree_gig/home_screen.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/security_section/forgot_password.dart';
import 'package:ree_gig/security_section/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  print('MyApp is running.....');
  runApp(MyApp());
}

//class MyApp extends StatelessWidget {
//  MyApp({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    print("MyApp Bulid Run");
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'REE GIG',
//      theme: ThemeData(
//        primaryColor: const Color(0xff821591),
//        appBarTheme: const AppBarTheme(
//          backgroundColor: Color(0xff540E79),
//          actionsIconTheme: IconThemeData(color: Colors.white),
//          iconTheme: IconThemeData(color: Colors.white),
//          foregroundColor: Colors.white,
//          centerTitle: true,
//          elevation: 0.0,
//        ),
//      ),
//      initialRoute: WelcomeScreen.id,
////      WelcomeScreen
////      HomeScreen
//      routes: {
//        WelcomeScreen.id: (context) => const WelcomeScreen(),
////        SigninScreen.id: (context) => SigninScreen(),
////        RegisterScreen.id: (context) => const RegisterScreen(),
//        ForgotPassword.id: (context) => const ForgotPassword(),
////        ChangePassword.id: (context) => const ChangePassword(),
//        HomeScreen.id: (context) => HomeScreen(),
////        SettingsScreen.id: (context) => SettingsScreen(),
//      },
//    );
//  }
//}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final storage = const FlutterSecureStorage();
  bool _isAdminLogin = false;

  Future<bool> checkLoginStatus() async {
    String? value = await storage.read(key: 'uid');
    if (value == null) {
      print('User is logOUT');
      return false;
    } else {
      print('User is logIN');
      return true;
    }
  }

  readFutureValue() async {
    print('Reading Future Values');
    var _mode = await readMode();
    var _loginValue = await readAdminLogin();
    print('_mode : $_mode');
    print('_adminLoginValue : $_loginValue');
    setState(() {
      _isAdminLogin = _loginValue;
    });
  }

  @override
  void initState() {
    readFutureValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'REE GIG',
      theme: ThemeData(
        primaryColor: const Color(0xff821591),
        splashColor: lightPurple.withOpacity(0.1),
        accentColor: lightPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff540E79),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
        ),
      ),
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            //Check for errors
            if (snapshot.hasError) {
              print('Something went wrong.');
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: lightPurple,
                    strokeWidth: 2.0,
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              try {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'REE GIG',
                  theme: ThemeData(
                    primaryColor: const Color(0xff821591),
                    splashColor: lightPurple.withOpacity(0.4),
                    accentColor: lightPurple,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Color(0xff540E79),
                      actionsIconTheme: IconThemeData(color: Colors.white),
                      iconTheme: IconThemeData(color: Colors.white),
                      foregroundColor: Colors.white,
                      centerTitle: true,
                      elevation: 0.0,
                    ),
                  ),
//        initialRoute: WelcomeScreen.id,
                  routes: {
                    WelcomeScreen.id: (context) => const WelcomeScreen(),
//                SigninScreen.id: (context) => SigninScreen(),
//                RegisterScreen.id: (context) => const RegisterScreen(),
                    ForgotPassword.id: (context) => const ForgotPassword(),
//                ChangePassword.id: (context) => const ChangePassword(),
                    HomeScreen.id: (context) => HomeScreen(),
                  },
                  home: FutureBuilder(
                    future: checkLoginStatus(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.data == false) {
                        print('Welcome Screen Called');
                        return const WelcomeScreen();
//                      HomeScreen();
//                    const WelcomeScreen();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return MaterialApp(
                          debugShowCheckedModeBanner: false,
                          title: 'REE GIG',
                          theme: ThemeData(
                            primaryColor: const Color(0xff821591),
                            appBarTheme: const AppBarTheme(
                              backgroundColor: Color(0xff540E79),
                              actionsIconTheme:
                                  IconThemeData(color: Colors.white),
                              iconTheme: IconThemeData(color: Colors.white),
                              foregroundColor: Colors.white,
                              centerTitle: true,
                              elevation: 0.0,
                            ),
                          ),
                          home: Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(
                                color: lightPurple,
                                strokeWidth: 2.0,
                              ),
                            ),
                          ),
                        );
                      }
                      print('Home Screen Called');
                      // ignore: unrelated_type_equality_checks
                      return _isAdminLogin ? StartMyAdminPanel() : HomeScreen();
                    },
                  ),
                );
              } catch (e) {
                print('Error in running the app');
              }
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: lightPurple,
                  strokeWidth: 2.0,
                ),
              ),
            );
          }),
    );
  }
}
