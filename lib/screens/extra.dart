/*
actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: new OutlineButton(
                    //color: Colors.green[500],
                    splashColor: Colors.green[500],
                    child: Text(AppData().getMessage("saveInventory"),
                        style: TextStyle(fontSize: 17.0, color: Colors.white)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    // onPressed: () ,
                  ))
            ]
            
//rounded box
new Container(
              alignment: Alignment.center,
              child: new Text(
                  "\$" + "3" + " | " + " Million Cash",
                  style: TextStyle(color: Colors.white)),
              height: 50,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                color: Colors.blueGrey,
              ))

              // user defined function
  void _showSalesDialog(BuildContext context, Product product) {
    StoreInventory inventory =
        AppData().getCurrentStore().getInventoryItem(product.id);
    var fontColor = (null == inventory || inventory.initialStock == 0)
        ? Colors.grey
        : Colors.green[300];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Column(
            children: <Widget>[
              new Container(
                  //height: 150,
                  alignment: Alignment.center,
                  padding: new EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(5.0),
                    color: Colors.blueGrey[50],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                          "\$" +
                              product.price.toString() +
                              " | " +
                              product.gameName,
                          style: TextStyle(
                              color: Colors.green[300],
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      new Container(
                        padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Stock",
                                    style: TextStyle(
                                        color: fontColor, fontSize: 12)),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: <Widget>[
                                    Text(
                                      (null != inventory
                                          ? inventory.currentStock.toString() +
                                              "."
                                          : "0."),
                                      style: TextStyle(
                                        color: fontColor,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(
                                      ((null != inventory &&
                                              null !=
                                                  inventory.currentStockUnits)
                                          ? inventory.currentStockUnits
                                              .toString()
                                          : "0"),
                                      style: TextStyle(
                                        color: fontColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Roll Size",
                                    style: TextStyle(
                                        color: fontColor, fontSize: 12)),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: <Widget>[
                                    Text(
                                      product.rollSize.toString(),
                                      style: TextStyle(
                                        color: fontColor,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new ProductSalesSlider(product: product),
              ],
            ))
            ],
          ),
          actions: <Widget>[
            new MaterialButton(
              height: 40.0,
              minWidth: 120.0,
              color: Colors.green[300],
              textColor: Colors.white,
              child: new Text("Submit"),
              onPressed: () => {},
              splashColor: Colors.redAccent,
            ),
            new FlatButton(
              child: new Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

              */
