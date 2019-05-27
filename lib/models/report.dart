import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String _id; //docId
  String _storeId;
  double _sales = 0;
  DateTime _created;
  DateTime _updated;

  Report(_id, this._storeId, this._sales, this._created);

  String get id => this._id;
  String get storeId => this._storeId;
  double get sales => this._sales;
  DateTime get created => this._created;
  DateTime get updated => this._updated;

  void setId(id) => this._id = id;
  void setstoreId(storeId) => this._storeId = storeId;
  void setsales(sales) => this._sales = sales;
  void setCreated(created) => this._created = created;
  void setUpdated(updated) => this._updated = updated;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (this._id != null) {
      map['id'] = this._id;
    }
    map['storeId'] = this._storeId;
    map['sales'] = this._sales;
    if (null != this._created) map['created'] = this._created;
    if (null != this._updated) map['updated'] = this._updated;

    return map;
  }

  Report.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._storeId = map['storeId'];
    this._sales = map['sales'];

    Timestamp tempTime = (null != map['created']) ? map['created'] : null;
    this._created = null != tempTime ? tempTime.toDate() : null;

    tempTime = (null != map['updated']) ? map['updated'] : null;
    this._updated = null != tempTime ? tempTime.toDate() : null;
  }
}
