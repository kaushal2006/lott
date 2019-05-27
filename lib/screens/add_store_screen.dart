import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/common/route_list.dart';
import 'package:lott/mixins/app_utils_mixin.dart';

class AddStorePage extends StatelessWidget with AppUtilsMixin {
  AddStorePage({this.bottomTab});
  final String bottomTab;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildScaffoldWithCustomAppBarWithKey(
        Container(child: AddStore(this.bottomTab)),
        AppBar(
          backgroundColor: colorAccountsTab,
          centerTitle: true,
          elevation: 0.0,
          title: Text(AppData().getMessage("addStore"),
              style: TextStyle(color: Colors.white)),
        ),
        _scaffoldKey);
  }
}

class AddStore extends StatefulWidget {
  AddStore(this.bottomTab);
  final String bottomTab;
  @override
  _AddStoreState createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> with AppUtilsMixin {
  String _storeAvatar;
  String _state;
  String _stateFullVal;
  String _storeName;
  String _errorMessage;
  String _stateSelectionValidate = "";
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";

    if (!AppData().getCurrentStore(widget.bottomTab).isNew) {
      return;
    }
    _storeName = AppData().getCurrentStore(widget.bottomTab).name;
    _state = AppData().getCurrentStore(widget.bottomTab).state;
    super.initState();
  }

  void _showAccountCreationSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Store account has been created"),
          content: new Text("Please click on Inventory Tab to Load Products"),
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

  bool validateAndSave() {
    String error = "";
    bool result = true;
    if (_state == null || _state.isEmpty) {
      error = "This field is required";
      result = false;
    }
    setState(() {
      _stateSelectionValidate = error;
    });
    final form = _formKey.currentState;
    if (form.validate() && result) {
      form.save();
      result = true;
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        _storeName = _storeName.toUpperCase();
        AppData().getCurrentStore(widget.bottomTab).setIsNew(true);
        AppData().getCurrentStore(widget.bottomTab).setAvatar(_storeAvatar);
        AppData().getCurrentStore(widget.bottomTab).setName(_storeName);
        AppData().getCurrentStore(widget.bottomTab).setState(_state);
        AppData()
            .getDatabase()
            .addStore(widget.bottomTab, AppData().getUser().emailId,
                AppData().getCurrentStore(widget.bottomTab))
            .then((_) {
          _showAccountCreationSuccessDialog();
        }).catchError((onError) {
          _errorMessage = 'Failed to create Store Account, ' + onError;
        });
      } catch (e) {
        _errorMessage = 'Failed to create Store Account, ' + e;
        print('Failed to add Store Account');
        print('Error: $e');
      }
    }
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
              Icons.work,
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

  Widget _showStateDropDown() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                  icon: const Icon(Icons.location_on, color: Colors.green),
                  labelText: 'Select State'),
              isEmpty: _stateFullVal == '',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _stateFullVal,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _state = newValue.substring(0, 2);
                      _stateFullVal = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: getAllStates().map((String value) {
                    return new DropdownMenuItem<String>(
                      //key: Key(value.substring(0,2)),
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ));
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
            child: new Text("Create"),
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

  Widget _showErrorStateSelectionMessage() {
    if (_stateSelectionValidate != null && _stateSelectionValidate.length > 0) {
      return new Container(
        padding: EdgeInsets.fromLTRB(40, 5, 5, 0),
        child: Text(
          _stateSelectionValidate,
          style: TextStyle(color: Colors.red),
        ),
        alignment: Alignment.centerLeft,
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red[50]),
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
        padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(shrinkWrap: true, children: <Widget>[
            _showStoreName(),
            _showPadding(),
            _showStateDropDown(),
            _showErrorStateSelectionMessage(),
            _showPadding(),
            _showStoreAvatarButton(),
            _showPadding(),
            _showErrorMessage(),
            _showPadding(),
            _showPrimaryButton(),
          ]),
        ));
  }
}
