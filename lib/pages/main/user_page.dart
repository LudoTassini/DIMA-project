import 'package:bloqo/components/complex/bloqo_setting.dart';
import 'package:bloqo/components/forms/bloqo_switch.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/components/popups/bloqo_error_alert.dart';
import 'package:bloqo/pages/from_any/qr_code_page.dart';
import 'package:bloqo/utils/bloqo_qr_code_type.dart';
import 'package:bloqo/utils/bloqo_setting_type.dart';
import 'package:bloqo/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/auth.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../../utils/text_validator.dart';
import '../../utils/toggle.dart';
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

class _UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin<UserPage> {
  final formKeyFullName = GlobalKey<FormState>();
  late TextEditingController fullNameController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: SingleChildScrollView(
        child: Consumer<UserAppState>(
          builder: (context, userAppState, _) {
            final user = userAppState.get()!;
            final Toggle fullNameVisible = Toggle(initialValue: user.isFullNameVisible);
            return Column(
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
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.fullName,
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                color: BloqoColors.secondaryText,
                                                fontSize: 16,
                                                letterSpacing: 0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              user.username,
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                color: BloqoColors.primaryText,
                                                fontSize: 22,
                                                letterSpacing: 0,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: const AlignmentDirectional(1, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: BloqoColors.russianViolet,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.qr_code_2,
                                            color: BloqoColors.seasalt,
                                            size: 32,
                                          ),
                                          onPressed: () {
                                            _showUserQrCode(
                                              username: user.username,
                                              userId: user.id,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                  child: Wrap(
                                    spacing: 15.0,
                                    runSpacing: 10.0,
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
                                              user.followers.toString(),
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
                                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                  fontSize: 14,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              user.following.toString(),
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
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BloqoSetting(
                  settingTitle: localizedText.account_settings_title,
                  settingDescription: localizedText.account_settings_description,
                  settingIcon: Icons.manage_accounts,
                  onPressed: () {
                    fullNameController.text = user.fullName;
                    widget.onPush(SettingPage(
                      settingTitle: localizedText.account_settings_title,
                      settingDescription: localizedText.account_settings_description,
                      forms: [
                        Form(
                          key: formKeyFullName,
                          child: BloqoTextField(
                            formKey: formKeyFullName,
                            controller: fullNameController,
                            labelText: localizedText.full_name,
                            hintText: localizedText.full_name_hint,
                            maxInputLength: Constants.maxFullNameLength,
                            validator: (String? value) {
                              return fullNameValidator(fullName: value, localizedText: localizedText);
                            },
                            padding: EdgeInsetsDirectional.zero,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localizedText.full_name_visible,
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            BloqoSwitch(value: fullNameVisible),
                          ],
                        ),
                      ],
                      controllers: [fullNameController, fullNameVisible],
                      settingType: BloqoSettingType.account,
                    ));
                  },
                ),
                /*BloqoSetting(
                  onPressed: () => widget.onPush(SettingPage(onPush: widget.onPush)),
                  settingTitle: localizedText.notification_settings_title,
                  settingDescription: localizedText.notification_settings_description,
                  settingIcon: Icons.edit_notifications,
                ), TODO */
                BloqoSetting(
                  onPressed: () => widget.onPush(SettingPage(
                    settingTitle: localizedText.external_accounts_title,
                    settingDescription: localizedText.external_accounts_description,
                    settingType: BloqoSettingType.external,
                    controllers: [/* TODO */],
                    forms: [/* TODO */],
                  )),
                  settingTitle: localizedText.external_accounts_title,
                  settingDescription: localizedText.external_accounts_description,
                  settingIcon: Icons.app_registration,
                ),
                BloqoSetting(
                  onPressed: () {
                    showBloqoConfirmationAlert(
                        context: context,
                        title: localizedText.warning,
                        description: localizedText.logout_confirmation,
                        confirmationFunction: () async {
                          _confirmationFunction(
                              context: context,
                              localizedText: localizedText
                          );
                        }
                    );
                  },
                  settingTitle: localizedText.sign_out_title,
                  settingDescription: localizedText.sign_out_description,
                  settingIcon: Icons.logout,
                ),
                Container(
                  height: 40,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmationFunction({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try{
      await logout(localizedText: localizedText);
      await deleteSharedPreferences();
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      Phoenix.rebirth(context);
    }
    on BloqoException catch(e) {
      showBloqoErrorAlert(
          context: context,
          title: localizedText.error_title,
          description: e.message
      );
      context.loaderOverlay.hide();
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _showUserQrCode({required String username, required String userId}){
    widget.onPush(QrCodePage(
        qrCodeTitle: username,
        qrCodeContent: "${BloqoQrCodeType.user.name}_$userId"
    ));
  }

}