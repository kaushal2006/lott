import 'package:cloud_firestore/cloud_firestore.dart';

class Sales {
  String _id; //docId
  String _productId; //key:products_by_state->docId (this is the product)
  int _quantity;
  int _subQuantity;
  DateTime _created;
  bool _active = true;
  Sales(this._productId, this._quantity, this._subQuantity, this._created);

  String get id => this._id;
  String get productId => this._productId;
  num get quantity => this._quantity;
  num get subQuantity => this._subQuantity;
  DateTime get created => this._created;
  bool get active => this._active;

  void setId(id) => this._id = id;
  void setProductId(productId) => this._productId = productId;
  void setQuantity(quantity) => this._quantity = quantity;
  void setSubQuantity(subQuantity) => this._subQuantity = subQuantity;
  void setCreated(created) => this._created = created;
  void setActive(active) => this._active = active;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (this._id != null) {
      map['id'] = this._id;
    }
    map['productId'] = this._productId;
    map['quantity'] = this._quantity;
    map['subQuantity'] = this._subQuantity;
    if (null != this._created) map['created'] = this._created;
    map['active'] = this._active;

    return map;
  }

  Sales.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._productId = map['productId'];
    this._quantity = map['quantity'];
    this._subQuantity = map['subquantity'];

    Timestamp tempTime = (null != map['created']) ? map['created'] : null;
    this._created = null != tempTime ? tempTime.toDate() : null;

    this._active = map['isActivated'];
  }
}
