import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/mixins/app_utils_mixin.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({this.onSignedOut});
  final VoidCallback onSignedOut;
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with AppUtilsMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          new Container(
              height: 230,
              alignment: Alignment.center,
              padding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: new BoxDecoration(
                color: colorSettingsTab,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(AppData().getUser().firstName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        //fontFamily: "Simplifica"
                      )),
                  new Text(AppData().getUser().emailId,
                      style: TextStyle(
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                        fontSize: 18,
                        //fontFamily: "Simplifica"
                      )),
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Divider(),
                  //*** ADD activate account or Deactivate my account */
                  new ListTile(
                    leading: new Icon(Icons.settings),
                    title: new Text(AppData().getMessage("settings")),
                    onTap: () => _onListTileTap(context),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.help),
                    title: new Text(AppData().getMessage("help")),
                    onTap: () => _onListTileTap(context),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.power_settings_new),
                    title: new Text(AppData().getMessage("logout")),
                    onTap: () => _onLogout(context),
                  )
                ],
              )),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[]),
        ],
      ),
    );
  }

  _onLogout(BuildContext context) {
    widget.onSignedOut();
  }

  _onListTileTap(BuildContext context) {}
}
