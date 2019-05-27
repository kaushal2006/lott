import 'package:flutter/material.dart';
import 'package:lott/models/store_inventory.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/models/product.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/3pi/numberpicker100/numberpicker.dart';

class ProductSalesBottomSheet extends StatefulWidget {
  final Product product;
  final String bottomTab;
  final int numOfItemsAround;
  ProductSalesBottomSheet(
      {this.bottomTab, this.product, this.numOfItemsAround});

  @override
  State<StatefulWidget> createState() => _ProductSalesBottomSheetState();
}

class _ProductSalesBottomSheetState extends State<ProductSalesBottomSheet>
    with AppUtilsMixin {
  int _currentIntValue;
  int _totalStockInUnits = 0;
  int _tempStock = 0; //remaining
  int _tempStockUnits = 0; //remaining
  int _tempSalesStock = 0; //closing
  int _tempSalesStockUnits = 0; //closing
  int _tempRollOverTickets = 0;
  int _tempTotalTickets = 0;
  StoreInventory _inventory;
  Product _product;
  Widget _numberPicker;
  num _min;
  num _rollSize;
  num _rollSizeForNumberPicker;

  final BoxDecoration scaleGreen = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.3, 0.7, 0.9],
      colors: [
        Color.fromRGBO(51, 175, 157, 1.0),
        Color.fromRGBO(37, 188, 166, 1.0),
        Color.fromRGBO(37, 188, 166, 1.0),
        Color.fromRGBO(51, 175, 157, 1.0),
      ],
    ),
  );

  final BoxDecoration scaleBlue = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.3, 0.7, 0.9],
      colors: [
        Color.fromRGBO(27, 109, 132, 1.0),
        Color.fromRGBO(16, 120, 149, 1.0),
        Color.fromRGBO(16, 120, 149, 1.0),
        Color.fromRGBO(27, 109, 132, 1.0),
      ],
    ),
  );

  final BoxDecoration scaleExtra = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.3, 0.7, 0.9],
      colors: [Colors.grey, Colors.grey, Colors.grey, Colors.grey],
    ),
  );
  BoxDecoration leftScaleDecoration;
  BoxDecoration rightScaleDecoration;

  @override
  void initState() {
    _product = AppData().getCurrentProduct(widget.bottomTab);
    _rollSize = widget.product.rollSize;

    _inventory = AppData()
        .getCurrentStore(widget.bottomTab)
        .getInventoryItem(widget.product.id);

    _tempStock = _inventory.currentStock;
    _tempStockUnits = _inventory.currentStockUnits;
    _totalStockInUnits = (_inventory.currentStock * _rollSize) +
        (_inventory.currentStockUnits == null
            ? 0
            : _inventory.currentStockUnits);

    _min = ((_inventory.currentStockUnits > 0)
            ? _rollSize - _inventory.currentStockUnits
            : 0) +
        1;

    _currentIntValue = _min;

    _rollSizeForNumberPicker =
        _totalStockInUnits + _min + (widget.numOfItemsAround - 1);

    AppData().getCurrentStore(widget.bottomTab).setTempStock(widget.product.id,
        _tempStock, _tempStockUnits, _tempSalesStock, _tempSalesStockUnits);

    leftScaleDecoration = scaleExtra;

    rightScaleDecoration =
        (_currentIntValue + widget.numOfItemsAround <= _rollSize)
            ? scaleBlue
            : scaleGreen;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onChanged(value) {
      setState(() {
        int leftScaleId =
            ((value - widget.numOfItemsAround - 1) / _rollSize).ceil();
        int rightScaleId =
            ((value + widget.numOfItemsAround + 1) / _rollSize).ceil();
        leftScaleDecoration = leftScaleId.isEven ? scaleGreen : scaleBlue;
        rightScaleDecoration = rightScaleId.isEven ? scaleGreen : scaleBlue;

        if ((value - widget.numOfItemsAround - 1) < _min)
          leftScaleDecoration = scaleExtra;

        if ((value + widget.numOfItemsAround + 3) >= _rollSizeForNumberPicker)
          rightScaleDecoration = scaleExtra;

        _currentIntValue = value;
        if (_tempRollOverTickets == 0 && _inventory.currentStockUnits != 0) {
          _tempTotalTickets =
              (_inventory.currentStockUnits - (_rollSize - _currentIntValue));
        } else {
          _tempTotalTickets = _tempRollOverTickets + _currentIntValue;
        }
        _tempStock =
            ((_totalStockInUnits - _tempTotalTickets + 1) / _rollSize).floor();
        _tempStockUnits =
            (((_totalStockInUnits - _tempTotalTickets + 1) % _rollSize)
                .toInt());

        _tempSalesStock = ((_tempTotalTickets + 1) / _rollSize).floor();
        _tempSalesStockUnits = ((_tempTotalTickets - 1) % _rollSize).toInt();

        AppData().getCurrentStore(widget.bottomTab).setTempStock(
            widget.product.id,
            _tempStock,
            _tempStockUnits,
            _tempSalesStock,
            _tempSalesStockUnits);
      });
    }

    _printColumnUtilWidget(
        String title, String val, String val2, var fontColor) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(color: fontColor, fontSize: 15)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                val,
                style: TextStyle(
                  color: fontColor,
                  fontSize: 28,
                ),
              ),
              val2 != null
                  ? Text(
                      val2.toString(),
                      style: TextStyle(
                        color: fontColor,
                        fontSize: 18,
                      ),
                    )
                  : Container(height: 0, width: 0),
            ],
          ),
        ],
      );
    }

    setNumberPicker() {
      Widget tempNumberPicker = MyNumberPicker(
          currentIntValue: _currentIntValue,
          minValue: _min,
          maxValue: _rollSizeForNumberPicker,
          scaleSize: _rollSize,
          step: 1,
          numOfItemsAround: this.widget.numOfItemsAround,
          onChanged: (value) => setState(() {
                _currentIntValue = value;
                onChanged(value);
              }));
      setState(() {
        _numberPicker = tempNumberPicker;
      });
    }

    _printSelectedValPanel() {
      var displayText;
      int displayVal = 0;
      if (_currentIntValue <=
          (_rollSizeForNumberPicker - widget.numOfItemsAround)) {
        displayVal = ((_currentIntValue % _rollSize == 0)
            ? _rollSize
            : (_currentIntValue % _rollSize));
        displayText = displayVal.toString();
      }
      var color = Color.fromRGBO(19, 127, 31, 1);
      if (displayVal == 0) {
        color = Color.fromRGBO(173, 92, 67, 1.0);
        displayText = "Out of Stock";
      }
      return Container(
          height: 55,
          alignment: Alignment.center,
          //padding: EdgeInsets.all(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                height: 3,
                //width: 100,
                color: color,
              )),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 20, 0)),
              Center(
                  child: Text(
                displayText.toString(),
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: color),
              )),
              Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
              Expanded(
                  child: Container(
                height: 3,
                color: color,
              ))
            ],
          ));
    }

    Widget _printNumberPicker() {
      setNumberPicker();
      return Container(
          decoration: leftScaleDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 100,
                  decoration: leftScaleDecoration,
                ),
              ),
              Container(child: _numberPicker),
              Expanded(
                  child: Container(
                height: 100,
                decoration: rightScaleDecoration,
              ))
            ],
          ));
    }

