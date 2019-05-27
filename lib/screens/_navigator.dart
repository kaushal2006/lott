import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/common/route_list.dart';

class LottNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
            padding: const EdgeInsets.only(top: 0.0),
            children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text(
              AppData().getUser().firstName.toUpperCase(),
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  color: Colors.green[300],
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(AppData().getUser().emailId,
                style: TextStyle(
                    color: Colors.green[300],
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            currentAccountPicture: new CircleAvatar(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green[300],
                child: new Text(AppData()
                    .getUser()
                    .firstName
                    .substring(0, 2)
                    .toUpperCase())),

            /*otherAccountsPictures: <Widget>[
                    new GestureDetector(
                      onTap: () => _onTapOtherAccounts(context),
                      child: new Semantics(
                        label: AppData().getMessage("switchAccount"),
                        child: new CircleAvatar(
                          //backgroundColor: Colors.blueGrey.shade300,
                          child: new Text('SA'),
                        ),
                      ),
                    )
                  ]*/
          ),
          new ListTile(
            leading: new Icon(Icons.edit),
            title: new Text(AppData().getMessage("loadInventory")),
            onTap: () {
              Navigator.of(context).popAndPushNamed(ROUTE_LIST_STORE_PURCHASE);
            },
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(Icons.calendar_view_day),
            title: new Text(AppData().getMessage("saleInventory")),
            onTap: () {
              Navigator.of(context).popAndPushNamed(ROUTE_LIST_STORE_SALES);
            },
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(Icons.add_circle),
            title: new Text(AppData().getMessage("addStore")),
            onTap: () {
              Navigator.of(context).popAndPushNamed(ROUTE_ADD_STORE);
              // Navigator.of(context).pushNamed(Notes.routeName) won't have
              // transition animation and can be used for modal forms
              // Which we will see in Forms & Validation.
              // Navigator.of(context).pushNamed(Notes.routeName);

              // To add transition we are using PageRouteBuilder
              /*Navigator.of(context).push(new PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) {
                    return new Notes();
                  }, transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                    return new FadeTransition(opacity: animation, child: child);
                  }));*/
            },
          ),
          new ListTile(
            leading: new Icon(Icons.list),
            title: new Text(AppData().getMessage("listStore")),
            onTap: () {
              Navigator.of(context).popAndPushNamed(ROUTE_LIST_STORE);
            },
          ),
          new Divider(),
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
          ),
        ]));
  }

  _onLogout(BuildContext context) {
    AppData().getAuth().signOut();
    Navigator.of(context).pushReplacementNamed(ROUTE_LOGIN);
    AppData().clearUserData();
  }

  _onListTileTap(BuildContext context) {
    /*Navigator.of(context).pop();
    showDialog<Null>(
      context: context,
      child: new AlertDialog(
        title: const Text('Not Implemented'),
        actions: <Widget>[
          new FlatButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );*/
  }
}
