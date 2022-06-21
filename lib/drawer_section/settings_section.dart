import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/recomenndations.dart';
import 'change_password.dart';

// ignore: use_key_in_widget_constructors
class SettingsScreen extends StatefulWidget {
  static const String id = 'Settings';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('SettingScreen build is called');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Settings',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          // ignore: deprecated_member_use
          FlatButton(
            child: SettingCard(
              icon: Icon(
                Icons.list,
                color: defaultUIColor,
              ),
              text: 'Manage Recommendations',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Recommendations(),
                ),
              );
            },
          ),
          const Divider(),
          // ignore: deprecated_member_use
          FlatButton(
            child: SettingCard(
              icon: Icon(
                Icons.notifications,
                color: defaultUIColor,
              ),
              text: 'Notifications',
            ),
            onPressed: () {},
          ),
          const Divider(),
          // ignore: deprecated_member_use
          // ignore: deprecated_member_use
          FlatButton(
            child: SettingCard(
              icon: Icon(
                Icons.color_lens,
                color: defaultUIColor,
              ),
              text: 'Customize',
            ),
            onPressed: () {},
          ),
          const Divider(),
          // ignore: deprecated_member_use
          FlatButton(
            child: SettingCard(
              icon: Icon(
                Icons.lock,
                color: defaultUIColor,
              ),
              text: 'LockPin',
            ),
            onPressed: () {},
          ),
          const Divider(),
          // ignore: deprecated_member_use
          FlatButton(
            child: SettingCard(
              icon: Icon(
                Icons.vpn_key,
                color: defaultUIColor,
              ),
              text: 'Change Password',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePassword(),
                ),
              );
            },
          ),
          const Divider(),
          // ignore: deprecated_member_use
          FlatButton(
            child: SettingCard(
              icon: Icon(
                Icons.backup,
                color: defaultUIColor,
              ),
              text: 'Backups',
            ),
            onPressed: () {},
          ),
          const Divider(),
          // ignore: deprecated_member_use
          FlatButton(
            child: SettingCard(
              icon: Icon(
                Icons.info,
                color: defaultUIColor,
              ),
              text: 'Licenses',
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const SettingCard({required this.icon, required this.text});
  final Icon icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(text),
    );
  }
}
