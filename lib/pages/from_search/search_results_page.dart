import 'package:flutter/material.dart';

class SearchResultsPage extends StatefulWidget {

  const SearchResultsPage({
    super.key,
    required this.onPush
  });

  final void Function(Widget) onPush;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with AutomaticKeepAliveClientMixin<SearchResultsPage> {

  @override
  Widget build(BuildContext context){
    super.build(context);
    return const Text("Search Results Page");
  }

  @override
  bool get wantKeepAlive => true;

}