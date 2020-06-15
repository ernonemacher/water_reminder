import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:waterreminder/components/tab_bar_indicator.dart';
import 'package:waterreminder/config/config_cores.dart';

class TabBarNavigator extends StatelessWidget implements PreferredSizeWidget {
  final Function onChangedPage;
  final int currentPage;

  TabBarNavigator({
    @required this.onChangedPage,
    @required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: TabBarIndicator(
              icon: MdiIcons.water,
              active: currentPage == 0,
              onTap: () {
                this.onChangedPage(0);
              },
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 5,
            child: TabBarIndicator(
              icon: MdiIcons.medal,
              active: currentPage == 1,
              onTap: () {
                this.onChangedPage(1);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
