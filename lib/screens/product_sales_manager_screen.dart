// design tip
// https://github.com/shubie/Beautiful-List-UI-and-detail-page
// https://stackoverflow.com/questions/50044618/how-to-increment-counter-for-a-specific-list-item-in-flutter
// https://grokonez.com/flutter/flutter-firestore-example-firebase-firestore-crud-operations-with-listview

import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lott/models/product.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/common/route_list.dart';
import 'package:lott/models/store_inventory.dart';
import 'package:lott/models/store.dart';
import 'package:lott/models/sales.dart';
import 'package:flutter/cupertino.dart';
import 'package:lott/screens/_bottomsheet_widget.dart';
import 'package:lott/3pi/custombottomsheet/my_bottomsheet.dart';

class ProductSalesManagerScreen extends StatelessWidget with AppUtilsMixin {
  ProductSalesManagerScreen({this.bottomTab});
  final String bottomTab;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    int _numOfItemsAround = 9;

    try {
      double mediaScreenWidth = MediaQuery.of(context).size.width;
      if (null != mediaScreenWidth) {
        _numOfItemsAround =
            (((mediaScreenWidth.floor() ~/ 50) - 1) ~/ 2).toInt();
        //  print(_numOfItemsAround.toInt());
      }
    } catch (e) {
      //fallback
      _numOfItemsAround = 3;
    }

    Store s = AppData().getCurrentStore(bottomTab);
    return buildScaffoldWithCustomAppBarWithKey(
        Container(
            child: ProductSalesManager(this.bottomTab, _numOfItemsAround)),
        AppBar(
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            backgroundColor: colorClosingTab,
            title: buildStoreAppBar(
                AppData().getMessage("dailyClosing"), s.avatar, s.name, false)),
        _scaffoldKey);
  }
}

class ProductSalesManager extends StatefulWidget {
  ProductSalesManager(this.bottomTab, this._numOfItemsAround);
  final String bottomTab;
  final int _numOfItemsAround;

  @override
  _ProductSalesManagerState createState() => _ProductSalesManagerState();
}

