import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lott/screens/_botton_navigation_bar.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/common/route_list.dart';
import 'package:lott/models/store.dart';
import 'package:lott/screens/add_store_screen.dart';
import 'package:lott/screens/product_purchase_manager_screen.dart';
import 'package:lott/screens/product_sales_manager_screen.dart';
//import 'package:lott/screens/product_sales_screen.dart';
import 'package:lott/screens/settings_screen.dart';
import 'package:lott/mixins/theme_mixin.dart';
import 'package:lott/mixins/bottom_tabs_mixin.dart';
import 'package:lott/screens/store_list_accounts_screen.dart';
import 'package:lott/screens/store_list_closing_screen.dart';
import 'package:lott/screens/store_list_inventory_screen.dart';
import 'package:lott/screens/store_avatars_screen.dart';
import 'package:lott/screens/edit_store_screen.dart';
import 'package:lott/screens/store_list_reports_screen.dart';
import 'package:lott/screens/add_product_screen.dart';

enum AppDataLoaderStatus { NOT_DETERMINED, COMPLETED, FAILED, USER_NOT_ACTIVE }

class HomeScreen extends StatefulWidget {
  HomeScreen({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AppUtilsMixin, ThemeMixin, TabHelperMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppDataLoaderStatus _appDataLoaderStatus = AppDataLoaderStatus.NOT_DETERMINED;
  StreamSubscription<QuerySnapshot> _storeSub;
  String _errorMessage = "";
  bool _isActive = AppData().getUser().active;
  ThemeData _themeData;
  TabItem currentTab = TabItem.ACCOUNTS;
  @override
  void initState() {
    try {
      if (null == _isActive) {
        AppData()
            .getDatabase()
            .getFirebaseUser(AppData().getUser().emailId)
            .then((user) {
          _isActive = AppData().getUser().active;
          if (_isActive) {
            loadAppData();
          } else {
            setState(() {
              this._errorMessage =
                  "Acccount is not active (Go to Settings->Activate)";
              this._appDataLoaderStatus = AppDataLoaderStatus.USER_NOT_ACTIVE;
              currentTab = TabItem.SETTINGS;
            });
          }
        });
      } else if (_isActive) loadAppData();
    } catch (e) {
      setState(() {
        this._errorMessage = e.toString();
        this._appDataLoaderStatus = AppDataLoaderStatus.FAILED;
      });
    }
    _themeData = buildThemeData2();
    //loadAppData(false);
    super.initState();
  }

  loadAppData() {
    if (null == _isActive) return;

    if (_isActive) {
      if (AppData().getReloadAppStores() ||
          null == AppData().getStores() ||
          AppData().getStores().length == 0) {
        _storeSub?.cancel();
        _storeSub = AppData()
            .getDatabase()
            .getStores(AppData().getUser().emailId)
            .listen((QuerySnapshot snapshot) {
          final List<Store> stores = snapshot.documents
              .map((documentSnapshot) => Store.fromMap(documentSnapshot.data))
              .toList();
          AppData().setStores(stores);
          AppData().setReloadAppStores(false);
          setState(() {
            this._appDataLoaderStatus = AppDataLoaderStatus.COMPLETED;
            //currentTab = TabItem.CLOSING;
          });
        });
      } else {
        setState(() {
          this._appDataLoaderStatus = AppDataLoaderStatus.USER_NOT_ACTIVE;
          currentTab = TabItem.SETTINGS;
        });
      }
    }
    //false and null
    //true and false
    //true and true

    //false and true
  }

/*  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.REPORTS: GlobalKey<NavigatorState>(),
    TabItem.INVENTORY: GlobalKey<NavigatorState>(),
    TabItem.CLOSING: GlobalKey<NavigatorState>(),
    TabItem.ACCOUNTS: GlobalKey<NavigatorState>(),
    TabItem.SETTINGS: GlobalKey<NavigatorState>(),
  };
*/
  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
      AppData().setCurrentabItem(tabItem);
    });
  }

  homeScreen() {
    return buildScaffoldWithDrawerAndBottomNavigatorTabs(
        Stack(children: _buildOffstageNavigator()),
        BottonNavigationBar(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ).build(context),
        _scaffoldKey);
  }

  _buildOffstageNavigator() {
    return <Widget>[
      Offstage(
        offstage: currentTab != TabItem.REPORTS,
        child: new TickerMode(
          enabled: currentTab == TabItem.REPORTS,
          child: new MaterialApp(
            debugShowCheckedModeBanner: false,
            checkerboardOffscreenLayers: false,
            theme: _themeData,
            onGenerateRoute: routesReports,
          ),
        ),
      ),
      Offstage(
          offstage: currentTab != TabItem.INVENTORY,
          child: new TickerMode(
            enabled: currentTab == TabItem.INVENTORY,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              checkerboardOffscreenLayers: false,
              theme: _themeData,
              onGenerateRoute: routesInventory,
            ),
          )),
      Offstage(
          offstage: currentTab != TabItem.CLOSING,
          child: new TickerMode(
            enabled: currentTab == TabItem.CLOSING,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              checkerboardOffscreenLayers: false,
              theme: _themeData,
              onGenerateRoute: routesClosing,
            ),
          )),
      Offstage(
        offstage: currentTab != TabItem.ACCOUNTS,
        child: new TickerMode(
          enabled: currentTab == TabItem.ACCOUNTS,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            checkerboardOffscreenLayers: false,
            theme: _themeData,
            onGenerateRoute: routesAccounts,
          ),
        ),
      ),
      Offstage(
        offstage: currentTab != TabItem.SETTINGS,
        child: new TickerMode(
          enabled: currentTab == TabItem.SETTINGS,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            checkerboardOffscreenLayers: false,
            theme: _themeData,
            onGenerateRoute: routesSettings,
          ),
        ),
      ),
    ];
  }
  /* Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    switch (this._appDataLoaderStatus) {
      case AppDataLoaderStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AppDataLoaderStatus.USER_NOT_ACTIVE:
        return userNotActiveWrongAlert(this._errorMessage, context);
        break;
      case AppDataLoaderStatus.COMPLETED:
        return homeScreen();
        break;
      case AppDataLoaderStatus.FAILED:
        return somethingWentWrongAlert(this._errorMessage, context);
        break;
      default:
        return somethingWentWrongAlert(this._errorMessage, context);
    }
  }

  Route routesReports(RouteSettings settings) {
    var bottomTab = TabItem.REPORTS.toString();
    /*switch (settings.name) {
      case ROUTE_PRODUCT_PURCHASE_MANAGER:
        return buildCustomRoute(
            ProductPurchaseManagerScreen(bottomTab: bottomTab), settings);
    }*/
    return buildCustomRoute(
        ListStoreReportsPage(bottomTab: bottomTab), settings);
  }

  Route routesInventory(RouteSettings settings) {
    var bottomTab = TabItem.INVENTORY.toString();
    switch (settings.name) {
      case ROUTE_PRODUCT_PURCHASE_MANAGER:
        return buildCustomRoute(
            ProductPurchaseManagerScreen(bottomTab: bottomTab), settings);
      case ROUTE_ADD_PRODUCT:
        return buildCustomRoute(
            AddProductPage(bottomTab: bottomTab), settings);
            
    }
    return buildCustomRoute(
        ListStoreInventoryPage(bottomTab: bottomTab), settings);
  }

  Route routesClosing(RouteSettings settings) {
    var bottomTab = TabItem.CLOSING.toString();
    switch (settings.name) {
      case ROUTE_PRODUCT_SALES_MANAGER:
        return buildCustomRoute(
            ProductSalesManagerScreen(bottomTab: bottomTab), settings);
     /* case ROUTE_PRODUCT_SALES:
        return buildCustomRoute(
            ProductSalesScreen(bottomTab: bottomTab), settings);*/
    }
    return buildCustomRoute(
        ListStoreClosingPage(bottomTab: bottomTab), settings);
  }

  Route routesAccounts(RouteSettings settings) {
    var bottomTab = TabItem.ACCOUNTS.toString();
    switch (settings.name) {
      case ROUTE_LIST_STORE:
        return buildCustomRoute(
            ListStoreAccountsPage(bottomTab: bottomTab), settings);
      case ROUTE_ADD_STORE:
        return buildCustomRoute(AddStorePage(bottomTab: bottomTab), settings);
      case ROUTE_EDIT_STORE:
        return buildCustomRoute(EditStorePage(bottomTab: bottomTab), settings);
      /*case ROUTE_PRODUCT_LOADER:
        return buildCustomRoute(
            ProductLoaderScreen(bottomTab: bottomTab), settings);
            
      case ROUTE_LIST_PRODUCT:
        return buildCustomRoute(
            ListProductScreen(bottomTab: bottomTab), settings);
          */
      case ROUTE_STORE_AVATARS:
        return buildCustomRoute(
            StoreAvatarsScreen(bottomTab: bottomTab), settings);
    }
    return buildCustomRoute(
        ListStoreAccountsPage(bottomTab: bottomTab), settings);
  }

  Route routesSettings(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_SETTINGS:
      case ROUTE_HELP:
    }
    return buildCustomRoute(
        SettingsScreen(onSignedOut: widget.onSignedOut), settings);
  }
}

CustomRoute buildCustomRoute(Widget widget, RouteSettings settings) {
  return CustomRoute(
      builder: (_) {
        return widget;
      },
      settings: settings);
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return FadeTransition(opacity: animation, child: child);
  }
}
