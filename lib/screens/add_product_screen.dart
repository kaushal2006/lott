import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/common/route_list.dart';
import 'package:lott/mixins/app_utils_mixin.dart';

class AddProductPage extends StatelessWidget with AppUtilsMixin {
  AddProductPage({this.bottomTab});
  final String bottomTab;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildScaffoldWithCustomAppBarWithKey(
        Container(child: AddProduct(this.bottomTab)),
        AppBar(
          backgroundColor: colorInventoryTab,
          centerTitle: true,
          elevation: 0.0,
          title: Text(AppData().getMessage("addProduct"),
              style: TextStyle(color: Colors.white)),
        ),
        _scaffoldKey);
  }
}

class AddProduct extends StatefulWidget {
  AddProduct(this.bottomTab);
  final String bottomTab;
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> with AppUtilsMixin {
  String _state;
  String _errorMessage;
  String _priceSelectionValidate = "";

  String _gameNumber;
  String _gameName;
  String _onSale;
  num _price;
  String _endSale;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";
    _state = AppData().getCurrentStore(widget.bottomTab).state;
    super.initState();
  }

  void _showAccountCreationSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Game should be available to Inventory Tab"),
          content: new Text("Please click on Inventory Tab to load products"),
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
    if (_gameNumber == null || _gameNumber.isEmpty) {
      error = "This field is required";
      result = false;
    }

    if (_gameName == null || _gameName.isEmpty) {
      error = "This field is required";
      result = false;
    }

    setState(() {
      _priceSelectionValidate = error;
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
        _gameName = _gameName.toLowerCase();
        AppData()
            .getDatabase()
            .addProduct(_state, _gameName, _gameNumber, _price)
            .then((_) {
          _showAccountCreationSuccessDialog();
        }).catchError((onError) {
          _errorMessage = 'Failed to create Product, ' + onError;
        });
      } catch (e) {
        _errorMessage = 'Failed to create Product, ' + e;
        print('Failed to add Product Account');
        print('Error: $e');
      }
    }
  }

  Widget _showCurrentStateName() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          const Icon(Icons.location_on, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          ),
          Container(
              child: new Text(
                  _state == null
                      ? "State: n/a"
                      : "State: " + getStateFullName(_state),
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold))),
        ]));
  }

  Widget _showGameName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        //enabled: true,
        initialValue: _gameName,
        keyboardType: TextInputType.text,
        autofocus: false,
        maxLength: 50,
        decoration: new InputDecoration(
            hintText: 'Game Name',
            icon: new Icon(
              Icons.text_fields,
              color: Colors.green[300],
            )),
        validator: (value) => validateText(value),
        onSaved: (value) => _gameName = value,
      ),
    );
  }

  Widget _showGameNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        //enabled: true,
        initialValue: _gameNumber,
        keyboardType: TextInputType.text,
        autofocus: false,
        maxLength: 30,
        decoration: new InputDecoration(
            hintText: 'Game Number',
            icon: new Icon(
              Icons.text_fields,
              color: Colors.green[300],
            )),
        validator: (value) => validateText(value),
        onSaved: (value) => _gameNumber = value,
      ),
    );
  }

  Widget _showPriceDropDown() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                  icon: const Icon(Icons.attach_money, color: Colors.green),
                  labelText: 'Price'),
              isEmpty: _price.toString() == '',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<num>(
                  value: _price,
                  isDense: true,
                  onChanged: (num newValue) {
                    setState(() {
                      _price = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: getProductPrices().map((num value) {
                    return new DropdownMenuItem<num>(
                      //key: Key(value.substring(0,2)),
                      value: value,
                      child: new Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ));
  }

  Widget _showErrorPriceSelectionMessage() {
    if (_priceSelectionValidate != null && _priceSelectionValidate.length > 0) {
      return new Container(
        padding: EdgeInsets.fromLTRB(40, 5, 5, 0),
        child: Text(
          _priceSelectionValidate,
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

  Widget _showPadding() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
    );
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
            _showCurrentStateName(),
            _showPadding(),
            _showGameName(),
            _showPadding(),
            _showGameNumber(),
            _showPriceDropDown(),
            _showErrorPriceSelectionMessage(),
            _showPadding(),
            _showErrorMessage(),
            _showPadding(),
            _showPrimaryButton(),
          ]),
        ));
  }
}
