import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin<UserPage>{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Text("User page");
  }

  @override
  bool get wantKeepAlive => true;
}