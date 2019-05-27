import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/models/store.dart';
import 'package:lott/common/route_list.dart';
import 'package:lott/mixins/bottom_tabs_mixin.dart';

//https://github.com/shubie/Beautiful-List-UI-and-detail-page
class ListStoreInventoryPage extends StatelessWidget with AppUtilsMixin {
  ListStoreInventoryPage({this.bottomTab});
  final String bottomTab;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildScaffoldWithCustomAppBarWithKey(
        Container(child: StoreList(this.bottomTab)),
        AppBar(
          backgroundColor: colorInventoryTab,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            AppData().getMessage("tabInventory"),
            style: TextStyle(color: Colors.white),
          ),
        ),
        _scaffoldKey);
  }
}

class StoreList extends StatefulWidget {
  StoreList(this.bottomTab);
  final String bottomTab;
  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList>
    with TabHelperMixin, AppUtilsMixin {
  List<Store> _stores;

  @override
  void initState() {
    _stores = AppData().getActiveStores();
    super.initState();
  }

  storeList(List<Store> s) {
    ListTile makeListTile(Store store, String avatar) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: buildStoreListLeading(avatar),
        title: buildStoreListTitle(store.name),
        subtitle: buildStoreListSubTitle(store.isActivated, store.state,
            store.daySale, store.dayGain, store.lastRecordedSale),
        trailing: Container(
            width: 20,
            height: 60,
            alignment: Alignment.centerRight,
            child: Icon(Icons.keyboard_arrow_right)),
        onTap: () => onTapSelectedStore(store));

    Card makeCard(Store store) => Card(
          elevation: 0.0,
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Container(
            decoration: BoxDecoration(
                color: store.isActivated ? Colors.white : Colors.blueGrey[100]),
            child: makeListTile(store, store.avatar),
          ),
        );

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: s.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(s[index]);
      },
    );
  }

  onTapSelectedStore(Store s) {
    AppData().setCurrentStore(widget.bottomTab, s);
    if (s.isActivated) {
      AppData().getCurrentStore(widget.bottomTab).setIsNew(false);
      Navigator.of(context).pushNamed(ROUTE_PRODUCT_PURCHASE_MANAGER);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (null == _stores) {
      _stores = AppData().getActiveStores();
    }
    if (null != _stores && _stores.isNotEmpty) {
      return Container(color: Colors.grey[200], child: storeList(_stores));
    } else {
      return buildInfoMessage("There is no active store accounts.",
          "Please tap on Accounts Tab to create a new account or activate existing account.");
    }
  }
}
