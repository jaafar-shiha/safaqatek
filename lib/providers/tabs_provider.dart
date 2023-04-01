import 'package:flutter/material.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';

class TabsProvider with ChangeNotifier{
  Tabs _selectedTab = Tabs.home;

  Tabs get selectedTab => _selectedTab;

  void setCurrentTab({required Tabs currentTab}){
    _selectedTab = currentTab;
    notifyListeners();
  }
}