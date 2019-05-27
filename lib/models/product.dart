class Product {
  String _id;
  String _number;
  String _name;
  //String desc;
  //String category;
  num _price;
  String _state;
  bool _activeInd;
  num _rollSize;

  Product();
  //var onSaleDate; //= new DateTime.now();
  //var endSaleDate;// = new DateTime.now();
  //int units;//roll size
  //String imageUrl;
  //Product(this._productId, this._number, this._name, this._price, this._state, this._activeInd);

  String get id => this._id;
  String get gameNumber => this._number;
  String get gameName => this._name;
  num get price => this._price;
  String get state => this._state;
  bool get active => this._activeInd;
  num get rollSize => this._rollSize;

  Map<String, dynamic> toMap() {
    var map = new Map<dynamic, dynamic>();
    if (this._id != null) {
      map['id'] = this._id;
    }
    map['gameNumber'] = this._number;
    map['gameName'] = this._name;
    map['price'] = this._price;
    map['state'] = this._state;
    map['active'] = this._activeInd;
    map['rollSize'] = this._rollSize;

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
  }

  Product.fromMap1(String id, Map<dynamic, dynamic> map) {
    this._id = id;
    this._number = map['gameNumber'];
    this._name = map['gameName'];
    this._price = map['price'];
    this._state = map['state'];
    this._activeInd = map['active'];
    this._rollSize = map['rollSize'];
  }

  Product.map(dynamic obj) {
    this._id = obj['id'];
    this._number = obj['gameNumber'];
    this._name = obj['gameName'];
    this._price = obj['price'];
    this._state = obj['state'];
    this._activeInd = obj['active'];
    this._rollSize = obj['rollSize'];
  }
}