class _ProductSalesManagerState extends State<ProductSalesManager>
    with AppUtilsMixin {
  Map<String, Product> _products;
  StreamSubscription<QuerySnapshot> _productSub;
  StreamSubscription<QuerySnapshot> _inventorySub;
  StreamSubscription<QuerySnapshot> _lastSalesSub;
  Map<String, StoreInventory> _inventory;
  Map<String, Product> _currentInventory;
  Map<String, Sales> _lastSales;
  bool _noInventory = false;
  bool _noProducts = false;
  Map<String, Product> _currentInventoryFiltered;
  int _cupertinoSegnmentIndex = 1;

  customSortMap(Map<String, Product> originalMap) {
    final Map<String, Product> sorted = new SplayTreeMap.from(originalMap,
        (a, b) => originalMap[a].price.compareTo(originalMap[b].price));
    //print(sorted);
    return sorted;
  }

  @override
  void initState() {
    super.initState();
    _products = AppData()
        .getProductsByState(AppData().getCurrentStore(widget.bottomTab).state);
    Store currentStore = AppData().getCurrentStore(widget.bottomTab);
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

    //load last sales product is not empty
    if (!_noProducts) {
      _lastSalesSub?.cancel();
      _lastSalesSub = AppData()
          .getDatabase()
          .getStoreLastSales(AppData().getUser().emailId, currentStore.id)
          .listen((QuerySnapshot snapshot) {
        final List<Sales> lastSales = snapshot.documents
            .map((documentSnapshot) => Sales.fromMap(documentSnapshot.data))
            .toList();
        currentStore.toMapLastSales(lastSales);
        _lastSales = currentStore.lastSales;
        AppData()
            .getStoreById(currentStore.id)
            .setLastSales(currentStore.lastSales);
        onClickCupertinoSegnment();
      });
    }
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
        currentInventory = customSortMap(currentInventory);
        _currentInventory = currentInventory;
        //_currentInventoryFiltered = currentInventory; //check the impact
      });
    }

    //case when user is loading inventory first time
    else if (null != _products && _products.isNotEmpty && _noInventory) {
      var currentInventory = new Map<String, Product>();

      this._products.forEach((id, p) {
        if (!currentInventory.containsKey(id)) currentInventory[id] = p;
      });
      setState(() {
        currentInventory = customSortMap(currentInventory);
        _currentInventory = currentInventory;
        _cupertinoSegnmentIndex = 0;
        _currentInventoryFiltered = currentInventory;
      });
    }
  }

  @override
  void dispose() {
    _productSub?.cancel();
    _inventorySub?.cancel();
    _lastSalesSub?.cancel();
    super.dispose();
  }

  final Map<int, Widget> cupertinoSengmentTabs = const <int, Widget>{
    0: Text('All'),
    1: Text('Pending'),
    2: Text('Completed'),
  };

  onTapModalBottomSheet(inventory, product) {
    if (null == inventory) return false;
    if (null == product) return false;
    AppData().setCurrentProduct(widget.bottomTab, new Product());
    if (null != inventory) {
      if ((null != inventory.currentStock && inventory.currentStock > 0) ||
          (null != inventory.currentStockUnits &&
              inventory.currentStockUnits > 0)) {
        AppData().setCurrentProduct(widget.bottomTab, product);
        myShowModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return GestureDetector(
                child: ProductSalesBottomSheet(
                    bottomTab: widget.bottomTab,
                    product: product,
                    numOfItemsAround: widget._numOfItemsAround),
                onTap: () {
                  //Navigator.pop(context);
                },
              );
            });

        /*    showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.5,
                maxChildSize: 1,
                minChildSize: 0.25,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    color: Colors.white,
                    child: Text(inventory)
                  );
                },
              );
            },
          );*/
      }
    }
  }

  onTapLoadProductSales(inventory, product) {
    if (null == inventory) return;
    AppData().setCurrentProduct(widget.bottomTab, new Product());
    inventory.resetTempStock();
    if (null != inventory) {
      if ((null != inventory.currentStock && inventory.currentStock > 0) ||
          (null != inventory.currentStockUnits &&
              inventory.currentStockUnits > 0)) {
        AppData().setCurrentProduct(widget.bottomTab, product);
        Navigator.of(context).pushNamed(ROUTE_PRODUCT_SALES);
      }
    } else {
      new AlertDialog(
        content: Text("No Stock"),
      );
    }
  }

  ListTile makeListTile(Product product) {
    StoreInventory inventory = AppData()
        .getCurrentStore(widget.bottomTab)
        .getInventoryItem(product.id);

    DateTime lastProductClosing;
    if (null != _lastSales) {
      Sales lastSales;
      if (_lastSales.containsKey(product.id))
        lastSales = _lastSales[product.id];
      lastProductClosing = null != lastSales ? lastSales.created : null;
    }

    //AppData().getCurrentStore(widget.bottomTab).getLastSalesItem(product.id);
    //DateTime lastProductClosing = null != lastSales ? lastSales.created : null;

    bool zeroInventory = (null == inventory ||
            (inventory.currentStock == 0 && inventory.currentStockUnits == 0))
        ? true
        : false;

    var fontColor = zeroInventory
        ? Color.fromRGBO(213, 129, 102, 1.0)
        : Color.fromRGBO(10, 10, 10, 100); //black
    var backgroundColor = Colors.blue[50];
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        leading:
            buildProductListLeading(product.price, fontColor, backgroundColor),
        title: buildProductListTitle(
            product.gameName, product.gameNumber, fontColor),
        subtitle: buildProductListSubTitleSales(
            product.rollSize,
            zeroInventory ? 0 : inventory.currentStock,
            zeroInventory ? 0 : inventory.currentStockUnits,
            zeroInventory,
            lastProductClosing,
            fontColor),
        trailing: Icon(Icons.keyboard_arrow_right, size: 30.0),
        onTap: () {
          //onTapLoadProductSales(inventory, product);alternative
          if(null == inventory)
            return;
          inventory.resetAllTempStock();
          onTapModalBottomSheet(inventory, product);
        });
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
    if (null == this._currentInventory) return;

    if (_cupertinoSegnmentIndex == 0) {
      setState(() {
        _currentInventoryFiltered = _currentInventory;
      });
      return;
    }
    if (_cupertinoSegnmentIndex == 1 || _cupertinoSegnmentIndex == 2) {
      if (null == _lastSales) {
        setState(() {
          if (_cupertinoSegnmentIndex == 2)
            _currentInventoryFiltered = new Map<String, Product>();
          else
            _currentInventoryFiltered = _currentInventory;
        });
        return;
      }

      var tempInventory = new Map<String, Product>();

      DateTime now = DateTime.now();
      DateTime today = new DateTime(now.year, now.month, now.day);

      this._currentInventory.forEach((id, p) {
        bool includeFlag = false;
        Sales lastSales;
        if (_lastSales.containsKey(p.id)) lastSales = _lastSales[p.id];
        if (null != lastSales && null != lastSales.created) {
          if (lastSales.created.compareTo(today) >= 0) {
            includeFlag = true;
          }
        }

        if (includeFlag && _cupertinoSegnmentIndex == 2) {
          tempInventory[id] = p;
        }
        if (includeFlag == false && _cupertinoSegnmentIndex == 1) {
          StoreInventory inventory = AppData()
              .getCurrentStore(widget.bottomTab)
              .getInventoryItem(p.id);
          if (null != inventory &&
              (inventory.currentStock > 0 || inventory.currentStockUnits > 0))
            tempInventory[id] = p;
        }
      });
      setState(() {
        _currentInventoryFiltered = tempInventory;
      });
      return;
    }
  }

  listFiltersAndInventory() {
    return Column(
      children: <Widget>[
        Container(
            height: 45.0,
            //color: Colors.white,
            child: Container(
              child: SizedBox(
                width: 300.0,
                child: CupertinoSegmentedControl<int>(
                  selectedColor: colorClosingTab,
                  borderColor: colorClosingTab,
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
