import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {

  const SettingPage({
    super.key,
    required this.onPush
  });

  final void Function(Widget) onPush;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with AutomaticKeepAliveClientMixin<SettingPage> {

  @override
  Widget build(BuildContext context){
    super.build(context);
    return const Text("Setting Page");
  }

  @override
  bool get wantKeepAlive => true;

}