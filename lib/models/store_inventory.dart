import 'package:cloud_firestore/cloud_firestore.dart';

class StoreInventory {
  String _id; //docId
  String _productId; //key:products_by_state->docId (this is the product)
  int _initialStock = 0;
  int _restockLevel;
  int _lowStockAlertLevel;
  int _currentStock = 0;
  int _currentStockUnits = 0;
  int _tempInventoryStock = 0; //use for inventory
  int _tempStock = 0; //use for checkout
  int _tempStockUnits = 0; //use for checkout
  int _tempSalesStock = 0; //use for checkout
  int _tempSalesStockUnits = 0; //use for checkout
  bool _active;
  bool _isNew = false;
  DateTime _created;
  DateTime _updated;

  StoreInventory(
      this._productId,
      this._initialStock,
      this._restockLevel,
      this._lowStockAlertLevel,
      this._currentStock,
      this._currentStockUnits,
      this._active,
      this._isNew);

  String get id => this._id;
  String get productId => this._productId;
  num get initialStock => this._initialStock;
  num get restockLevel => this._restockLevel;
  num get lowStockAlertLevel => this._lowStockAlertLevel;
  num get currentStock => this._currentStock;
  num get currentStockUnits => this._currentStockUnits;
  bool get active => this._active;
  bool get isNew => this._isNew;
  num get tempInventoryStock => this._tempInventoryStock;
  num get tempStock => this._tempStock;
  num get tempStockUnits => this._tempStockUnits;
  num get tempSalesStock => this._tempSalesStock;
  num get tempSalesStockUnits => this._tempSalesStockUnits;
  DateTime get created => this._created;
  DateTime get updated => this._updated;

  void setId(id) => this._id = id;
  void setProductId(productId) => this._productId = productId;
  void setInitialStock(initialStock) => this._initialStock = initialStock;
  void setRestockLevel(restockLevel) => this._restockLevel = restockLevel;
  void setIsNew(isNew) => this._isNew = isNew;
  void setTempInventoryStock(tempInventoryStock) =>
      this._tempInventoryStock = tempInventoryStock;
  void setTempStock(tempStock) => this._tempStock = tempStock;
  void setTempStockUnits(tempStockUnits) =>
      this._tempStockUnits = tempStockUnits;
  void setTempSalesStock(tempSalesStock) =>
      this._tempSalesStock = tempSalesStock;
  void setTempSalesStockUnits(tempSalesStockUnits) =>
      this._tempSalesStockUnits = tempSalesStockUnits;
  void setCreated(created) => this._created = created;
  void setUpdated(updated) => this._updated = updated;
  void setCurrentStock(currentStock) => this._currentStock = currentStock;
  void setCurrentStockUnits(currentStockUnits) =>
      this._currentStockUnits = currentStockUnits;

  void setLowStockAlertLevel(lowStockAlertLevel) =>
      this._lowStockAlertLevel = lowStockAlertLevel;

  void addInitialStock() => this._initialStock++;
  void removeInitialStock() =>
      (this._initialStock > 0) ? this._initialStock-- : 0;

  void addTempInventoryStock() => this._tempInventoryStock++;

  void removeTempInventoryStock() =>
      (this._tempInventoryStock > 0) ? this._tempInventoryStock-- : 0;

  void resetTempStock() {
    this._tempStock = 0;
    this._tempStockUnits = 0;
    /*
    this._tempSalesStock = 0;
    this._tempSalesStockUnits = 0;
    */
  }

  //purchase stock
  void addTempInvetoryToCurrentStock() {
    this._currentStock = this._currentStock + this._tempInventoryStock;
    this._tempInventoryStock = 0;
  }

  //checkout stock
  void setTempToCurrentStock() {
    this._currentStock = this.tempStock;
    this._currentStockUnits = this._tempStockUnits;
  }

  void resetTempInventoryStock() {
    this._tempInventoryStock = 0;
    //this._tempStockUnits = 0; **** check the role
  }

  void resetTempSalesStock() {
    this._tempSalesStock = 0;
    this._tempSalesStockUnits = 0;
  }

/*this is only for sales/checkout */
  void resetAllTempStock() {
    resetTempStock();
    resetTempSalesStock();
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (this._id != null) {
      map['id'] = this._id;
    }
    map['productId'] = this._productId;
    map['initialStock'] = this._initialStock;
    map['restockLevel'] = this._restockLevel;
    map['lowStockAlertLevel'] = this._lowStockAlertLevel;
    map['currentStock'] = this._currentStock;
    map['currentStockUnits'] = this._currentStockUnits;
    map['active'] = this._active;
    if (null != this._created) map['created'] = this._created;
    if (null != this._updated) map['updated'] = this._updated;

    return map;
  }

  Map<String, dynamic> toMapCurrentStock() {
    var map = new Map<String, dynamic>();
    map['currentStock'] = this._currentStock;
    map['updated'] = this._updated;

    return map;
  }

  Map<String, dynamic> toMapCurrentStockWithUnits() {
    var map = new Map<String, dynamic>();
    map['currentStock'] = this._currentStock;
    map['currentStockUnits'] = this._currentStockUnits;
    map['updated'] = this._updated;

    return map;
  }

  StoreInventory.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._productId = map['productId'];
    this._initialStock = map['initialStock'];
    this._restockLevel = map['restockLevel'];
    this._lowStockAlertLevel = map['lowStockAlertLevel'];
    this._currentStock = map['currentStock'];
    this._currentStockUnits =
        (null == map['currentStockUnits'] ? 0 : map['currentStockUnits']);
    this._active = map['active'];

    Timestamp tempTime = (null != map['created']) ? map['created'] : null;
    this._created = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['updated']) ? map['updated'] : null;
    this._updated = null != tempTime ? tempTime.toDate() : null;
  }
}
