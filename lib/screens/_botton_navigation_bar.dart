import 'package:flutter/material.dart';
import 'package:lott/mixins/bottom_tabs_mixin.dart';
import 'package:lott/mixins/app_utils_mixin.dart';
//https://medium.com/coding-with-flutter/flutter-case-study-multiple-navigators-with-bottomnavigationbar-90eb6caa6dbf
//https://github.com/shubie/Beautiful-List-UI-and-detail-page/blob/master/lib/main.dart
class BottonNavigationBar extends StatelessWidget with TabHelperMixin, AppUtilsMixin {
  BottonNavigationBar({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.REPORTS, icon: Icons.insert_chart),
        _buildItem(tabItem: TabItem.INVENTORY, icon: Icons.shopping_cart),
        _buildItem(tabItem: TabItem.CLOSING, icon: Icons.event_available),
        _buildItem(tabItem: TabItem.ACCOUNTS, icon: Icons.account_circle),
        _buildItem(tabItem: TabItem.SETTINGS, icon: Icons.settings),
      ],
      onTap: (index) => onSelectTab(
            TabHelperMixin.item(index: index),
          ),
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem, IconData icon}) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        tabDescription(tabItem),
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    if(currentTab != item) 
     return Colors.grey;

    switch (currentTab) {
      case TabItem.REPORTS:
        return colorReportsTab;
      case TabItem.INVENTORY:
        return colorInventoryTab;
      case TabItem.CLOSING:
        return colorClosingTab;
      case TabItem.ACCOUNTS:
        return colorAccountsTab;
     /* case TabItem.SETTINGS:
        return colorSettingsTab;*/
        default:
    return Colors.grey[800];
}
  }
  /*
  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? Color.fromRGBO(191, 111, 35, 1.0) : Colors.grey;
  }*/
}
