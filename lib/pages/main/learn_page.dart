import 'package:flutter/material.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with AutomaticKeepAliveClientMixin<LearnPage>{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Text("Learn page");
  }

  @override
  bool get wantKeepAlive => true;
}