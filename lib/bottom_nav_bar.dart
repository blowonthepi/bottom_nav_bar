import 'package:flutter/material.dart';
import 'dart:math' as math;

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int> onTap;
  final double elevation;
  final double iconSize;
  final Color backgroundColor;
  final Color unselectedColor;
  final Color selectedColor;
  final double fontSize;

  BottomNavBar({
    @required this.items,
    @required this.onTap,
    this.currentIndex = 0,
    this.elevation = 8.0,
    this.backgroundColor,
    this.iconSize = 22.0,
    this.selectedColor,
    this.unselectedColor,
    this.fontSize = 12.0,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Widget _createContainer(List<Widget> tiles) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding = math.max(MediaQuery.of(context).padding.bottom - 12.0 / 2.0, 0.0);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        maxWidth: double.infinity,
        minHeight: kBottomNavigationBarHeight + additionalBottomPadding,
        maxHeight: kBottomNavigationBarHeight + additionalBottomPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor ?? widget.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[850].withOpacity(0.1),
              blurRadius: widget.elevation,
              spreadRadius: widget.elevation / 2,
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(top: additionalBottomPadding / 4, bottom: additionalBottomPadding),
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: _createContainer([
                for (int i = 0; i < widget.items.length; i++)
                  Expanded(
                    child: InkResponse(
                      splashFactory: InkRipple.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        widget.onTap(i);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _TabIcon(
                            icon: i == widget.currentIndex
                                ? widget.items[i].activeIcon ?? widget.items[i].icon
                                : widget.items[i].icon,
                            color: _tabColor(i == widget.currentIndex),
                            nav: widget,
                          ),
                          _TabLabel(
                            label: widget.items[i].label,
                            color: _tabColor(i == widget.currentIndex),
                            nav: widget,
                          ),
                        ],
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Color _tabColor(bool selected) {
    var unselected = widget.unselectedColor ?? Theme.of(context).unselectedWidgetColor;
    var selectedCol = widget.selectedColor ?? Theme.of(context).accentColor;
    return selected ? selectedCol : unselected;
  }
}

class _TabIcon extends StatelessWidget {
  final Widget icon;
  final Color color;
  final BottomNavBar nav;

  _TabIcon({this.icon, this.color, this.nav});

  @override
  Widget build(BuildContext context) {
    Icon i = (icon as Icon);
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.2,
      child: Icon(
        i.icon,
        size: nav.iconSize ?? i.size,
        color: color,
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final Color color;
  final BottomNavBar nav;

  _TabLabel({this.label, this.color, this.nav});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: Text(
        label,
        style: TextStyle(fontSize: nav.fontSize, color: color),
      ),
    );
  }
}
