import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lott/models/product.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/common/route_list.dart';
import 'package:lott/models/store_inventory.dart';
import 'package:lott/screens/_counter_widget.dart';
import 'package:lott/models/store.dart';
import 'package:flutter/cupertino.dart';

class ProductPurchaseManagerScreen extends StatelessWidget with AppUtilsMixin {
  ProductPurchaseManagerScreen({this.bottomTab});
  final String bottomTab;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    onResetPage() {
      var mapInventory = AppData().getCurrentStore(this.bottomTab).inventory;

      if (AppData().getCurrentStore(this.bottomTab).id != null &&
          mapInventory.length > 0) {
        mapInventory.forEach((id, inventory) {
          if ((inventory.isNew && inventory.initialStock > 0) &&
              null == inventory.id) {
            AppData()
                .getCurrentStore(this.bottomTab)
                .resetInitialStock(inventory.productId);
          } else if (inventory.tempInventoryStock > 0 && inventory.id != null) {
            AppData()
                .getCurrentStore(this.bottomTab)
                .resetTempInvetoryStock(inventory.productId);
          }
        });

        Navigator.of(context).popAndPushNamed(ROUTE_PRODUCT_PURCHASE_MANAGER);
      }
    }

    void onSubmitInventory() async {
      if (AppData().getUser().emailId.isEmpty ||
          AppData().getCurrentStore(this.bottomTab).id == null ||
          AppData().getCurrentStore(this.bottomTab).inventory.length == 0)
        return;

      AppData()
          .getDatabase()
          .purchaseInventory(
              AppData().getUser().emailId,
              AppData().getCurrentStore(this.bottomTab).id,
              AppData().getCurrentStore(this.bottomTab).inventory)
          .whenComplete(() {
        Navigator.of(context).popAndPushNamed(ROUTE_PRODUCT_PURCHASE_MANAGER);
      });
    }

    Store s = AppData().getCurrentStore(bottomTab);
    return buildScaffoldWithCustomAppBarWithKey(
        Container(
            child: ProductPurchaseManager(
                bottomTab: this.bottomTab,
                onResetPage: onResetPage,
                onSubmitInventory: onSubmitInventory)),
        AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          //centerTitle: false,
          elevation: 0.0,
          backgroundColor: colorInventoryTab,
          title: buildStoreAppBar(AppData().getMessage("purchaseInventory"),
              s.avatar, s.name, false),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(ROUTE_ADD_PRODUCT);
              },
            )
          ],
        ),
        _scaffoldKey);
  }
}

class ProductPurchaseManager extends StatefulWidget {
  ProductPurchaseManager(
      {this.bottomTab, this.onResetPage, this.onSubmitInventory});
  final String bottomTab;
  final VoidCallback onResetPage;
  final VoidCallback onSubmitInventory;

  @override
  _ProductPurchaseManagerState createState() => _ProductPurchaseManagerState();
}

