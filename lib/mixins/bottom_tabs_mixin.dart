enum TabItem { REPORTS, INVENTORY, CLOSING, ACCOUNTS, SETTINGS }

class TabHelperMixin {
  static TabItem item({int index}) {
    switch (index) {
      case 0:
        return TabItem.REPORTS;
      case 1:
        return TabItem.INVENTORY;
      case 2:
        return TabItem.CLOSING;
      case 3:
        return TabItem.ACCOUNTS;
      case 4:
        return TabItem.SETTINGS;
    }
    return TabItem.REPORTS;
  }
}

String tabDescription(TabItem tabItem) {
  switch (tabItem) {
    case TabItem.REPORTS:
      return 'Reports';
    case TabItem.INVENTORY:
      return 'Inventory';
    case TabItem.CLOSING:
      return 'Closing';
    case TabItem.ACCOUNTS:
      return "Accounts";
    case TabItem.SETTINGS:
      return "Settings";
  }
  return '';
}