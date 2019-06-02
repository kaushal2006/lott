import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lott/models/store.dart';
import 'package:lott/models/user.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/models/store_inventory.dart';
import 'package:lott/models/purchase.dart';
import 'package:lott/models/sales.dart';
import 'package:lott/models/product.dart';

//caching
//https://stackoverflow.com/questions/53459669/so-what-is-the-simplest-approach-for-caching-in-flutter
//https://grokonez.com/flutter/flutter-firestore-example-firebase-firestore-crud-operations-with-listview
abstract class BaseFirestoreService {
  //Stream<QuerySnapshot> getFirestoreStream(String collection, int offset, int limit);
  Stream<QuerySnapshot> getAllActiveProducts(String state);
  Future<void> runSettings();
  //Future<dynamic> activateStore(String emailId, Store store);
}

class FirebaseFirestoreService implements BaseFirestoreService {
  static Firestore _firebaseDb = Firestore.instance;

  Future<void> runSettings() async {
    await _firebaseDb.settings(timestampsInSnapshotsEnabled: true);
  }

  static CollectionReference productsCollection =
      _firebaseDb.collection('products');

  /* static CollectionReference productsByStateCollection =
      _firebaseDb.collection('products_by_state');
      */
  static CollectionReference storesCollection =
      _firebaseDb.collection('stores');
  //static CollectionReference usersCollection = _firebaseDb.collection('users');
  static CollectionReference lastSaleCollection =
      _firebaseDb.collection('last_sales');

  Future<void> addFirebaseUser(User user) async {
    user.setRole("Owner");
    user.setParentEmailId("");
    user.setLastName(user.firstName);
    user.setCreated(new DateTime.now());
    user.setUpdated(new DateTime.now());
    user.setActive(true);
    final Map<String, dynamic> mapData = user.toMap();
    _firebaseDb.runTransaction((Transaction tx) async {
      await _firebaseDb
          .collection("users")
          .document(user.emailId)
          .setData(mapData, merge: true);
      AppData().setUser(user);
      return mapData;
    }).catchError((onError) {
      print('1. catchError(): ${onError == 'ERROR'}');
    });
  }

  Future<String> getFirebaseUser(String emailId) async {
    var map = await _firebaseDb.collection('users').document(emailId).get();
    if (map.exists && null != map.data) {
      AppData().setUser(User.map(map.data));
      return emailId;
    } else if (!map.exists) {
      AppData().getDatabase().addFirebaseUser(AppData().getUser());
      return emailId;
    }
    return null;
  }

