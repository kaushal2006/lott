import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String _id;
  String _number;
  String _name;
  num _price;
  String _state;
  bool _activeInd;
  num _rollSize;
  DateTime _created;
  DateTime _updated;
  DateTime _activated;
  DateTime _deactivated;
  String _createdBy;
  String _updatedBy;
  DateTime _onSaleDate;
  DateTime _endSaleDate;
  //String imageUrl;

  Product();

  String get id => this._id;
  String get gameNumber => this._number;
  String get gameName => this._name;
  num get price => this._price;
  String get state => this._state;
  bool get active => this._activeInd;
  num get rollSize => this._rollSize;
  DateTime get created => this._created;
  DateTime get updated => this._updated;
  DateTime get activated => this._activated;
  DateTime get deactivated => this._deactivated;
  String get createdBy => this._createdBy;
  String get updatedBy => this._updatedBy;
  DateTime get onSaleDate => this._onSaleDate;
  DateTime get endSaleDate => this._endSaleDate;

  void setId(id) => this._id = id;
  void setGameNumber(number) => this._number = number;
  void setGameName(name) => this._name = name;
  void setPrice(price) => this._price = price;
  void setState(state) => this._state = state;
  void setActive(activeInd) => this._activeInd = activeInd;
  void setRollSize(rollSize) => this._rollSize = rollSize;

  void setCreated(created) => this._created = created;
  void setUpdated(updated) => this._updated = updated;
  void setActivated(activated) => this._activated = activated;
  void setDeactivated(deactivated) => this._deactivated = deactivated;
  void setCreatedBy(createdBy) => this._createdBy = createdBy;
  void setUpdatedBy(updatedBy) => this._updatedBy = updatedBy;
  void setOnSaleDate(onSaleDate) => this._onSaleDate = onSaleDate;
  void setEndSaleDate(endSaleDate) => this._endSaleDate = endSaleDate;

  Map<String, dynamic> toMapAddProduct() {
    var map = new Map<String, dynamic>();
    if (this._id != null) {
      map['id'] = this._id;
    }
    map['gameNumber'] = this._number;
    map['gameName'] = this._name;
    map['price'] = this._price;
    map['state'] = this._state;
    map['active'] = this._activeInd;
    map['rollSize'] = this._rollSize;
    map['createdBy'] = this._createdBy;

    if (null != this._created) map['created'] = this._created;
    if (null != this._updated) map['updated'] = this._updated;
    if (null != this._activated) map['activated'] = this._activated;
    //if (null != this._deactivated) map['deactivated'] = this._deactivated;
    //map['updatedBy'] = this._updatedBy;
    if (null != this._onSaleDate) map['onSaleDate'] = this._onSaleDate;
    if (null != this._endSaleDate) map['endSaleDate'] = this._endSaleDate;

    return map;
  }

  Product.fromMap(Map<dynamic, dynamic> map) {
    this._id = map['id'];
    this._number = map['gameNumber'];
    this._name = map['gameName'];
    this._price = map['price'];
    this._state = map['state'];
    this._activeInd = map['active'];
    this._rollSize = map['rollSize'];
    Timestamp tempTime = (null != map['created']) ? map['created'] : null;
    this._created = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['updated']) ? map['updated'] : null;
    this._updated = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['onSaleDate']) ? map['onSaleDate'] : null;
    this._onSaleDate = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['endSaleDate']) ? map['endSaleDate'] : null;
    this._endSaleDate = null != tempTime ? tempTime.toDate() : null;
  }

  Product.fromMap1(String id, Map<dynamic, dynamic> map) {
    this._id = id;
    this._number = map['gameNumber'];
    this._name = map['gameName'];
    this._price = map['price'];
    this._state = map['state'];
    this._activeInd = map['active'];
    this._rollSize = map['rollSize'];

    Timestamp tempTime = (null != map['created']) ? map['created'] : null;
    this._created = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['updated']) ? map['updated'] : null;
    this._updated = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['onSaleDate']) ? map['onSaleDate'] : null;
    this._onSaleDate = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['endSaleDate']) ? map['endSaleDate'] : null;
    this._endSaleDate = null != tempTime ? tempTime.toDate() : null;
  }
/*
  Product.map(dynamic obj) {
    this._id = obj['id'];
    this._number = obj['gameNumber'];
    this._name = obj['gameName'];
    this._price = obj['price'];
    this._state = obj['state'];
    this._activeInd = obj['active'];
    this._rollSize = obj['rollSize'];
  }*/
}