class _ProductPurchaseManagerState extends State<ProductPurchaseManager>
    with AppUtilsMixin {
  Map<String, Product> _products;
  StreamSubscription<QuerySnapshot> _productSub;
  StreamSubscription<QuerySnapshot> _inventorySub;
  Map<String, StoreInventory> _inventory;
  Map<String, Product> _currentInventory;
  bool _noInventory = false;
  bool _noProducts = false;
  Map<String, Product> _currentInventoryFiltered;
  //String _filterVal = "All";
  int _cupertinoSegnmentIndex = 0;

  @override
  void initState() {
    super.initState();
    _products = AppData()
        .getProductsByState(AppData().getCurrentStore(widget.bottomTab).state);

    Store currentStore = AppData().getCurrentStore(widget.bottomTab);
    if (currentStore == null) return;
    _products = AppData().getProductsByState(currentStore.state);
    _inventory = currentStore.inventory;

    //load products if empty
    if (null == _products || _products.isEmpty) {
      _productSub?.cancel();
      _productSub = AppData()
          .getDatabase()
          .getAllActiveProducts(currentStore.state)
          .listen((QuerySnapshot snapshot) {
        final List<Product> products = snapshot.documents
            .map((documentSnapshot) => Product.fromMap1(
                documentSnapshot.documentID, documentSnapshot.data))
            .toList();
        if (null == products || products.isEmpty) {
          setState(() {
            _noProducts = true;
          });
        }
        AppData().addProductsByState(
            AppData().getCurrentStore(widget.bottomTab).state, products);
        this._products = AppData().getProductsByState(currentStore.state);
        setStoreInventory();
      });
    }

    //load inventory if empty and product is not empty
    if (!_noProducts && null == _inventory || _inventory.isEmpty) {
      _inventorySub?.cancel();

      _inventorySub = AppData()
          .getDatabase()
          .getStoreInventory(AppData().getUser().emailId, currentStore.id)
          .listen((QuerySnapshot snapshot) {
        final List<StoreInventory> inventory = snapshot.documents
            .map((documentSnapshot) =>
                StoreInventory.fromMap(documentSnapshot.data))
            .toList();
        if (null == inventory || inventory.isEmpty) {
          setState(() {
            _noInventory = true;
          });
        }
        currentStore.toMapInventory(inventory);
        this._inventory = currentStore.inventory;
        AppData()
            .getStoreById(currentStore.id)
            .setInventory(currentStore.inventory);
        setStoreInventory();
      });
    }
    setStoreInventory();
  }

  setStoreInventory() {
    if (null != _products &&
        null != _inventory &&
        _products.isNotEmpty &&
        _inventory.isNotEmpty) {
      var currentInventory = new Map<String, Product>();

      this._inventory.forEach((id, i) {
        if (_products.containsKey(id)) {
          currentInventory[id] = _products[id];
        }
      });
      this._products.forEach((id, p) {
        if (!currentInventory.containsKey(id)) currentInventory[id] = p;
      });
      setState(() {
        _currentInventory = currentInventory;
        _currentInventoryFiltered = currentInventory;
      });
    }
    //case when user is loading inventory first time
    else if (null != _products && _products.isNotEmpty && _noInventory) {
      var currentInventory = new Map<String, Product>();

      this._products.forEach((id, p) {
        if (!currentInventory.containsKey(id)) currentInventory[id] = p;
      });
      setState(() {
        _currentInventory = currentInventory;
        _currentInventoryFiltered = currentInventory;
      });
    }
  }

  @override
  void dispose() {
    _productSub?.cancel();
    _inventorySub?.cancel();
    super.dispose();
  }

  final Map<int, Widget> cupertinoSengmentTabs = const <int, Widget>{
    0: Text('All'),
    1: Text('Low Stock'),
    2: Text('No Stock'),
  };

  ListTile makeListTile(Product product) {
    StoreInventory inventory = AppData()
        .getCurrentStore(widget.bottomTab)
        .getInventoryItem(product.id);

    bool zeroInventory = (null == inventory ||
            (inventory.currentStock == 0 && inventory.currentStockUnits == 0))
        ? true
        : false;

    var fontColor = zeroInventory
        ? Color.fromRGBO(213, 129, 102, 1.0)
        : Color.fromRGBO(10, 10, 10, 100); //black
    var backgroundColor = Colors.green[50];
    DateTime lastRecorded;
    if (!zeroInventory) {
      lastRecorded =
          (inventory.updated != null) ? inventory.updated : inventory.created;
    }
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      leading:
          buildProductListLeading(product.price, fontColor, backgroundColor),
      title: buildProductListTitle(
          product.gameName, product.gameNumber, fontColor),
      subtitle: buildProductListSubTitleWithICounter(
          product.rollSize,
          zeroInventory ? 0 : inventory.currentStock,
          zeroInventory ? 0 : inventory.currentStockUnits,
          zeroInventory,
          lastRecorded,
          fontColor,
          Container(
              alignment: Alignment.topRight,
              width: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ProductInventoryCounter(
                      bottomTab: widget.bottomTab, productId: product.id),
                ],
              ))),
      onTap: () {},
    );
  }

  listActiveInventory() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _currentInventoryFiltered.length,
      itemBuilder: (BuildContext context, int index) {
        String key = _currentInventoryFiltered.keys.elementAt(index);
        return Card(
          elevation: 0.0,
          //margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white24),
            child: makeListTile(_currentInventoryFiltered[key]),
          ),
        );
      },
    );
  }

  onClickCupertinoSegnment() {
    if (_cupertinoSegnmentIndex == 0) {
      setState(() {
        _currentInventoryFiltered = _currentInventory;
      });
      return;
    }
    if (_cupertinoSegnmentIndex == 1 || _cupertinoSegnmentIndex == 2) {
      var tempInventory = new Map<String, Product>();

      this._currentInventory.forEach((id, p) {
        StoreInventory inventory =
            AppData().getCurrentStore(widget.bottomTab).getInventoryItem(id);
        bool includeFlag = false;
        if (_cupertinoSegnmentIndex == 1) {
          includeFlag = (null != inventory &&
                  ((inventory.currentStock != 0 &&
                          inventory.currentStock <=
                              inventory.lowStockAlertLevel) ||
                      (inventory.currentStock == 0 &&
                          inventory.currentStockUnits > 0)))
              ? true
              : false;
        } else if (_cupertinoSegnmentIndex == 2) {
          includeFlag = (null == inventory ||
                  (inventory.currentStock == 0 &&
                      inventory.currentStockUnits == 0))
              ? true
              : false;
        }
        if (includeFlag) tempInventory[id] = p;
      });
      setState(() {
        _currentInventoryFiltered = tempInventory;
      });
      return;
    }
  }

