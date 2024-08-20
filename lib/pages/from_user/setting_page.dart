import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:bloqo/utils/connectivity.dart';
import 'package:bloqo/utils/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../app_state/user_app_state.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/courses/tags/bloqo_course_tag.dart';
import '../../utils/bloqo_setting_type.dart';
import '../../utils/localization.dart';

class SettingPage extends StatefulWidget {

  const SettingPage({
    super.key,
    required this.settingTitle,
    required this.settingDescription,
    required this.forms,
    required this.controllers,
    required this.settingType,
  });

  final String settingTitle;
  final String settingDescription;
  final List<Widget> forms;
  final List<dynamic> controllers;
  final BloqoSettingType settingType;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with AutomaticKeepAliveClientMixin<SettingPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.settingTitle,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: theme.colors.highContrastColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.settingDescription,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: theme.colors.highContrastColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BloqoSeasaltContainer(
                  child: Column(
                    children: List.generate(
                      widget.forms.length,
                          (index) => Padding(
                        padding: index == widget.forms.length - 1
                            ? const EdgeInsets.all(20)
                            : const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: widget.forms[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                  child: BloqoFilledButton(
                    color: theme.colors.leadingColor,
                    onPressed: () async {
                      context.loaderOverlay.show();
                      try {
                        await _updateSettings(
                          context: context,
                          settingType: widget.settingType,
                          controllers: widget.controllers,
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                        );
                        context.loaderOverlay.hide();
                      } on BloqoException catch (e) {
                        if (!context.mounted) return;
                        context.loaderOverlay.hide();
                        showBloqoErrorAlert(
                          context: context,
                          title: localizedText.error_title,
                          description: e.message,
                        );
                      }
                    },
                    text: localizedText.save_settings,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _updateSettings({
    required BuildContext context,
    required BloqoSettingType settingType,
    required List<dynamic> controllers,
  }) async {
    var localizedText = getAppLocalizations(context)!;
    await checkConnectivity(localizedText: localizedText);
    if (!context.mounted) return;
    try {
      switch (settingType) {
        case BloqoSettingType.account:
          final String newFullName = controllers[0].text;
          final bool newFullNameVisible = controllers[1].get();
          final BloqoUserData? user = getUserFromAppState(context: context);

          if (user == null) {
            throw BloqoException(message: localizedText.generic_error);
          }

          final String oldFullName = user.fullName;
          final bool oldFullNameVisible = user.isFullNameVisible;

          if (newFullName != oldFullName || newFullNameVisible != oldFullNameVisible) {
            var ref = BloqoUserData.getRef();
            var querySnapshot = await ref.where("id", isEqualTo: user.id).get();

            if (querySnapshot.docs.isNotEmpty) {
              var documentId = querySnapshot.docs[0].id;
              Map<String, dynamic> updates = {};

              if (newFullName != oldFullName) {
                updates["full_name"] = newFullName;
              }
              if (newFullNameVisible != oldFullNameVisible) {
                updates["is_full_name_visible"] = newFullNameVisible;
              }

              await ref.doc(documentId).update(updates);

              if(!context.mounted) return;
              updateUserFullNameInAppState(context: context, newFullName: newFullName);
              updateUserFullNameVisibilityInAppState(context: context, newFullNameVisible: newFullNameVisible);

            } else {
              throw BloqoException(message: localizedText.generic_error);
            }
          }
          break;
        case BloqoSettingType.application:
          String choice = controllers[0].text;
          List<DropdownMenuEntry<String>> languages = buildTagList(type: BloqoCourseTagType.language, localizedText: localizedText, withNone: false);
          languages.removeWhere((x) => x.label == localizedText.other);
          String newLanguageCode = languages.firstWhere((lang) => lang.label == choice).value.substring(("BloqoLanguageTagValue.").length).substring(0, 2);
          saveLanguageCode(newLanguageCode: newLanguageCode);
          updateLanguageInAppState(context: context, newLanguageCode: newLanguageCode);
          break;
        default:
          break;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "network-request-failed":
          throw BloqoException(message: localizedText.network_error);
        default:
          throw BloqoException(message: localizedText.generic_error);
      }
    }
    Navigator.of(context).pop();
  }

}