import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> with AutomaticKeepAliveClientMixin<HelpPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Text("Help page");
  }

  @override
  bool get wantKeepAlive => true;
}