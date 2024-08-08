import 'package:flutter/material.dart';

import '../../components/navigation/bloqo_app_bar.dart';

class NotificationsPage extends StatelessWidget {

  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BloqoAppBar.get(
        context: context,
        title: "Prova",
        onPop: () => Navigator.of(context).pop(),
        canPop: true,
        onNotificationIconPressed: null
      ),
      body: Center(
        child: Text("Questa è la pagina delle notifiche"),
      ),
    );
  }
}