import 'package:flutter/material.dart';

class KeepAliveScreen extends StatefulWidget {
  final Widget page;
  //final Key navigatorKey;
  const KeepAliveScreen({Key? key, required this.page}) : super(key: key);

  @override
  _KeepAliveScreenState createState() => _KeepAliveScreenState();
}

class _KeepAliveScreenState extends State<KeepAliveScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.page;
  }
}