/*
  filterInventory(String filterVal) {
    if (!isNumeric(filterVal)) return false;
    num price = int.tryParse(filterVal);
    var tempInventory = new Map<String, Product>();

    this._currentInventory.forEach((id, p) {
      if (p.price == price) tempInventory[id] = p;
    });

    setState(() {
      _filterVal = filterVal;
      _currentInventoryFiltered = tempInventory;
    });

    return false;
  }

  List<Container> listFilters() {
    return productInventoryFilters.map((i) {
      return Container(
          alignment: Alignment.center,
          //width: auto,
          color: Colors.grey[200],
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: new RaisedButton(
            padding: EdgeInsets.all(0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: _filterVal == i ? colorInventoryTab : Colors.white,
            shape: RoundedRectangleBorder(
                //borderRadius: new BorderRadius.all(Radius.zero),
                side: BorderSide(color: colorInventoryTab)),
            textColor: _filterVal == i
                ? Colors.white
                : Color.fromRGBO(10, 10, 10, 100),
            child: new Text(i),
            onPressed: () {
              filterInventory(i);
            },
            splashColor: Colors.redAccent,
          ));
    }).toList();

    /* return productFilters.map((i) {
      return Container(
          alignment: Alignment.center,
          width: 45,
          color: Colors.grey[200],
          padding: EdgeInsets.all(5),
          child: new MaterialButton(
            padding: EdgeInsets.all(0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: _filterVal == i ? colorInventoryTab : Colors.white,
            textColor: _filterVal == i
                ? Colors.white
                : Color.fromRGBO(10, 10, 10, 100),
            child: new Text(i),
            onPressed: () {
              filterInventory(i);
            },
            splashColor: Colors.redAccent,
          ));
    }).toList();*/
  }
*/
  onSubmitInventoryConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialogBox(
              Icons.shopping_cart,
              "Checkout Inventory",
              "Please Ok to continue, Cancel to stay on the inventory page.",
              <Widget>[
                MaterialButton(
                  height: 45.0,
                  minWidth: 100.0,
                  textColor: Colors.white,
                  color: Colors.green[300],
                  child: new Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onSubmitInventory();
                  },
                  splashColor: Colors.redAccent,
                ),
                new FlatButton(
                  textColor: Colors.grey,
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }

  Widget _showActionButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new MaterialButton(
            height: 45.0,
            minWidth: 200.0,
            textColor: Colors.white,
            color: Colors.green[300],
            child: new Text("Load Inventory"),
            onPressed: onSubmitInventoryConfirmationDialog,
            splashColor: Colors.redAccent,
          ),
          new MaterialButton(
            height: 45.0,
            minWidth: 100.0,
            color: Colors.grey[100],
            textColor: Color.fromRGBO(10, 10, 10, 100),
            child: new Text("Reset"),
            onPressed: widget.onResetPage,
            splashColor: Colors.redAccent,
          )
        ]);
  }

  listFiltersAndInventory() {
    return Column(
      children: <Widget>[
        Container(
            height: 45.0,
            child: Container(
              //alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 300.0,
                child: CupertinoSegmentedControl<int>(
                  selectedColor: colorInventoryTab,
                  borderColor: colorInventoryTab,
                  children: cupertinoSengmentTabs,
                  onValueChanged: (int val) {
                    setState(() {
                      _cupertinoSegnmentIndex = val;
                    });
                    onClickCupertinoSegnment();
                  },
                  groupValue: _cupertinoSegnmentIndex,
                ),
              ),
            )),
        Expanded(
          child: listActiveInventory(),
        ),
        Container(
            height: 45, padding: EdgeInsets.all(5), child: _showActionButton())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_noProducts)
      return Center(
          child: buildInfoMessage(
              "This App is available for State " +
                  getStateFullName(
                      AppData().getCurrentStore(widget.bottomTab).state),
              "Please tap on Setting Tab to report this issue."));
    else if (null == _currentInventoryFiltered)
      return new Center(child: Text('LOADING...'));
    else
      return Container(
          color: Colors.grey[200], child: listFiltersAndInventory());
  }
}
