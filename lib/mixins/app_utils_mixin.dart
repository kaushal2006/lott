import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/common/route_list.dart';
import 'package:intl/intl.dart';
//import 'dart:convert';
//import 'package:crypto/crypto.dart';
//import "package:hex/hex.dart";

class AppUtilsMixin {
  static final String _emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static final String _passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})';

  static final String _passwordTempPattern = r'^(?=.{6,})';

  static final String _phonePattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';

  static final RegExp _emailRegex = new RegExp(_emailPattern);
  static final RegExp _passwordRegex = new RegExp(_passwordTempPattern);
  static final RegExp _phoneNoRegex = new RegExp(_phonePattern);

  final colorReportsTab = Color.fromRGBO(96, 74, 91, 1.0);
  final colorInventoryTab = Color.fromRGBO(130, 147, 86, 1.0);
  final colorClosingTab = Color.fromRGBO(16, 120, 149, 1.0);
  final colorAccountsTab = Color.fromRGBO(87, 122, 127, 1.0);
  final colorSettingsTab = Colors.grey[600];

  final List<String> productInventoryFilters = [
    'All',
    'Low Stock',
    'No Stock',
  ];

  /*final List<String> productFilters = [
    'All',
    'No Stk',
    'Low Stk',
    '1',
    '2',
    '3',
    '5',
    '10',
    '15',
    '20',
    '25',
    '30'
  ];
*/
  final List<num> productPrices = [
    1,
    2,
    3,
    //4,
    5,
    //6,
    //7,
    //8,
    //9,
    10,
    //11,
    15,
    20,
    //21,
    25,
    30
  ];

  final List<num> rollSizes = [
    5,
    10,
    12,
    15,
    20,
    24,
    25,
    30,
    50,
    60,
    100,
    150,
    300
  ];

  final List<String> allStates = <String>[
    "AK - Alaska",
    "AL - Alabama",
    "AR - Arkansas",
    "AS - American Samoa",
    "AZ - Arizona",
    "CA - California",
    "CO - Colorado",
    "CT - Connecticut",
    "DC - District of Columbia",
    "DE - Delaware",
    "FL - Florida",
    "GA - Georgia",
    "GU - Guam",
    "HI - Hawaii",
    "IA - Iowa",
    "ID - Idaho",
    "IL - Illinois",
    "IN - Indiana",
    "KS - Kansas",
    "KY - Kentucky",
    "LA - Louisiana",
    "MA - Massachusetts",
    "MD - Maryland",
    "ME - Maine",
    "MI - Michigan",
    "MN - Minnesota",
    "MO - Missouri",
    "MS - Mississippi",
    "MT - Montana",
    "NC - North Carolina",
    "ND - North Dakota",
    "NE - Nebraska",
    "NH - New Hampshire",
    "NJ - New Jersey",
    "NM - New Mexico",
    "NV - Nevada",
    "NY - New York",
    "OH - Ohio",
    "OK - Oklahoma",
    "OR - Oregon",
    "PA - Pennsylvania",
    "PR - Puerto Rico",
    "RI - Rhode Island",
    "SC - South Carolina",
    "SD - South Dakota",
    "TN - Tennessee",
    "TX - Texas",
    "UT - Utah",
    "VA - Virginia",
    "VI - Virgin Islands",
    "VT - Vermont",
    "WA - Washington",
    "WI - Wisconsin",
    "WV - West Virginia",
    "WY - Wyoming"
  ];

  List<String> getAllStates() {
    return allStates;
  }

  List<num> getProductPrices() {
    return productPrices;
  }

  List<num> getRollSizes() {
    return rollSizes;
  }

  String getStateFullName(String stateCode) {
    String stateFullName = "";
    if (stateCode != null && stateCode.isNotEmpty) {
      stateFullName = getAllStates().singleWhere(
          (val) => val.substring(0, 2).compareTo(stateCode) == 0,
          orElse: () => "");
    }
    return stateFullName;
  }

  bool isNumeric(String str) {
    if (str == null) return false;
    if (str.isEmpty) return false;
    var val;
    try {
      val = int.tryParse(str);
    } on FormatException {
      return false;
    }
    if (val == null) return false;
    return true;
  }

  String formatDate(DateTime date) {
    String formattedDate = "";
    if (date != null) {
      //var formatter = new DateFormat('MMM dd yyyy hh:MM');
      //lastRecordedFormatted = formatter.format(lastRecorded);
      formattedDate = new DateFormat.yMEd().add_jms().format(date);
    }
    return formattedDate;
  }

  String formatDateShort(DateTime date) {
    String formattedDate = "";
    if (date != null) {
      //var formatter = new DateFormat('MMM dd yyyy hh:MM');
      //lastRecordedFormatted = formatter.format(lastRecorded);
      formattedDate = new DateFormat.yMEd().format(date);
    }
    return formattedDate;
  }

  _onLogout(BuildContext context) {
    AppData().getAuth().signOut();
    Navigator.of(context).pushReplacementNamed(ROUTE_LOGIN);
    AppData().clearUserData();
  }

  Widget buildInfoMessage(String title, String content) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Padding(padding: const EdgeInsets.all(5)),
          Text(content, style: TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget widgetFormFieldNameWithIcon(dynamic icon, String title, String val) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Icon(icon, color: Colors.green, size: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
          ),
          Container(
              child: Row(
            children: <Widget>[
              new Text(title, style: TextStyle(color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
              ),
              new Text(val,
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))
            ],
          )),
        ]));
  }

