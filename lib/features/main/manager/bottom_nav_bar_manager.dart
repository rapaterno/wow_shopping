import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:wow_shopping/models/nav_item.dart';

class BottomNavBarManager extends ChangeNotifier {
  BottomNavBarManager(this.selected) {
    goToSectionCommand = Command.createSyncNoResult((newSelected) {
      selected = newSelected;
      notifyListeners();
    }, notifyOnlyWhenValueChanges: true);
  }
  late final Command<NavItem, void> goToSectionCommand;
  NavItem selected;
}
