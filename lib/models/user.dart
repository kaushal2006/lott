import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _userId;
  String _emailId;
  String _firstName;
  String _lastName;
  String _role;
  String _parentEmailId;
  bool _active;
  DateTime _created;
  DateTime _updated;

  User(
    this._emailId,
  );
  /*
  User(
    this._userId,
    this._emailId,
    this._firstName,
    this._lastName,
    this._role,
    this._parentEmailId,
    this._active,
  );
*/
  String get userId => this._userId;
  String get emailId => this._emailId;
  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get role => this._role;
  String get parentEmailId => this._parentEmailId;
  bool get active => this._active;
  DateTime get created => this._created;
  DateTime get updated => this._updated;

  void setFirstName(firstName) => this._firstName = firstName;
  void setLastName(lastName) => this._lastName = lastName;
  void setActive(active) => this._active = active;
  void setCreated(created) => this._created = created;
  void setUpdated(updated) => this._updated = updated;
  void setRole(role) => this._role = role;
  void setParentEmailId(parentEmailId) => this._parentEmailId = parentEmailId;

  User.map(dynamic obj) {
    this._userId = obj['userId'];
    this._emailId = obj['emailId'];
    this._firstName = obj['firstName'];
    this._lastName = obj['lastName'];
    this._role = obj['role'];
    this._parentEmailId = obj['parentEmailId'];
    this._active = obj['active'];
    Timestamp tempTime = (null != obj['created']) ? obj['created'] : null;
    this._created = (null != tempTime) ? tempTime.toDate() : null;
    tempTime = (null != obj['updated']) ? obj['updated'] : null;
    this._updated = (null != tempTime) ? tempTime.toDate() : null;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['userId'] = this._userId;
    map['emailId'] = this._emailId;
    map['firstName'] = this._firstName;
    map['lastName'] = this._lastName;
    map['role'] = this._role;
    map['parentEmailId'] = this._parentEmailId;
    map['active'] = this.active;
    if (null != this._created) map['created'] = this._created;
    if (null != this._updated) map['updated'] = this._updated;
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._userId = map['userId'];
    this._emailId = map['emailId'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._role = map['role'];
    this._parentEmailId = map['parentEmailId'];
    this._active = map['active'];
    this._created = map['created'];
    this._updated = map['updated'];
  }
}
