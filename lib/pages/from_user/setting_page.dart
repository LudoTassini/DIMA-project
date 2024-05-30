import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:bloqo/utils/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_setting_type.dart';
import '../../utils/localization.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    super.key,
    required this.onPush,
    required this.settingTitle,
    required this.settingDescription,
    required this.forms,
    required this.controllers,
    required this.settingType,
  });

  final void Function(Widget) onPush;
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
                            color: BloqoColors.seasalt,
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
                            color: BloqoColors.seasalt,
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
                    color: BloqoColors.russianViolet,
                    onPressed: () async {
                      context.loaderOverlay.show();
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        try {
                          await _updateSettings(
                            context: context,
                            settingType: widget.settingType,
                            controllers: widget.controllers,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            BloqoSnackBar.get(child: Text(localizedText.done)),
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
                      });
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
}

Future<void> _updateSettings({
  required BuildContext context,
  required BloqoSettingType settingType,
  required List<dynamic> controllers,
}) async {
  var localizedText = getAppLocalizations(context);
  await checkConnectivity(localizedText: localizedText);
  if (!context.mounted) return;
  try {
    switch (settingType) {
      case BloqoSettingType.account:
        final String newFullName = controllers[0].text;
        final bool newFullNameVisible = controllers[1].get();
        final userAppState = Provider.of<UserAppState>(context, listen: false);
        final BloqoUser? user = userAppState.get();

        if (user == null) {
          throw BloqoException(message: localizedText!.generic_error);
        }

        final String oldFullName = user.fullName;
        final bool oldFullNameVisible = user.isFullNameVisible;

        if (newFullName != oldFullName || newFullNameVisible != oldFullNameVisible) {
          var ref = BloqoUser.getRef();
          var querySnapshot = await ref.where("email", isEqualTo: user.email).get();

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
            userAppState.updateFullName(newFullName);
            userAppState.updateIsFullNameVisible(newFullNameVisible);
          } else {
            throw BloqoException(message: localizedText!.generic_error);
          }
        }
        break;
      case BloqoSettingType.notification:
      // TODO Implement notification settings update logic here
        break;
      case BloqoSettingType.external:
      // TODO Implement external accounts settings update logic here
        break;
      default:
        break;
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText!.network_error);
      default:
        throw BloqoException(message: localizedText!.generic_error);
    }
  }
}