// PRODUCT - ----------------
  Widget buildProductListLeading(
      num price, var fontColor, var backgroundColor) {
    return Container(
        width: 50,
        height: 50,
        //color: Colors.blueGrey,
        //padding: EdgeInsets.all(5),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            color: backgroundColor),
        child: Container(
          alignment: Alignment.center,
          child: new Text("\$" + price.toString(),
              style: new TextStyle(
                  fontSize: 25,
                  fontFamily: "Simplifica",
                  color: fontColor,
                  fontWeight: FontWeight.w900)),
        ));
  }

  Widget buildProductListTitle(
      String storeName, String gameNumber, var fontColor) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text((null == storeName) ? "" : storeName,
          style: TextStyle(color: fontColor)),
      Text(gameNumber, style: TextStyle(color: Colors.grey, fontSize: 9)),
    ]);
  }

  Widget buildProductListSubTitleWithICounter(
      num rollSize,
      num currentStock,
      num currentStockUnits,
      bool zeroInventory,
      DateTime lastRecorded,
      var fontColor,
      Widget counterWidget) {
    DateTime now = DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    var lastAddedfontColor = fontColor;
    if (null != lastRecorded) {
      if (lastRecorded.compareTo(today) >= 0) {
        lastAddedfontColor = Colors.green;
      }
    }
    String lastRecordedFormatted = formatDate(lastRecorded);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildProductListSubTitle(rollSize, currentStock, currentStockUnits,
                zeroInventory, fontColor),
            counterWidget
          ],
        ),
        (lastRecorded != null)
            ? Text("Last added on " + lastRecordedFormatted,
                style: TextStyle(fontSize: 10, color: lastAddedfontColor))
            : Container(
                height: 0,
                width: 0,
              )

        //Text("Last recored at Mar 10 2019 10:10 pm", style: TextStyle(fontSize: 10),)
      ],
    );
  }

  Widget buildProductListSubTitleSales(
      num rollSize,
      num currentStock,
      num currentStockUnits,
      bool zeroInventory,
      DateTime lastRecorded,
      var fontColor) {
    DateTime now = DateTime.now().subtract(new Duration(days: 1));
    DateTime today = new DateTime(now.year, now.month, now.day);
    var lastAddedfontColor = fontColor;
    if (null != lastRecorded) {
      if (lastRecorded.compareTo(today) >= 0) {
        lastAddedfontColor = Colors.green;
      }
    }
    String lastRecordedFormatted = formatDate(lastRecorded);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildProductListSubTitle(rollSize, currentStock, currentStockUnits,
                zeroInventory, fontColor)
          ],
        ),
        (lastRecorded != null)
            ? Text("Last closing on " + lastRecordedFormatted,
                style: TextStyle(fontSize: 10, color: lastAddedfontColor))
            : Container(
                height: 0,
                width: 0,
              )

        //Text("Last recored at Mar 10 2019 10:10 pm", style: TextStyle(fontSize: 10),)
      ],
    );
  }

  Widget buildProductListSubTitle(num rollSize, num currentStock,
      num currentStockUnits, bool zeroInventory, var fontColor) {
    return Row(children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Roll Size", style: TextStyle(color: fontColor, fontSize: 10)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                rollSize.toString(),
                style: TextStyle(
                  color: fontColor,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
      Container(
        width: 30,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Stock", style: TextStyle(color: fontColor, fontSize: 10)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                (zeroInventory ? "0." : currentStock.toString() + "."),
                style: TextStyle(
                  color: fontColor,
                  fontSize: 22,
                ),
              ),
              Text(
                (zeroInventory ? "0" : currentStockUnits.toString()),
                style: TextStyle(
                  color: fontColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

// STORE - ----------------
  Widget buildStoreListLeading(String avatar) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        image: new DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage((isNumeric(avatar) == false)
                ? 'assets/storeavatars/no_image_icon.png'
                : 'assets/storeavatars/$avatar.png')),
      ),
    );
  }

// STORE - ----------------
  Widget buildStoreAppBar(
      String appbarTitle, String avatar, String name, bool trimStoreName) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage((isNumeric(avatar) == false)
                      ? 'assets/storeavatars/no_image_icon.png'
                      : 'assets/storeavatars/$avatar.png')),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(name.toString()))
        ]);
  }

  /*
  Widget buildStoreAppBar(String appbarTitle, String avatar, String name, bool trimStoreName) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(appbarTitle),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage((isNumeric(avatar) == false)
                            ? 'assets/storeavatars/no_image_icon.png'
                            : 'assets/storeavatars/$avatar.png')),
                  ),
                ),
                Text(name.length > 15 && trimStoreName? name.substring(0, 12) + "..." : name,
                    style: TextStyle(fontSize: 10))
              ]),
        ]);
  }
*/
  Widget buildStoreListTitle(String storeName) {
    return Text((null == storeName) ? "" : storeName,
        style: TextStyle(color: Color.fromRGBO(10, 10, 10, 100)));
  }

  Widget buildStoreListSubTitle(bool isActivated, String storeState,
      num daySale, num dayGain, DateTime lastRecordedSale) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: Text(
            getStateFullName(storeState),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        isActivated
            ? buildStoreDailyGain(daySale, dayGain, lastRecordedSale)
            : Container(
                alignment: Alignment.centerLeft,
                child: Text("Inactive",
                    style:
                        TextStyle(color: Color.fromRGBO(213, 129, 102, 1.0))))
      ],
    ));
  }

  Widget buildStoreDailyGain(
      num daySale, num dayGain, DateTime lastRecordedSale) {
    DateTime yesterdayDate = DateTime.now().subtract(new Duration(days: 1));
    DateTime yesterday = new DateTime(
        yesterdayDate.year, yesterdayDate.month, yesterdayDate.day);
    var fontColor = Colors.green;
    if (null != lastRecordedSale) {
      if (lastRecordedSale.compareTo(yesterday) < 0) {
        fontColor = Colors.red;
      }
    }
    String lastRecordedSaleFormatted = formatDateShort(lastRecordedSale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(left: 0.0), child: Text("Day Gain")),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(left: 0.0), child: Text("Day Sale")),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Text("\$" + dayGain.toString(),
                      style: TextStyle(fontSize: 20))),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Text("\$" + daySale.toString(),
                      style: TextStyle(fontSize: 20))),
            ),
          ],
        ),
        (lastRecordedSaleFormatted.isNotEmpty)
            ? Container(
                child: Text(
                "Last closing on " + lastRecordedSaleFormatted,
                style: TextStyle(fontSize: 10, color: fontColor),
              ))
            : Container(
                height: 0,
                width: 0,
              )
      ],
    );
  }

  userNotActiveWrongAlert(errorMessage, context) {
    return AlertDialog(
      title: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          leading: Container(
            padding: EdgeInsets.only(left: 0),
            child: Icon(Icons.info, color: Colors.orange[300]),
          ),
          title: Text(
            errorMessage,
            style: TextStyle(
                color: Colors.orange[300], fontWeight: FontWeight.bold),
          )),
      content: new Text("error desc:" + errorMessage,
          style: TextStyle(color: Colors.grey)),
      actions: <Widget>[
        new RaisedButton(
          color: Colors.green[300],
          textColor: Colors.white,
          child: new Text("dismiss"),
          onPressed: () {
            _onLogout(context);
          },
        ), // usually buttons at the bottom of the dialog
        new FlatButton(
          textColor: Colors.grey,
          child: new Text("click to reactivate"),
          onPressed: () {
            _onLogout(context);
          },
        ),
      ],
    );
  }

  alertDialogBox(icon, String title, String content, List<Widget> actions) {
    return AlertDialog(
        title: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            leading: Container(
              padding: EdgeInsets.only(left: 0),
              child: Icon(icon, color: Colors.orange[300]),
            ),
            title: Text(
              title,
              style: TextStyle(
                  color: Colors.orange[300], fontWeight: FontWeight.bold),
            )),
        content: new Text(content, style: TextStyle(color: Colors.grey)),
        actions: actions);
  }

  somethingWentWrongAlert(errorMessage, context) {
    return AlertDialog(
      title: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          leading: Container(
            padding: EdgeInsets.only(left: 0),
            child: Icon(Icons.info, color: Colors.orange[300]),
          ),
          title: Text(
            "Opps Something went wrong",
            style: TextStyle(
                color: Colors.orange[300], fontWeight: FontWeight.bold),
          )),
      content: new Text("error desc:" + errorMessage,
          style: TextStyle(color: Colors.grey)),
      actions: <Widget>[
        new RaisedButton(
          color: Colors.green[300],
          textColor: Colors.white,
          child: new Text("dismiss"),
          onPressed: () {
            _onLogout(context);
          },
        ), // usually buttons at the bottom of the dialog
        new FlatButton(
          textColor: Colors.grey,
          child: new Text("report issue"),
          onPressed: () {
            //Navigator.of(context).pop();
            _onLogout(context);
          },
        ),
      ],
    );
  }
  /*
  somethingWentWrongAlert1() {
    return AlertDialog(
      title: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          leading: Container(
            padding: EdgeInsets.only(left: 0),
            child: Icon(Icons.info, color: Colors.orange[300]),
          ),
          title: Text(
            "Opps Something went wrong",
            style: TextStyle(
                color: Colors.orange[300], fontWeight: FontWeight.bold),
          )),
      content: new Text("error desc:" + this._errorMessage,
          style: TextStyle(color: Colors.grey)),
      actions: <Widget>[
        new RaisedButton(
          color: Colors.green[300],
          textColor: Colors.white,
          child: new Text("dismiss"),
          onPressed: () {
            _onLogout(context);
          },
        ), // usually buttons at the bottom of the dialog
        new FlatButton(
          textColor: Colors.grey,
          child: new Text("report issue"),
          onPressed: () {
            //Navigator.of(context).pop();
            _onLogout(context);
          },
        ),
      ],
    );
  }
  */

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.green[300],
        child: CircularProgressIndicator(),
      ),
    );
  }

  buildWaitingScreen1() {
    new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "loading.. wait...",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScaffoldWithAppBar(Widget body, String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
    );
  }

  Widget buildScaffoldWithCustomAppBar(Widget body, AppBar appBar) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  Widget buildScaffoldWithDrawer(
      Widget body, AppBar appBar, Drawer drawer, Key scaffoldKey) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      body: body,
      drawer: drawer,
    );
  }

  Widget buildScaffoldWithDrawerAndBottomNavigatorTabs(
      Widget body, Widget bottomNavigationBar, Key scaffoldKey) {
    return Scaffold(
      key: scaffoldKey,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget buildScaffoldWithCustomAppBarWithKey(
      Widget body, AppBar appBar, Key key) {
    return Scaffold(
      key: key,
      appBar: appBar,
      body: body,
    );
  }

  Widget buildScaffoldWithoutAppBar(Widget body) {
    return Scaffold(
      body: body,
    );
  }

  String validatePhoneNumber(String value) {
    // return null if valid
    if (value == null || !_phoneNoRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String validatePhoneNumberOptional(String value) {
    return null;
  }

  String validateEmail(String value) {
    // return null if valid
    if (value == null || !_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String validateText(String value) {
    // return null if valid
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value == null || !_passwordRegex.hasMatch(value)) {
      return 'Password must be min 4 characters';
    }
    return null;
  }

  String validateConfirmPassword(String value, String mainPassword) {
    if (value == null || !_passwordRegex.hasMatch(value)) {
      return 'Password must be min 4 characters';
    }
    if (value != mainPassword) {
      return 'Passwords are not same';
    }
    return null;
  }

  displaySnackbar(BuildContext context, String message, Duration duration,
      SnackBarAction action) {
    final SnackBar snackBar = SnackBar(
        content: new Text(message), duration: duration, action: action);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  FlatButton createFlatButton(String text, Function onPressedFunction) {
    return FlatButton(
      child: Text(text),
      onPressed: onPressedFunction,
    );
  }

  RaisedButton createRoundedCornerRaisedButton(
      BuildContext context, String text, Function onPressedFunction) {
    return RaisedButton(
      elevation: 10.0,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12.0)),
      padding: EdgeInsets.only(top: 18.0, bottom: 18.0),
      color: Colors.blueGrey,
      child: Text(
        text,
        style: Theme.of(context).primaryTextTheme.button,
      ),
      onPressed: onPressedFunction,
    );
  }

  Widget getDivider() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Divider(
        color: Colors.white70,
        height: 10.0,
      ),
    );
  }

  InputDecoration getInputDecoration(
      BuildContext context, String label, String hint) {
    return InputDecoration(
      // border: OutlineInputBorder(),
      labelText: label,
      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
      hintText: hint,
      hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
      errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
      border: Theme.of(context).inputDecorationTheme.border,
    );
  }

  InputDecoration getIconInputDecoration(BuildContext context, String label,
      String hint, IconData iconData, Function onPressed, bool isIconVisible) {
    return InputDecoration(
      // border: OutlineInputBorder(),
      labelText: label,
      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
      hintText: hint,
      hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
      errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
      border: Theme.of(context).inputDecorationTheme.border,
      suffixIcon: IconButton(
        icon: Icon(
          iconData,
          color: isIconVisible ? Colors.black : Colors.transparent,
        ),
        onPressed: isIconVisible ? onPressed : () {},
      ),
    );
  }

  Locale getDeviceLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  String getDeviceLanguageCode(BuildContext context) {
    return getDeviceLocale(context).languageCode;
  }

  String getDeviceCountryCode(BuildContext context) {
    return getDeviceLocale(context).countryCode;
  }

  bool isValidString(String input) {
    return input != null && input.trim().length > 0;
  }

  String toWordCase(String input) {
    if (isValidString(input)) {
      // Divide words by spacing
      List<String> array = input.split(' ');
      StringBuffer buffer = StringBuffer('');
      for (String word in array) {
        String output = word.substring(0, 1).toUpperCase() +
            word.substring(1).toLowerCase();
        buffer.write(output + ' ');
      }

      return buffer.toString();
    }
    return input;
  }

  /* Internal Build Method(s) */
/*
  Drawer buildDrawer(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          top: true,
          bottom: true,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              //Your Journey
              ListTile(
                leading: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                title: Text(
                  toWordCase(AppData()
                      .getTranslation('navigationMenuView_journey')),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onTap: () {
                  // scaffoldKey.currentState.showSnackBar(SnackBar(
                  //   content: Text('Clicked Journey'),
                  //   duration: Duration(seconds: 1),
                  // ));
                  Navigator.of(context).pop();
                },
              ),
              // Badges
              ListTile(
                leading: Icon(
                  Icons.cake,
                  color: Colors.white,
                ),
                title: Text(
                  toWordCase(AppData()
                      .getTranslation('navigationMenuView_badges')),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Clicked Badges'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/badgesList');
                },
              ),
              // Messages
              ListTile(
                leading: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                title: Text(
                  toWordCase(AppData()
                      .getTranslation('navigationMenuView_messages')),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Clicked Message(s)'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/messagesList');
                },
              ),
              // Contact Site
              ListTile(
                leading: Icon(
                  Icons.contact_phone,
                  color: Colors.white,
                ),
                title: Text(
                  toWordCase(AppData()
                      .getTranslation('navigationMenuView_contactSite')),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Clicked Contact Site'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/contactSite');
                },
              ),
              // Resources
              ListTile(
                leading: Icon(
                  Icons.view_list,
                  color: Colors.white,
                ),
                title: Text(
                  toWordCase(AppData()
                      .getTranslation('navigationMenuView_resources')),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Clicked Resources'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/resourcesList');
                },
              ),
              // Visits
              ListTile(
                leading: Icon(
                  Icons.view_headline,
                  color: Colors.white,
                ),
                title: Text(
                  toWordCase(AppData()
                      .getTranslation('navigationMenuView_visits')),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Clicked Visit'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop();
                },
              ),
              // Settings
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: Text(
                  toWordCase(AppData()
                      .getTranslation('navigationMenuView_settings')),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Clicked Settings'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              // Help
              ListTile(
                leading: Icon(
                  Icons.help_outline,
                  color: Colors.white,
                ),
                title: Text(
                  toWordCase(AppData()
                      .getTranslation('navigationMenuView_help')),
                  style: Theme.of(context).primaryTextTheme.button,
                ),
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Clicked Help'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/help');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
*/
  Future<bool> onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }
/*
  String hash(String text) {
    var bytes = utf8.encode(text);
    var digest = sha256.convert(bytes);
    List<int> digestBytes = digest.bytes;
    return HEX.encode(digestBytes);
  }*/
}
