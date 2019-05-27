// design tip
// https://stackoverflow.com/questions/50044618/how-to-increment-counter-for-a-specific-list-item-in-flutter
/*
import 'package:flutter/material.dart';
import 'package:lott/models/product.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/models/store_inventory.dart';
import 'package:lott/screens/_bottomsheet_widget.dart';

class ProductSalesScreen extends StatefulWidget {
  ProductSalesScreen({this.bottomTab});
  final String bottomTab;

  @override
  _ProductSalesScreenState createState() => _ProductSalesScreenState();
}

class _ProductSalesScreenState extends State<ProductSalesScreen>
    with AppUtilsMixin {
  Product _product;
  StoreInventory _inventory;

  var _fontColor;
  @override
  void initState() {
    _inventory = AppData()
        .getCurrentStore(widget.bottomTab)
        .getInventoryItem(AppData().getCurrentProduct(widget.bottomTab).id);

    _product = AppData().getCurrentProduct(widget.bottomTab);

    _fontColor = (null == _inventory || _inventory.initialStock == 0)
        ? Color.fromRGBO(10, 10, 10, 100)
        : Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    _printProduct() {
      return Container(
          alignment: Alignment.center,
          padding: new EdgeInsets.fromLTRB(0, 30, 0, 0),
          child:
              Text("\$" + _product.price.toString() + " | " + _product.gameName,
                  style: TextStyle(
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                    fontSize: 25,
                    //fontFamily: "Simplifica"
                  )));
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

      return Container(
        padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _printColumnUtilWidget(
                titleStock, valStock1, valStock2, Colors.white),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorClosingTab,
      body: Column(
        children: <Widget>[
          _printProduct(),
          _printInfoPanel(),
          Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new ProductSalesBottomSheet(
                      bottomTab: widget.bottomTab, product: _product),
                  //new ProductSalesSlider(bottomTab: widget.bottomTab, product: _product),
                ],
              )),
          new Row(
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
                    _inventory.resetTempStock();
                    Navigator.of(context).pop();
                  },
                ),
              ]),
        ],
      ),
    );
  }
}
*/