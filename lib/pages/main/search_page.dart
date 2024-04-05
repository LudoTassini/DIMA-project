import 'package:bloqo/components/navigation/bloqo_app_bar.dart';
import 'package:bloqo/components/navigation/bloqo_nav_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.title});

  final String title;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BloqoAppBar.get(context: context, title: widget.title),
      bottomNavigationBar: const BloqoNavBar(),
    );
  }

}