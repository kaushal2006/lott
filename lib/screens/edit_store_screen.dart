import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/common/route_list.dart';
import 'package:lott/mixins/app_utils_mixin.dart';

class EditStorePage extends StatelessWidget with AppUtilsMixin {
  EditStorePage({this.bottomTab});
  final String bottomTab;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildScaffoldWithCustomAppBarWithKey(
        Container(child: EditStore(this.bottomTab)),
        AppBar(
          backgroundColor: colorAccountsTab,
          centerTitle: true,
          elevation: 0.0,
          title: Text(AppData().getMessage("editStore"),
              style: TextStyle(color: Colors.white)),
        ),
        _scaffoldKey);
  }
}

class EditStore extends StatefulWidget {
  EditStore(this.bottomTab);
  final String bottomTab;
  @override
  _EditStoreState createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> with AppUtilsMixin {
  String _storeAvatar;
  String _state;
  String _storeName;
  String _errorMessage;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";
    if (AppData().getCurrentStore(widget.bottomTab).isNew) {
      return;
    }
    _storeName = AppData().getCurrentStore(widget.bottomTab).name;
    _state = AppData().getCurrentStore(widget.bottomTab).state;
    super.initState();
  }

  void _showAccountUpdateSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Store account has been updated"),
          //content: new Text(""),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Navigator.defaultRouteName,
                    ModalRoute.withName(Navigator.defaultRouteName));
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteStoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialogBox(
            Icons.warning,
            "Are you sure you want to Delete Store?",
            "NOTE: This store account will be deleted permanently. Please Ok to proceed",
            <Widget>[
              MaterialButton(
                height: 45.0,
                minWidth: 100.0,
                textColor: Colors.white,
                color: Colors.redAccent,
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteStoreSubmit();
                },
                splashColor: Colors.orange,
              ),
              new FlatButton(
                textColor: Colors.grey,
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]);
      },
    );
  }

  void _deleteStoreSubmit() {
    try {
      AppData()
          .getDatabase()
          .deleteStore(widget.bottomTab, AppData().getUser().emailId,
              AppData().getCurrentStore(widget.bottomTab))
          .catchError((onError) {
        _errorMessage = 'Failed to delete Store Account, ' + onError;
      }).whenComplete(() {
        _showAccountUpdateSuccessDialog();
      });
    } catch (e) {
      _errorMessage = 'Failed to delete  Store Account, ' + e;
      print('Failed to delete Store Account');
      print('Error: $e');
    }
  }

  void _deactivateOrActivateStoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialogBox(
            Icons.warning,
            AppData().getCurrentStore(widget.bottomTab).isActivated
                ? "Are you sure you want to Deactivate Store?"
                : "Are you sure you want to Activate Store?",
            "Please Ok to proceed",
            <Widget>[
              MaterialButton(
                height: 45.0,
                minWidth: 100.0,
                textColor: Colors.white,
                color: Colors.redAccent,
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deactivateActivateStoreSubmit();
                },
                splashColor: Colors.orange,
              ),
              new FlatButton(
                textColor: Colors.grey,
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]);
      },
    );
  }

  void _deactivateActivateStoreSubmit() {
    try {
      AppData()
          .getDatabase()
          .deactivateOrActivateStore(
              widget.bottomTab,
              AppData().getUser().emailId,
              AppData().getCurrentStore(widget.bottomTab))
          .catchError((onError) {
        _errorMessage = 'Failed to update Store Account, ' + onError;
      }).whenComplete(() {
        _showAccountUpdateSuccessDialog();
      });
    } catch (e) {
      _errorMessage = 'Failed to update Store Account, ' + e;
      print('Failed to update Store Account');
      print('Error: $e');
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        AppData().getCurrentStore(widget.bottomTab).setAvatar(_storeAvatar);
        AppData().getCurrentStore(widget.bottomTab).setName(_storeName);
        AppData()
            .getDatabase()
            .editStore(widget.bottomTab, AppData().getUser().emailId,
                AppData().getCurrentStore(widget.bottomTab))
            .then((_) {
          _showAccountUpdateSuccessDialog();
        }).catchError((onError) {
          _errorMessage = 'Failed to update Store Account, ' + onError;
        });
      } catch (e) {
        _errorMessage = 'Failed to update Store Account, ' + e;
        print('Failed to update Store Account');
        print('Error: $e');
      }
    }
  }

  Widget _showStoreId() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          const Icon(Icons.info, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          ),
          Container(
              child: new Text(
                  AppData().getCurrentStore(widget.bottomTab).id == null
                      ? "Store ID: n/a"
                      : "Store ID: " +
                          AppData().getCurrentStore(widget.bottomTab).id,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold))),
        ]));
  }

  Widget _showStoreCreated() {
    String storeCreatedOn =
        formatDate(AppData().getCurrentStore(widget.bottomTab).created);

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          const Icon(Icons.info, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          ),
          Container(
              child: new Text(
            "Created on " + storeCreatedOn,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          )),
        ]));
  }

  Widget _showStoreName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        //enabled: true,
        initialValue: _storeName,
        keyboardType: TextInputType.text,
        autofocus: false,
        maxLength: 20,
        decoration: new InputDecoration(
            hintText: 'Store Name',
            icon: new Icon(
              Icons.business,
              color: Colors.green[300],
            )),
        validator: (value) => validateText(value),
        onSaved: (value) => _storeName = value,
      ),
    );
  }

  Widget _showPadding() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
    );
  }

  Widget _showState() {
    String stateFullVal = getStateFullName(_state);

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Icon(Icons.location_on, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
          ),
          Container(
              child: new Text(
            stateFullVal,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          )),
        ]));
  }

  Widget _showStoreAvatarButton() {
    _storeAvatar = AppData().getCurrentStore(widget.bottomTab).avatar;
    if (!isNumeric(_storeAvatar)) _storeAvatar = null;

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          const Icon(Icons.wallpaper, color: Colors.green),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          ),
          Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                  Widget>[
            (_storeAvatar == null)
                ? Container()
                : Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      //color: Colors.white,
                    ),
                    child: Image.asset('assets/storeavatars/$_storeAvatar.png'),
                  ),
            MaterialButton(
              height: 40.0,
              minWidth: 120.0,
              color: Colors.grey,
              textColor: Colors.white,
              child: (_storeAvatar == null)
                  ? new Text("Select Avatar")
                  : new Text("Change Avatar"),
              onPressed: () {
                Navigator.of(context).pushNamed(ROUTE_STORE_AVATARS);
              },
              splashColor: Colors.redAccent,
            ),
          ])),
        ]));
  }

  Widget _showPrimaryButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new MaterialButton(
            height: 50.0,
            minWidth: 200.0,
            color: Colors.green[300],
            textColor: Colors.white,
            child: new Text("Update"),
            onPressed: validateAndSubmit,
            splashColor: Colors.redAccent,
          ),
          new FlatButton(
            child: new Text("cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]);
  }

  Widget _deactivateOrActivateStoreButton() {
    return Container(
        // height: 20,
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        alignment: Alignment.center,
        child: new FlatButton(
            child: AppData().getCurrentStore(widget.bottomTab).isActivated
                ? new Text("Click here to Deactivate Store",
                    style: TextStyle(color: Colors.grey))
                : new Text("Click here to Activate Store"),
            onPressed: () => _deactivateOrActivateStoreDialog()));
  }

  Widget _deleteStoreButton() {
    return Container(
        alignment: Alignment.center,
        height: 15,
        child: new FlatButton(
            child: new Text(
              "Click here to Delete store",
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () => _deleteStoreDialog()));
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        ),
        alignment: Alignment.topCenter,
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        constraints: BoxConstraints.expand(),
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: new Form(
          key: _formKey,
          child: new ListView(shrinkWrap: true, children: <Widget>[
            _showStoreId(),
            _showStoreCreated(),
            _showPadding(),
            _showStoreName(),
            _showPadding(),
            _showState(),
            _showPadding(),
            _showStoreAvatarButton(),
            _showPadding(),
            _showErrorMessage(),
            _showPadding(),
            _showPrimaryButton(),
            _deactivateOrActivateStoreButton(),
            _deleteStoreButton(),
          ]),
        ));
  }
}
