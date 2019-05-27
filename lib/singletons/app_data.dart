//purchase (prepare order-list) -> place order -> load and activate
//sale (employee)
//void product(resubmit to state)
import 'package:lott/firestore/auth.dart';
import 'package:lott/firestore/database.dart';
import 'package:lott/models/user.dart';
import 'package:lott/models/store.dart';
import 'package:lott/models/store_inventory.dart';
import 'package:lott/models/product.dart';
import 'package:lott/mixins/bottom_tabs_mixin.dart';

class AppData {
  static final AppData _singleton = new AppData._internal();
  static final BaseAuth _auth = new Auth();
  static final BaseFirestoreService _database = new FirebaseFirestoreService();
  static bool _reloadAppStores = true;
  static String _nextSplash;
  static Messages _messages;
  static TabItem _currentabItem;
  User _user;
  List<Store> _stores = new List<Store>();
  Map<String, Store> _currentStore =
      new Map<String, Store>(); //for each bottomTab
  Map<String, Product> _currentProduct = new Map<String, Product>();

  Auth getAuth() => _auth;
  FirebaseFirestoreService getDatabase() => _database;

  Map<String, dynamic> _productsByState = new Map<String,
      dynamic>(); //key: state and value Map <_products_by_state->docId, product>

  String _splashMessage;

  setCurrentabItem(val) => _currentabItem = val;
  TabItem getCurrentabItem() => _currentabItem;

  addProductsByState(key, List<Product> products) {
    _productsByState[key] = convertListToMapProducts(products);
  }

  resetAllProductsByState() {
    this._productsByState = new Map<String, dynamic>();
  }

  getProductsByState(key) => this._productsByState[key];

  convertListToMapProducts(List<Product> products) {
    Map<String, Product> mapProduct = new Map<String, Product>();
    products.forEach((p) => mapProduct[p.id] = p);
    return mapProduct;
  }

  factory AppData() {
    //_database.runSettings();
    return _singleton;
  }
  AppData._internal() {
    // initialization logic here
    setMessages();
  }

  setReloadAppStores(val) => _reloadAppStores = val;
  bool getReloadAppStores() => _reloadAppStores;

  setNextSplash(val) => _nextSplash = val;
  String getNextSplash() => _nextSplash;

  void setMessages() {
    final Map<String, String> messagesMap = {
      "homeAppBar": "Flutter Home",
      "login": "Flutter Login",
      "logout": "Logout",
      "tabReports": "Reports",
      "tabInventory": "Select Store",
      "purchaseInventory": "Products",
      "saveInventory": "Submit",
      "tabClosing": "Select Store",
      "dailyClosing": "Daily Closing",
      "tabAccounts": "Store",
      "editStore": "Edit Store",
      "addStore": "Add Store",
      "activateStore": "Activate Store",
      "listStore": "Stores",
      "settings": "Settings",
      "help": "Help & Feedback",
      "addProduct": "New Lottery",
      /*
      "/list_store_active": "Active Stores",
      "/list_store_inactive": "Inactive Stores",
      "/list_store_sales": "Daily Closing",
      "/list_store_purchase": "Load Products",
      "/list_store": "Stores"
      */
    };
    _messages = new Messages(messagesMap);
  }

  String getMessage(String key) => _messages.getMessage(key);

  getSplashMessage() => this._splashMessage;

  setSplashMessage(String msg) => this._splashMessage = msg;

  Product getCurrentProduct(key) {
    return this._currentProduct[key];
  }

  void setCurrentProduct(String key, Product product) {
    this._currentProduct[key] = product;
  }

  void resetCurrentProduct(String key) {
    this._currentProduct[key] = new Product();
  }

  void resetAllCurrentProduct() {
    this._currentProduct = new Map<String, Product>();
  }

  void setCurrentStore(String key, Store store) {
    this._currentStore[key] = store;
  }

  void resetAllCurrentStore() {
    this._currentStore = null;
    this._currentStore = new Map<String, Store>();
    resetAllCurrentProduct();
  }

  void resetCurrentStore(String key) {
    this._currentStore[key] = new Store();
  }

  Store getCurrentStore(String key) {
    if (null == this._currentStore[key]) resetCurrentStore(key);
    return this._currentStore[key];
  }

  void setUser(User user) {
    this._user = user;
  }

  void clearUserData() {
    _user = null;
    _stores = null;
    resetAllCurrentStore();
    resetAllProductsByState();
  }

  User getUser() => this._user;

  void setStores(stores) {
    this._stores = stores;
  }

  List<Store> getStores() => this._stores;
  List<Store> getInActiveStores() {
    return this
        ._stores
        .where((Store s) =>
            (!s.isDeleted && (s.isActivated == null || s.isActivated == false)))
        .toList();
  }

  List<Store> getActiveStores() {
    return this._stores.where((Store s) => s.isActivated).toList();
  }

  Store getStoreById(String id) {
    if (null != this._stores && this._stores.length > 0) {
      List<Store> stores = this._stores.where((Store s) => s.id == id).toList();
      if (null != stores && stores.length > 0) {
        return stores.elementAt(0);
      } else
        return null;
    } else
      return null;
  }
/*
  void setStoreInventory(String id, Map<String, StoreInventory> storeInventory) {
    int index = this._stores.indexWhere((Store s) => s.id == id);
    if (index >= 0) this._stores[index].setInventory(storeInventory);
  }

  void setStoreLastSales(String id, Map<String, Sales> sales) {
    int index = this._stores.indexWhere((Store s) => s.id == id);
    if (index >= 0) this._stores[index].setLastSales(sales);
  }
*/
  Map<String, StoreInventory> getStoreInventoryByStoreId(String storeId) {
    int index = this._stores.indexWhere((Store s) => s.id == storeId);
    if (index >= 0) return this._stores[index].inventory;
    return null;
  }
}

class Messages {
  Map<String, String> _messagesMap;

  Messages(this._messagesMap);

  String getMessage(String key) {
    String message;
    if (_messagesMap != null && _messagesMap.length > 0) {
      if (_messagesMap.containsKey(key)) {
        message = _messagesMap[key];
      }
    }
    if (message == null || message.isEmpty) return key;
    return message;
  }
}
