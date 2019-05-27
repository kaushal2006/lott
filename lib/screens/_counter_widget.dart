import 'package:flutter/material.dart';
import 'package:lott/models/store_inventory.dart';
import 'package:lott/singletons/app_data.dart';

class ProductInventoryCounter extends StatefulWidget {
  ProductInventoryCounter({this.bottomTab, this.productId});
  final String productId;
  final String bottomTab;

  @override
  State<StatefulWidget> createState() => _ProductInventoryCounterState();
}

class _ProductInventoryCounterState extends State<ProductInventoryCounter> {
  @override
  Widget build(BuildContext context) {
    StoreInventory inventory = AppData()
        .getCurrentStore(widget.bottomTab)
        .getInventoryItem(widget.productId);
    //if (null == inventory || inventory.initialStock == 0) {
    if (null == inventory) {
      inventory = new StoreInventory(
          widget.productId, //productId:
          0, //initialStock:
          8, //restockLevel:
          2, //lowStockAlertLevel:
          0, //currentStock:
          0, //currentStockUnits:
          true, //active
          true //isNew
          );
      AppData()
          .getCurrentStore(widget.bottomTab)
          .setInventoryItem(widget.productId, inventory);
    }

    var fontColor = (inventory.isNew)
        ? (inventory.initialStock > 0
            ? Color.fromRGBO(130, 147, 86, 1.0)
            : Colors.white)
        : (inventory.tempInventoryStock > 0
            ? Color.fromRGBO(130, 147, 86, 1.0)
            : Colors.grey[100]);

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      ((inventory.isNew && inventory.initialStock != 0) ||
              inventory.tempInventoryStock != 0)
          ? new IconButton(
              iconSize: 25,
              icon: new Icon(Icons.remove_circle,
                  color: Color.fromRGBO(213, 129, 102, 1.0)),
              onPressed: () => setState(
                    () => inventory.isNew
                        ? inventory.removeInitialStock()
                        : inventory.removeTempInventoryStock(),
                  ))
          : new Container(
              width: 25,
            ),
      new Text(
        inventory.isNew
            ? AppData()
                .getCurrentStore(widget.bottomTab)
                .getInitialStock(widget.productId)
                .toString()
            : AppData()
                .getCurrentStore(widget.bottomTab)
                .getTempInvetoryStock(widget.productId)
                .toString(),
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: fontColor),
      ),
      new IconButton(
          iconSize: 25,
          icon: new Icon(Icons.add_circle,
              color: Color.fromRGBO(130, 147, 86, 1.0)),
          onPressed: () => setState(() => inventory.isNew
              ? inventory.addInitialStock()
              : inventory.addTempInventoryStock()))
    ]);
  }
}
