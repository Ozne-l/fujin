import 'package:flutter/material.dart';
import 'package:fujin/pages/tabs/floating_tab_bar.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:go_router/go_router.dart';

class TabShell extends StatelessWidget {
  const TabShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    body: navigationShell,
    bottomNavigationBar: FloatingTabBar(
      selected: FujinTab.values[navigationShell.currentIndex],
      onSelect: (tab) => navigationShell.goBranch(
        tab.index,
        initialLocation: tab.index == navigationShell.currentIndex,
      ),
    ),
  );
}
