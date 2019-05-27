import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/mixins/app_utils_mixin.dart';

class StoreAvatarsScreen extends StatelessWidget with AppUtilsMixin {
  StoreAvatarsScreen({this.bottomTab});
  final String bottomTab;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static int _totalAvatars = 30;
  @override
  Widget build(BuildContext context) {
    return buildScaffoldWithCustomAppBarWithKey(
        Container(child: avatarGrid()),
        AppBar(
          backgroundColor: Color.fromRGBO(87, 122, 127, 1.0),
          centerTitle: true,
          elevation: 0.0,
          title: Text(AppData().getMessage("Select Store Avatar"),
              style: TextStyle(color: Colors.white)),
        ),
        _scaffoldKey);
  }

  avatarGrid() {
    return GridView.builder(
        itemCount: _totalAvatars,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Container(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //color: Colors.white,
                  ),
                  child: Image.asset('assets/storeavatars/$index.png'),
                ),
              ),
            ),
            onTap: () {
              AppData().getCurrentStore(bottomTab).setAvatar(index.toString());
              Navigator.of(context).pop();
            },
          );
        });
  }
}
