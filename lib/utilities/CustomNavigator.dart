import 'package:flutter/material.dart';
//페이지 라우팅과 관련된 파일이다.
class CustomNavigator extends StatefulWidget {
  final Widget page;
  final GlobalKey<NavigatorState> navigatorKey;
  const CustomNavigator({Key? key, required this.page, required this.navigatorKey}) : super(key: key);

  @override
  _CustomNavigatorState createState() => _CustomNavigatorState();
}

class _CustomNavigatorState extends State<CustomNavigator> with AutomaticKeepAliveClientMixin { //페이지의 상태를 유지하고 라우팅한다.
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

class CustomTab extends StatefulWidget { //페이지의 상태를 유지하고 필요한 값을 반환한다.
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