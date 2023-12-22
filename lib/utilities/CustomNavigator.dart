import 'package:flutter/material.dart';

class CustomNavigator extends StatefulWidget {
  final Widget page;
  final GlobalKey<NavigatorState> navigatorKey;
  const CustomNavigator({Key? key, required this.page, required this.navigatorKey}) : super(key: key);

  @override
  _CustomNavigatorState createState() => _CustomNavigatorState();
}

class _CustomNavigatorState extends State<CustomNavigator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => widget.page);
      },
    );
  }
}

class CustomTab extends StatefulWidget {
  final Widget page;
  const CustomTab({Key? key, required this.page}) : super(key: key);

  @override
  CustomTabState createState() => CustomTabState();
}

class CustomTabState extends State<CustomTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.page;
  }
}