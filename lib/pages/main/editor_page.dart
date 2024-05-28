import 'package:flutter/material.dart';

class EditorPage extends StatefulWidget {

  const EditorPage({
    super.key,
    required this.onPush
  });

  final void Function(Widget) onPush;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> with AutomaticKeepAliveClientMixin<EditorPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Text("Editor page");
  }

  @override
  bool get wantKeepAlive => true;
}