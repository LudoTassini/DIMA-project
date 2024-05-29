import 'package:bloqo/components/complex/bloqo_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';
import '../from_user/setting_page.dart';

class UserPage extends StatefulWidget {

  const UserPage({
    super.key,
    required this.onPush
  });

  final void Function(Widget) onPush;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin<UserPage>{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    return BloqoMainContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              BloqoSeasaltContainer(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Stack(
                          alignment: const AlignmentDirectional(0, 1),
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://picsum.photos/seed/914/600',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(1, 1),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: BloqoColors.russianViolet,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(8),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: BloqoColors.seasalt,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Provider.of<UserAppState>(context, listen: false).get()!.fullName,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            color: BloqoColors.secondaryText,
                                            fontSize: 16,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        Text(
                                          Provider.of<UserAppState>(context, listen: false).get()!.username,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            color: BloqoColors.primaryText,
                                            fontSize: 22,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(1, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: BloqoColors.russianViolet,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.qr_code_2,
                                          color: BloqoColors.seasalt,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                            child: Text(
                                              localizedText.followers,
                                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                fontSize: 14,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            Provider.of<UserAppState>(context, listen: false).get()!.followers.toString(),
                                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                              fontSize: 18,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                            child: Text(
                                              localizedText.following,
                                              style:
                                              Theme.of(context).textTheme.displayMedium?.copyWith(
                                                fontSize: 14,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            Provider.of<UserAppState>(context, listen: false).get()!.following.toString(),
                                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                              fontSize: 18,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                  )
                )
              ),
              BloqoSetting(
                onPressed: () => widget.onPush(SettingPage(onPush: widget.onPush)),
                settingTitle: localizedText.account_settings_title,
                settingDescription: localizedText.account_settings_description,
                settingIcon: Icons.manage_accounts_rounded,
              ),
              BloqoSetting(
                onPressed: () => widget.onPush(SettingPage(onPush: widget.onPush)),
                settingTitle: localizedText.notification_settings_title,
                settingDescription: localizedText.notification_settings_description,
                settingIcon: Icons.edit_notifications,
              ),
              BloqoSetting(
                onPressed: () => widget.onPush(SettingPage(onPush: widget.onPush)),
                settingTitle: localizedText.external_accounts_title,
                settingDescription: localizedText.external_accounts_description,
                settingIcon: Icons.app_registration,
              ),
              BloqoSetting(
                onPressed: () => widget.onPush(SettingPage(onPush: widget.onPush)),
                settingTitle: localizedText.sign_out_title,
                settingDescription: localizedText.sign_out_description,
                settingIcon: Icons.logout,
              ),
              Container(
                height: 40,
              )
            ]
          )
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}