/*
    _printLoadNextRollAlert() {
      return (_currentIntValue.toInt() != _rollSize)
          ? Container(
              padding: EdgeInsets.all(10),
              height: 50,
              width: 0,
            )
          : Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 50.0,
              child: (_tempStock <= 0 && _tempStockUnits <= 0)
                  ? Text(
                      "no stock available",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  : new MaterialButton(
                      height: 50.0,
                      minWidth: 300.0,
                      color: Colors.amber[700],
                      textColor: Colors.white,
                      child: new Text("Load Next Roll"),
                      onPressed: () {
                        setState(() {
                          _tempRollOverTickets = _tempTotalTickets;
                          _min = 0;
                          _currentIntValue = _min;
                          setNumberPicker();
                        });
                      },
                      splashColor: Colors.redAccent,
                    ),
            );
    }
*/
    _printProduct() {
      return Container(
          alignment: Alignment.center,
          padding: new EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Text(
              "\$" + _product.price.toString() + " | " + _product.gameName,
              style: TextStyle(
                  color: colorClosingTab,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)));
    }

    _printInfoPanel() {
      String titleStock = "Stock";
      String valStock1 = (null != _inventory
          ? _inventory.currentStock.toString() + "."
          : "0.");
      String valStock2 =
          ((null != _inventory && null != _inventory.currentStockUnits)
              ? _inventory.currentStockUnits.toString()
              : "0");

      String titleClosing = "Current Closing";
      String valClosingStock1 = _tempSalesStock.toString() + ".";
      String valClosingStock2 = _tempSalesStockUnits.toString();

      String titleRemainingStock = "Remaining Stock";
      String valRemainingStock1 = _tempStock.toString() + ".";
      String valRemainingStock2 = _tempStockUnits.toString();

      return Container(
        padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _printColumnUtilWidget(
                titleStock, valStock1, valStock2, colorClosingTab),
            _printColumnUtilWidget(titleClosing, valClosingStock1,
                valClosingStock2, Color.fromRGBO(173, 92, 67, 1.0)),
            _printColumnUtilWidget(titleRemainingStock, valRemainingStock1,
                valRemainingStock2, Color.fromRGBO(173, 92, 67, 1.0)),
          ],
        ),
      );
    }

    _printCheckoutPanel() {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new MaterialButton(
              height: 50.0,
              minWidth: 200.0,
              color: Colors.green[300],
              textColor: Colors.white,
              child: new Text("Checkout"),
              onPressed: () {
                AppData().getDatabase().checkoutInventory(
                    AppData().getUser().emailId,
                    AppData().getCurrentStore(widget.bottomTab),
                    AppData()
                        .getCurrentStore(widget.bottomTab)
                        .getInventoryItem(_product.id),
                    _product.rollSize,
                    _product.price);
                Navigator.of(context).pop();
              },
              splashColor: Colors.redAccent,
            ),
            new FlatButton(
              child: new Text("cancel"),
              onPressed: () {
                _inventory.resetAllTempStock();
                Navigator.of(context).pop();
              },
            ),
          ]);
    }

    return Container(
        color: Colors.grey[100],
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _printProduct(),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                _printInfoPanel(),
                _printSelectedValPanel(),
                _printNumberPicker(),
                //_printLoadNextRollAlert(),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                Container(padding: EdgeInsets.all(10)),
                _printCheckoutPanel(),
              ],
            ),
          ],
        ));
  }
}

class MyNumberPicker extends StatefulWidget {
  final ValueChanged<num> onChanged;

  final int currentIntValue;
  final int minValue;
  final int maxValue;
  final int step;
  final int numOfItemsAround;
  final int scaleSize;
  MyNumberPicker(
      {Key key,
      this.currentIntValue,
      this.minValue,
      this.maxValue,
      this.scaleSize,
      this.step,
      this.numOfItemsAround,
      this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyNumberPickerState();
}

class _MyNumberPickerState extends State<MyNumberPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new NumberPicker.integer(
        initialValue: widget.currentIntValue,
        minValue: widget.minValue,
        maxValue: widget.maxValue,
        scaleSize: widget.scaleSize,
        step: widget.step,
        numOfItemsAround: widget.numOfItemsAround,
        onChanged: (value) => setState(() {
              widget.onChanged(value);
            }));
  }
}
