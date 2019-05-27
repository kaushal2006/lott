//import 'package:lott/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lott/models/store_inventory.dart';
import 'package:lott/models/sales.dart';

class Store {
  String _id; //docId
  String _avatar;
  String _name;
  String _state;
  //double balance;
  num _daySale = 0;
  Map<String, StoreInventory> _inventory =
      new Map<String, StoreInventory>(); //key: products_by_state->docId
  //Map<String, Product> _products = new Map<String, Product>(); //key:Store->docId
  Map<String, Sales> _lastSales =
      new Map<String, Sales>(); //key: products_by_state->docId

  bool _isActivated = false;
  bool _isDeleted = false;
  DateTime _created;
  DateTime _updated;
  DateTime _activated;
  DateTime _deactivated;
  DateTime _lastRecordedSale;

  bool _isNew = false;
  /*
  Map<String, Report> _reports =
      new Map<String, Report>(); //key: type of reports(daily,weekly,monthly)
*/
  Store();

  String get id => this._id;
  //num get storeId => this._storeId;
  String get avatar => this._avatar;
  String get name => this._name;
  String get state => this._state;
  num get daySale => this._daySale;
  num get dayGain => daySale == 0 ? 0 : (daySale * 5 / 100);
  Map<String, StoreInventory> get inventory => this._inventory;
  Map<String, Sales> get lastSales => this._lastSales;
  //Map<String, Product> get products => this._products;
  bool get isActivated => this._isActivated;
  bool get isDeleted => this._isDeleted;
  DateTime get created => this._created;
  DateTime get updated => this._updated;
  DateTime get lastRecordedSale => this._lastRecordedSale;
  DateTime get activated => this._activated;
  DateTime get deactivated => this._deactivated;

  bool get isNew => this._isNew;

  toListInventory() {
    if (null != this._inventory && this._inventory.length > 0) {
      List<StoreInventory> si = new List<StoreInventory>();
      this._inventory.forEach((id, i) => si.add(i));
      return si;
    }
    return null;
  }

  StoreInventory getInventoryItem(String productId) {
    if (null != this._inventory) {
      if (this._inventory.containsKey(productId)) {
        if (null != this._inventory[productId].id)
          this._inventory[productId].setIsNew(false);
        return this._inventory[productId];
      }
    }
    return null;
  }

  Sales getLastSalesItem(String productId) {
    if (null != this._lastSales) {
      if (this._lastSales.containsKey(productId)) {
        return this._lastSales[productId];
      }
    }
    return null;
  }

  void setId(id) => this._id = id;
  void setState(state) => this._state = state;
  void setAvatar(avatar) => this._avatar = avatar;
  void setName(name) => this._name = name;
  void setIsActivated(isActivated) => this._isActivated = isActivated;
  void setIsDeleted(isDeleted) => this._isDeleted = isDeleted;

  //void setProducts(products) => this._products = products;
  void setInventory(inventory) => this._inventory = inventory;
  void setLastSales(lastSales) => this._lastSales = lastSales;
  void setCreated(created) => this._created = created;
  void setUpdated(updated) => this._updated = updated;
  void setLastRecordedSale(lastRecordedSale) =>
      this._lastRecordedSale = lastRecordedSale;
  void setActivated(activated) => this._activated = activated;
  void setDeactivated(deactivated) => this._deactivated = deactivated;

  void setIsNew(isNew) => this._isNew = isNew;

  setInventoryItem(String productId, StoreInventory value) =>
      this._inventory[productId] = value;

  setLastSalesItem(String productId, Sales value) =>
      this._lastSales[productId] = value;

  //purchase
  getInitialStock(String productId) => this._inventory[productId].initialStock;
  getTempInvetoryStock(String productId) =>
      this._inventory[productId].tempInventoryStock;
  resetTempInvetoryStock(String productId) =>
      this._inventory[productId].resetTempInventoryStock();

  //checkout
  setTempStock(String productId, num tempStock, num tempStockUnits,
      num tempSalesStock, num tempSalesStockUnits) {
    this._inventory[productId].setTempStock(tempStock);
    this._inventory[productId].setTempStockUnits(tempStockUnits);
    this._inventory[productId].setTempSalesStock(tempSalesStock);
    this._inventory[productId].setTempSalesStockUnits(tempSalesStockUnits);
  }

  toMapInventory(List<StoreInventory> inventory) {
    this._inventory = new Map<String, StoreInventory>();
    inventory.forEach((i) => this._inventory[i.productId] = i);
  }

