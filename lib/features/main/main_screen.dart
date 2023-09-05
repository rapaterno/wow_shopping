import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/main/manager/bottom_nav_bar_manager.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';

export 'package:wow_shopping/models/nav_item.dart';

@immutable
class MainScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  const MainScreen._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const MainScreen._(),
        );
      },
    );
  }

  static MainScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>()!;
  }

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    di.registerSingleton<BottomNavBarManager>(
        BottomNavBarManager(NavItem.home));
    super.initState();
  }

  @override
  void dispose() {
    di.unregister<BottomNavBarManager>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavBarManager = watch(di<BottomNavBarManager>());
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ConnectionMonitor(
                child: IndexedStack(
                  index: bottomNavBarManager.selected.index,
                  children: [
                    for (final item in NavItem.values) //
                      item.builder(),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              onNavItemPressed: bottomNavBarManager.goToSectionCommand.execute,
              selected: bottomNavBarManager.selected,
            ),
          ],
        ),
      ),
    );
  }
}
