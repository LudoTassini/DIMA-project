import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_user_details_short.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../model/bloqo_user_data.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({
    super.key,
    required this.reference,
    required this.followers,
    required this.onPush,
    required this.onNavigateToPage
  });

  final BloqoUserData reference;
  final bool followers;
  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> with AutomaticKeepAliveClientMixin<UserListPage> {
  List<BloqoUserData> users = [];
  int _usersDisplayed = Constants.usersToShowAtFirst;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    void loadMoreUsers() {
      setState(() {
        _usersDisplayed += Constants.usersToFurtherLoadAtRequest;
      });
    }

    var firestore = getFirestoreFromAppState(context: context);

    return BloqoMainContainer(
      child: FutureBuilder(
        future: widget.followers
            ? getUsersFromUserIds(firestore: firestore, localizedText: localizedText, userIds: widget.reference.followers)
            : getUsersFromUserIds(firestore: firestore, localizedText: localizedText, userIds: widget.reference.following),
        builder: (BuildContext context, AsyncSnapshot<List<BloqoUserData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: theme.colors.highContrastColor,
                size: 100,
              ),
            );
          } else if (snapshot.hasData) {
            users = snapshot.data!;
            if (users.isEmpty) {
              return Center(
                child: Text(
                  localizedText.no_users,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: theme.colors.highContrastColor,
                  ),
                ),
              );
            } else {
              return Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            (widget.followers ? localizedText.users_who_follow : localizedText.users_who_are_followed_by) +
                                widget.reference.username,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, color: theme.colors.highContrastColor),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          _usersDisplayed > users.length ? users.length : _usersDisplayed,
                              (index) {
                            BloqoUserData user = users[index];
                            return BloqoUserDetailsShort(
                              user: user,
                              onPush: widget.onPush,
                              onNavigateToPage: widget.onNavigateToPage,
                            );
                          },
                        ),
                      ),
                      if (_usersDisplayed < users.length)
                        BloqoTextButton(
                          onPressed: loadMoreUsers,
                          text: localizedText.load_more,
                          color: theme.colors.highContrastColor,
                        ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                "Error",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: theme.colors.error,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}