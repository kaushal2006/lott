import 'package:flutter/material.dart';
import 'package:lott/models/product.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/common/route_list.dart';

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
  String _rollSizeSelectionValidate = "";

  String _gameNumber = "124";
  String _gameName = "test 124";
  //String _onSale;
  num _price = 1;
  num _rollSize = 300;
  //String _endSale;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";
    _state = AppData().getCurrentStore(widget.bottomTab).state;
    super.initState();
  }

  void _showProductCreationSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Game is available to Inventory"),
          content: new Text("Please click on Inventory Tab to load inventory"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    ROUTE_LIST_STORE_PURCHASE,
                    ModalRoute.withName(ROUTE_LIST_STORE_PURCHASE));
              },
            ),
          ],
        );
      },
    );
  }

  bool validateAndSave() {
    _priceSelectionValidate = "";
    _rollSizeSelectionValidate = "";
    bool result = true;
    if (_price == null || _price == 0) {
      result = false;
      setState(() {
        _priceSelectionValidate = "This field is required";
      });
    }

    if (_rollSize == null || _rollSize == 0) {
      result = false;
      setState(() {
        _rollSizeSelectionValidate = "This field is required";
      });
    }

    final form = _formKey.currentState;
    if (form.validate() && result) {
      form.save();
      result = true;
      return true;
    }
    return false;
  }

  bool isGameNumberExist() {
    Map<String, Product> products = AppData().getProductsByState(_state);
    if (null != products) {
      products.forEach((id, p) {
        if (p.gameNumber == _gameNumber) {
          setState(() {
            _errorMessage = "Game is already exist in state of " + getStateFullName(_state);
          });
          return true;
        }
      });
    }
    return false;
  }

  void validateAndSubmit() async {
    if (!validateAndSave()) return;
    if (isGameNumberExist()) return;

    try {
      Product p = new Product();
      p.setGameName(_gameName.toLowerCase());
      p.setGameNumber(_gameNumber);
      p.setPrice(_price);
      p.setRollSize(_rollSize);
      p.setState(_state);
      p.setCreated(new DateTime.now());
      //p.setUpdated(new DateTime.now());
      p.setActivated(new DateTime.now());
      p.setActive(true);
      p.setCreatedBy(AppData().getUser().emailId);
      AppData().getDatabase().addProductWithCaution(p).then((result) {
        //print(result.toString());
        if (result)
          _showProductCreationSuccessDialog();
        else {
          setState(() {
            _errorMessage = "Game is already exist for the state";
          });
        }
      }).catchError((onError) {
        setState(() {
          _errorMessage = 'Failed to add new Game, ' + onError.toString();
        });
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to add new Game, ' + e;
      });
      //print('Failed to add new Game');
      //print('Error: $e');
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
                      color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16))),
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
              Icons.confirmation_number,
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
        keyboardType: TextInputType.number,
        autofocus: false,
        maxLength: 10,
        decoration: new InputDecoration(
            hintText: 'Game Number',
            icon: new Icon(
              Icons.games,
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

  Widget _showRollSizeDropDown() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new FormField(
          builder: (FormFieldState state) {
            return InputDecorator(
              decoration: InputDecoration(
                  icon: const Icon(Icons.view_headline, color: Colors.green),
                  labelText: 'RollSize'),
              isEmpty: _rollSize.toString() == '',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<num>(
                  value: _rollSize,
                  isDense: true,
                  onChanged: (num newValue) {
                    setState(() {
                      _rollSize = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: getRollSizes().map((num value) {
                    return new DropdownMenuItem<num>(
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

  Widget _showErrorRollSizeSelectionMessage() {
    if (_rollSizeSelectionValidate != null &&
        _rollSizeSelectionValidate.length > 0) {
      return new Container(
        padding: EdgeInsets.fromLTRB(40, 5, 5, 0),
        child: Text(
          _rollSizeSelectionValidate,
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
      return Column(
        children: <Widget>[
          _showPadding(),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            alignment: Alignment.topCenter,
          ),
        ],
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
            _showErrorMessage(),
            //_showPadding(),
            _showGameName(),
            _showPadding(),
            _showGameNumber(),
            _showPriceDropDown(),
            _showErrorPriceSelectionMessage(),
            _showRollSizeDropDown(),
            _showErrorRollSizeSelectionMessage(),
            _showPadding(),
            _showPadding(),
            _showPrimaryButton(),
          ]),
        ));
  }
}