  Stream<QuerySnapshot> getAllActiveProducts(String state) {
    Stream<QuerySnapshot> snapshots = productsCollection
        .document("state")
        .collection(state)
        .where("active", isEqualTo: true)
        .orderBy("price")
        .orderBy("gameName")
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getStoreInventory(String emailId, String storeId) {
    Stream<QuerySnapshot> snapshots = _firebaseDb
        .collection("store_inventory")
        .document(emailId)
        .collection(storeId)
        .where("active", isEqualTo: true)
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getStoreLastSales(String emailId, String storeId) {
    Stream<QuerySnapshot> snapshots = lastSaleCollection
        .document(emailId)
        .collection(storeId)
        .where("active", isEqualTo: true)
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getStores(String emailId) {
    Stream<QuerySnapshot> snapshots = _firebaseDb
        .collection("stores")
        .document(emailId)
        .collection("user_stores")
        .where("isDeleted", isEqualTo: false)
        //.orderBy("price")
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getDailySalesReport(String emailId, String storeId) {
    DateTime now = new DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    print(today);
    Stream<QuerySnapshot> snapshots = _firebaseDb
        .collection("sales")
        .document(emailId)
        .collection(storeId)
        .where("created", isGreaterThanOrEqualTo: today)
        .orderBy("productId")
        .snapshots();
    return snapshots;
  }

  Future<dynamic> deleteStore(String bottomTab, String emailId, Store s) async {
    String docId = s.id;
    if (null != docId) {
      _firebaseDb.runTransaction((Transaction tx) async {
        s.setUpdated(DateTime.now());
        s.setIsDeleted(true);
        final Map<String, dynamic> mapData = s.toMapDeleteStore();
        await _firebaseDb
            .collection("stores")
            .document(emailId)
            .collection("user_stores")
            .document(docId)
            .setData(mapData, merge: true);
        return mapData;
      }).catchError((onError) {
        print('1. catchError(): ${onError == 'ERROR'}');
      });
    }
  }

  Future<dynamic> deactivateOrActivateStore(
      String bottomTab, String emailId, Store s) async {
    String docId = s.id;
    if (null != docId) {
      _firebaseDb.runTransaction((Transaction tx) async {
        s.setUpdated(DateTime.now());

        if (s.isActivated) {
          s.setIsActivated(false);
          s.setDeactivated(new DateTime.now());
        } else {
          s.setIsActivated(true);
          s.setActivated(new DateTime.now());
        }
        final Map<String, dynamic> mapData =
            s.isActivated ? s.toMapDeactivateStore() : s.toMapActivateStore();
        await _firebaseDb
            .collection("stores")
            .document(emailId)
            .collection("user_stores")
            .document(docId)
            .setData(mapData, merge: true);
        return mapData;
      }).catchError((onError) {
        print('1. catchError(): ${onError == 'ERROR'}');
      });
    }
  }

  Future<dynamic> editStore(String bottomTab, String emailId, Store s) async {
    String docId = s.id;
    if (null != docId) {
      _firebaseDb.runTransaction((Transaction tx) async {
        s.setUpdated(DateTime.now());
        final Map<String, dynamic> mapData = s.toMapEdit();
        await _firebaseDb
            .collection("stores")
            .document(emailId)
            .collection("user_stores")
            .document(docId)
            .setData(mapData, merge: true);
        return mapData;
      }).catchError((onError) {
        print('1. catchError(): ${onError == 'ERROR'}');
      });
    }
  }

//stores/kaushal312@gmail.com/0/0
  Future<dynamic> addStore(String bottomTab, String emailId, Store s) async {
    String docId = s.id;
    if (null == docId) {
      docId = _firebaseDb
          .collection("stores")
          .document(emailId)
          .collection("user_stores")
          .document()
          .documentID;
      AppData().getCurrentStore(bottomTab).setId(docId);
      s.setId(docId);
    }
    AppData().getDatabase().initialUserStoreSetup(docId, emailId, s);
  }

  Future<void> initialUserStoreSetup(
      String docId, String emailId, Store s) async {
    _firebaseDb.runTransaction((Transaction tx) async {
      (null == s.created)
          ? s.setCreated(DateTime.now())
          : s.setUpdated(DateTime.now());
      s.setIsActivated(true);
      s.setActivated(DateTime.now());
      final Map<String, dynamic> mapData = s.toMapAddStore();
      await _firebaseDb
          .collection("stores")
          .document(emailId)
          .collection("user_stores")
          .document(docId)
          .setData(mapData, merge: true);
      return mapData;
    }).catchError((onError) {
      print('1. catchError(): ${onError == 'ERROR'}');
    });
  }

  Future<dynamic> purchaseInventory(String emailId, String storeId,
      Map<String, StoreInventory> mapInventory) async {
    if (emailId.isEmpty || storeId == null || mapInventory.isEmpty) return;
    WriteBatch batch = _firebaseDb.batch();
    mapInventory.forEach((id, inventory) {
      if ((inventory.isNew && inventory.initialStock > 0) &&
          null == inventory.id) {
        inventory.setCurrentStock(
            inventory.initialStock); //set current stock as initial stock
        DocumentReference dr = _firebaseDb
            .collection("store_inventory")
            .document(emailId)
            .collection(storeId)
            .document();
        inventory.setId(dr.documentID);
        inventory.setCreated(new DateTime.now());
        inventory.setUpdated(new DateTime.now());
        batch.setData(dr, inventory.toMap(), merge: true);
      } else if (inventory.tempInventoryStock > 0 && inventory.id != null) {
        Purchase p = new Purchase(
            id, inventory.tempInventoryStock, 0, new DateTime.now());

        DocumentReference dr = _firebaseDb
            .collection("store_inventory")
            .document(emailId)
            .collection(storeId)
            .document(inventory.id);
        inventory.addTempInvetoryToCurrentStock();
        inventory.setUpdated(new DateTime.now());

        DocumentReference dr2 = _firebaseDb
            .collection("purchase")
            .document(emailId)
            .collection(storeId)
            .document();

        batch.setData(dr, inventory.toMapCurrentStock(), merge: true);
        batch.setData(dr2, p.toMap());
      }
    });

    await batch.commit().then((result) {
      print('purchaseInventory Success');
      //AppData().resetCurrentStore();
    }).catchError((onError) {
      print('purchaseInventory catchError(): ${onError == 'ERROR'}');
    }).whenComplete(() {
      //AppData().resetCurrentStore();
    });
  }

  Future<dynamic> checkoutInventory(String emailId, Store store,
      StoreInventory inventory, num rollSize, num price) async {
    /* 
        print(inventory.tempStock.toString() + ".");
        print(inventory.tempStockUnits.toString());
        print(storeId);
        print(inventory.productId);
        */
    num daySales = 0;
    try {
      daySales = (inventory.tempSalesStock * rollSize * price) +
          (inventory.tempSalesStockUnits * price);
    } catch (e) {
      daySales = 0;
      print(e);
    }
    if (daySales == 0) return;

    WriteBatch batch = _firebaseDb.batch();

    DocumentReference drSI = _firebaseDb
        .collection("store_inventory")
        .document(emailId)
        .collection(store.id)
        .document(inventory.id);

    DocumentReference drSales = _firebaseDb
        .collection("sales")
        .document(emailId)
        .collection(store.id)
        .document();

    Sales sales = new Sales(inventory.productId, inventory.tempSalesStock,
        inventory.tempSalesStockUnits, new DateTime.now());
    sales.setId(drSales.documentID);

    inventory.setTempToCurrentStock();
    inventory.resetAllTempStock();
    inventory.setUpdated(new DateTime.now());

    DocumentReference drLastSales = lastSaleCollection
        .document(emailId)
        .collection(store.id)
        .document(inventory.productId);

    if (daySales > 0) {
      DocumentReference drStores = _firebaseDb
          .collection("stores")
          .document(emailId)
          .collection("user_stores")
          .document(store.id);

      batch.setData(drStores, store.toMapDailySales(daySales), merge: true);
    }
    batch.setData(drSI, inventory.toMapCurrentStockWithUnits(), merge: true);
    batch.setData(drSales, sales.toMap());
    batch.setData(drLastSales, sales.toMap());

    await batch.commit().then((result) {
      print('checkoutInventory Success' + drSales.path);
    }).catchError((onError) {
      print('checkoutInventory catchError(): ${onError == 'ERROR'}');
    }).whenComplete(() {});
  }

  Future<void> addProduct(Product p) async {
    _firebaseDb.runTransaction((Transaction tx) async {
      final Map<String, dynamic> mapData = p.toMapAddProduct();
      await productsCollection
          .document("state")
          .collection(p.state)
          .document()
          .setData(mapData, merge: true);
      return mapData;
    }).catchError((onError) {
      print('1. catchError(): ${onError == 'ERROR'}');
    });
  }

  Future<bool> addProductWithCaution(Product p) async {
    //check if product exist
    final QuerySnapshot result = await productsCollection
        .document("state")
        .collection(p.state)
        .where('gameNumber', isEqualTo: p.gameNumber)
        .limit(1)
        .getDocuments();
    if (null != result) {
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length > 0) return false;
      addProduct(p);
      return true;
    }
    if (null == result) {
      return false;
    }
  }
}
/*
Future<dynamic> activateStore(String bottomTab, String emailId,
      String storeId, Map<String, StoreInventory> mapInventory) async {
    WriteBatch batch = _firebaseDb.batch();
    bool flag = false;
    mapInventory.forEach((id, inventory) {
      if (inventory.isNew && inventory.initialStock > 0) {
        inventory.setCurrentStock(
            inventory.initialStock); //set current stock as initial stock
        DocumentReference dr = _firebaseDb
            .collection("store_inventory")
            .document(emailId)
            .collection(storeId)
            .document();
        inventory.setId(dr.documentID);
        inventory.setCreated(new DateTime.now());
        batch.setData(dr, inventory.toMap(), merge: true);
        flag = true;
      }
    });
    if (flag) {
      DocumentReference dr2 = _firebaseDb
          .collection("stores")
          .document(emailId)
          .collection("user_stores")
          .document(storeId);

      Store s = new Store();
      s.setIsActivated(true);
      s.setActivated(new DateTime.now());
      batch.updateData(dr2, s.toMapActivateStore());

      await batch.commit().then((result) {
        print('activateStore Success' + dr2.path);
        AppData().resetCurrentStore(bottomTab);
      }).catchError((onError) {
        print('activateStore catchError(): ${onError == 'ERROR'}');
      });
    } else {
      print('activateStore zeroInventory');
    }
  }
  Future<dynamic> updateStore(String emailId, var dataMap) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firebaseDb.collection('users').document('test1'));

      dataMap = new Map<String, dynamic>();
      dataMap['title'] = "test1-update";
      dataMap['description'] = "test1--desc-update";

      await tx.update(ds.reference, dataMap);
      return {'updated': true};
    };

    return _firebaseDb
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Future<dynamic> deleteStore(String id) async {
    String id = 'test3';
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_firebaseDb.collection('users').document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return _firebaseDb
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
  */
