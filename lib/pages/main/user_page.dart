import 'dart:io';

import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/complex/bloqo_setting.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/forms/bloqo_switch.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/components/popups/bloqo_error_alert.dart';
import 'package:bloqo/model/courses/tags/bloqo_course_tag.dart';
import 'package:bloqo/style/themes/bloqo_theme.dart';
import 'package:bloqo/utils/bloqo_setting_type.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/permissions.dart';
import 'package:bloqo/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/complex/bloqo_user_details.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../utils/auth.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../../utils/multimedia_uploader.dart';
import '../../utils/text_validator.dart';
import '../../utils/toggle.dart';
import '../from_user/setting_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    super.key,
    required this.onPush,
    required this.onNavigateToPage
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin<UserPage> {

  final formKeyFullName = GlobalKey<FormState>();
  late TextEditingController fullNameController;
  late TextEditingController languageController;
  late TextEditingController themeController;

  late List<DropdownMenuEntry<String>> languages;
  late List<DropdownMenuEntry<String>> themes;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    languageController = TextEditingController();
    themeController = TextEditingController();
  }

  @override
  void dispose() {
    themeController.dispose();
    languageController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  void _updateUserPage({required var localizedText}) {
    setState(() {
      languages = buildTagList(type: BloqoCourseTagType.language, localizedText: localizedText, withNone: false);
      languages.removeWhere((x) => x.label == localizedText.other);

      themes = buildThemesList(localizedText: localizedText);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = getAppThemeFromAppState(context: context);
    var localizedText = getAppLocalizations(context)!;

    languages = buildTagList(type: BloqoCourseTagType.language, localizedText: localizedText, withNone: false);
    languages.removeWhere((x) => x.label == localizedText.other);

    themes = buildThemesList(localizedText: localizedText);

    final user = getUserFromAppState(context: context)!;
    final Toggle fullNameVisible = Toggle(initialValue: user.isFullNameVisible);
    bool isTablet = checkDevice(context);

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: SingleChildScrollView(
        child: Consumer<UserAppState>(
          builder: (context, userAppState, _) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                BloqoUserDetails(
                  user: user,
                  isFullNameVisible: true,
                  showFollowingOptions: false,
                  onPush: widget.onPush,
                  onNavigateToPage: widget.onNavigateToPage,
                  onReplacePicture: () async {
                    final newUrl = await _askUserForAnImage(
                        context: context,
                        localizedText: localizedText,
                        userId: user.id
                    );
                    if(newUrl != null) {
                      if(!context.mounted) return;
                      updateUserPictureUrlInAppState(context: context, newUrl: newUrl);
                    }
                  },
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
                            Flexible(
                                child: Text(
                                  localizedText.full_name_visible,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
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
                BloqoSetting(
                  settingTitle: localizedText.application_settings_title,
                  settingDescription: localizedText.application_settings_description,
                  settingIcon: Icons.settings_applications_rounded,
                  onPressed: () {
                    widget.onPush(SettingPage(
                        settingTitle: localizedText.application_settings_title,
                        settingDescription: localizedText.application_settings_description,
                        settingType: BloqoSettingType.application,
                        forms: [
                          Row(
                              children: [
                                Expanded(
                                    child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                          double availableWidth = constraints.maxWidth;

                                          String languageInitialSelection = languages
                                              .firstWhere(
                                                  (lang) => lang.value.toLowerCase().startsWith(getLanguageFromAppState(context: context).languageCode, ("BloqoLanguageTagValue.").length)).label;

                                          String themeInitialSelection = themes
                                              .firstWhere(
                                                  (lang) => lang.value == theme.type.toString()).label;

                                          languageController.text = languageInitialSelection;
                                          themeController.text = themeInitialSelection;

                                          return Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                                                  child: BloqoDropdown(
                                                      controller: languageController,
                                                      dropdownMenuEntries: languages,
                                                      initialSelection: languageInitialSelection,
                                                      width: availableWidth,
                                                      label: localizedText.language
                                                  ),
                                                ),
                                                BloqoDropdown(
                                                    controller: themeController,
                                                    dropdownMenuEntries: themes,
                                                    initialSelection: themeInitialSelection,
                                                    width: availableWidth,
                                                    label: localizedText.theme
                                                )
                                              ]
                                          );
                                        }
                                    )
                                )
                              ]
                          ),
                        ],
                        controllers: [
                          languageController,
                          themeController
                        ],
                        onSettingsUpdated: () => _updateUserPage(localizedText: localizedText)
                    ));
                  },
                ),
                BloqoSetting(
                  onPressed: () {
                    showBloqoConfirmationAlert(
                        context: context,
                        title: localizedText.warning,
                        description: localizedText.logout_confirmation,
                        confirmationFunction: () async {
                          await _tryLogout(
                              context: context,
                              localizedText: localizedText
                          );
                        },
                        backgroundColor: theme.colors.leadingColor
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

  Future<void> _tryLogout({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try{
      await logout(localizedText: localizedText);
      await deleteUserSharedPreferences();
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

  Future<String?> _askUserForAnImage({required BuildContext context, required var localizedText, required String userId}) async {
    PermissionStatus permissionStatus = await requestPhotoLibraryPermission();
    if(permissionStatus.isGranted) {
      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (pickedFile != null) {
        if(!context.mounted) return null;
        context.loaderOverlay.show();
        try {
          final image = File(pickedFile.path);
          final url = await uploadProfilePicture(
              localizedText: localizedText,
              image: image,
              userId: userId
          );
          if (!context.mounted) return null;
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
          );
          return url;
        }
        on BloqoException catch (e) {
          if (!context.mounted) return null;
          context.loaderOverlay.hide();
          showBloqoErrorAlert(
              context: context,
              title: localizedText.error_title,
              description: e.message
          );
        }
      }
    }
    return null;
  }

}