  toMapLastSales(List<Sales> lastSales) {
    this._lastSales = new Map<String, Sales>();
    lastSales.forEach((i) => this._lastSales[i.productId] = i);
  }

  void setInitialStock(String productId, int initialStock) =>
      this._inventory[productId].setInitialStock(initialStock);

  void resetInitialStock(String productId) =>
      this._inventory[productId].setInitialStock(0);

  Store.map(dynamic obj) {
    this._id = obj['id'];
    //this._storeId = obj['storeId'];
    this._avatar = obj['avatar'];
    this._name = obj['name'];
    this._state = obj['state'];
    this._daySale = obj['daySale'];
    //this._dayGain = obj['dayGain'];
    this._isActivated = obj['isActivated'];

    Timestamp tempTime = (null != obj['created']) ? obj['created'] : null;
    this._created = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != obj['updated']) ? obj['updated'] : null;
    this._updated = null != tempTime ? tempTime.toDate() : null;

    tempTime =
        (null != obj['lastRecordedSale']) ? obj['lastRecordedSale'] : null;
    this._lastRecordedSale = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != obj['activated']) ? obj['activated'] : null;
    this._activated = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != obj['deactivated']) ? obj['deactivated'] : null;
    this._activated = null != tempTime ? tempTime.toDate() : null;
  }

  Map<String, dynamic> toMapAddStore() {
    var map = new Map<String, dynamic>();
    if (this._id != null) {
      map['id'] = this._id;
    }
    //map['storeId'] = this._storeId;
    map['avatar'] = this._avatar;
    map['name'] = this._name;
    map['state'] = this._state;
    map['daySale'] = this._daySale;
    map['isActivated'] = this._isActivated;
    map['isDeleted'] = this._isDeleted;
    if (null != this._created) map['created'] = this._created;
    if (null != this._updated) map['updated'] = this._updated;
    if (null != this._lastRecordedSale)
      map['lastRecordedSale'] = this._lastRecordedSale;
    if (null != this._activated) map['activated'] = this._activated;
    if (null != this._deactivated) map['deactivated'] = this._deactivated;
    return map;
  }

  Map<String, dynamic> toMapEdit() {
    var map = new Map<String, dynamic>();

    map['avatar'] = this._avatar;
    map['name'] = this._name;
    map['updated'] = this._updated;
    return map;
  }

  Map<String, dynamic> toMapDeleteStore() {
    var map = new Map<String, dynamic>();
    map['isDeleted'] = this._isDeleted;
    map['deleted'] = new DateTime.now();
    return map;
  }

  Map<String, dynamic> toMapDeactivateStore() {
    var map = new Map<String, dynamic>();
    map['isActivated'] = this._isActivated;
    map['deactivated'] = this._deactivated;
    return map;
  }

  Map<String, dynamic> toMapActivateStore() {
    var map = new Map<String, dynamic>();
    map['isActivated'] = this._isActivated;
    map['activated'] = this._activated;
    return map;
  }

  Map<String, dynamic> toMapDailySales(num sale) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var map = new Map<String, dynamic>();
    //first time closing
    if (null == this._lastRecordedSale) {
      this._lastRecordedSale = date;
      this._daySale = sale;
      map['lastRecordedSale'] = date;
    }
    //_lastRecordedSale is equal to today or even greater due to different timezone
    //add sales in today's closing
    else if (this._lastRecordedSale.compareTo(date) >= 0) {
      this._daySale = this._daySale + sale;
    }
    //_lastRecordedSale is not today meaning new closing
    else {
      this._lastRecordedSale = date;
      this._daySale = sale;
      map['lastRecordedSale'] = date;
    }
    map['daySale'] = this._daySale;
    return map;
  }

  Store.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    //this._storeId = map['storeId'];
    this._avatar = map['avatar'];
    this._name = map['name'];
    this._state = map['state'];
    this._daySale = map['daySale'];
    //this._dayGain = map['dayGain'];
    this._isActivated = map['isActivated'];
    this._isDeleted = map['isDeleted'];

    Timestamp tempTime = (null != map['created']) ? map['created'] : null;
    this._created = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['updated']) ? map['updated'] : null;
    this._updated = null != tempTime ? tempTime.toDate() : null;

    tempTime =
        (null != map['lastRecordedSale']) ? map['lastRecordedSale'] : null;
    this._lastRecordedSale = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['activated']) ? map['activated'] : null;
    this._activated = null != tempTime ? tempTime.toDate() : null;
  }
}
