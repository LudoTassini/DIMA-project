import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/model/bloqo_sorting_option.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/forms/bloqo_dropdown.dart';
import '../../components/forms/bloqo_switch.dart';
import '../../model/courses/tags/bloqo_course_tag.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/constants.dart';
import '../../utils/toggle.dart';
import '../from_search/search_results_page.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({
    super.key,
    required this.onPush
  });

  final void Function(Widget) onPush;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage>{

  final formKeyCourseName = GlobalKey<FormState>();
  final formKeyAuthorUsername = GlobalKey<FormState>();
  final formKeyMinimumPublicationDate = GlobalKey<FormState>();
  final formKeyMaximumPublicationDate = GlobalKey<FormState>();

  final Toggle publicCoursesToggle = Toggle(initialValue: true);
  final Toggle privateCoursesToggle = Toggle(initialValue: false);

  late TextEditingController courseNameController;
  late TextEditingController authorUsernameController;
  late TextEditingController minimumPublicationDateController;
  late TextEditingController maximumPublicationDateController;
  late TextEditingController languageTagController;
  late TextEditingController subjectTagController;
  late TextEditingController durationTagController;
  late TextEditingController modalityTagController;
  late TextEditingController difficultyTagController;
  late TextEditingController sortByController;

  @override
  void initState() {
    super.initState();
    courseNameController = TextEditingController();
    authorUsernameController = TextEditingController();
    minimumPublicationDateController = TextEditingController();
    maximumPublicationDateController = TextEditingController();
    languageTagController = TextEditingController();
    subjectTagController = TextEditingController();
    durationTagController = TextEditingController();
    modalityTagController = TextEditingController();
    difficultyTagController = TextEditingController();
    sortByController = TextEditingController();
  }

  @override
  void dispose() {
    courseNameController.dispose();
    authorUsernameController.dispose();
    minimumPublicationDateController.dispose();
    maximumPublicationDateController.dispose();
    languageTagController.dispose();
    subjectTagController.dispose();
    durationTagController.dispose();
    modalityTagController.dispose();
    difficultyTagController.dispose();
    sortByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final localizedText = getAppLocalizations(context)!;

    final List<DropdownMenuEntry<String>> languageTags = buildTagList(type: BloqoCourseTagType.language, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> subjectTags = buildTagList(type: BloqoCourseTagType.subject, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> durationTags = buildTagList(type: BloqoCourseTagType.duration, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> modalityTags = buildTagList(type: BloqoCourseTagType.modality, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> difficultyTags = buildTagList(type: BloqoCourseTagType.difficulty, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> sortingOptions = buildSortingOptionsList(localizedText: localizedText);

    return BloqoMainContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Text(
                    localizedText.search_page_header_1,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: BloqoColors.seasalt,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Text(
                    localizedText.search_page_header_2,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: BloqoColors.seasalt,
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                  child: Form(
                    key: formKeyCourseName,
                    child: BloqoTextField(
                      formKey: formKeyCourseName,
                      controller: courseNameController,
                      labelText: localizedText.course_name,
                      hintText: localizedText.course_name_hint,
                      maxInputLength: Constants.maxCourseNameLength,
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: Form(
                    key: formKeyAuthorUsername,
                    child: BloqoTextField(
                      formKey: formKeyAuthorUsername,
                      controller: authorUsernameController,
                      labelText: localizedText.author_username,
                      hintText: localizedText.author_username_hint,
                      maxInputLength: Constants.maxUsernameLength,
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: Form(
                      key: formKeyMinimumPublicationDate,
                      child: BloqoTextField(
                        formKey: formKeyMinimumPublicationDate,
                        controller: minimumPublicationDateController,
                        labelText: localizedText.minimum_publication_date,
                        hintText: localizedText.minimum_publication_date_hint,
                        keyboardType: TextInputType.datetime,
                        maxInputLength: 10,
                        onTap: () async {
                          // Below line stops keyboard from appearing
                          FocusScope.of(context).requestFocus(FocusNode());
                          // Show Date Picker Here
                          DateTime? picked = await _selectDate(localizedText: localizedText, context: context);
                          setState(() {
                            if(picked == null){
                              minimumPublicationDateController.text = "";
                            }
                            else{
                              minimumPublicationDateController.text = DateFormat("yyyy/MM/dd").format(picked);
                            }
                          });
                        }
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: Form(
                      key: formKeyMaximumPublicationDate,
                      child: BloqoTextField(
                        formKey: formKeyMaximumPublicationDate,
                        controller: maximumPublicationDateController,
                        labelText: localizedText.maximum_publication_date,
                        hintText: localizedText.maximum_publication_date_hint,
                        keyboardType: TextInputType.datetime,
                        maxInputLength: 10,
                        onTap: () async {
                          // Below line stops keyboard from appearing
                          FocusScope.of(context).requestFocus(FocusNode());
                          // Show Date Picker Here
                          DateTime? picked = await _selectDate(localizedText: localizedText, context: context);
                          setState(() {
                            if(picked == null){
                              maximumPublicationDateController.text = "";
                            }
                            else{
                              maximumPublicationDateController.text = DateFormat("yyyy/MM/dd").format(picked);
                            }
                          });
                        }
                      )
                  ),
                ),
                BloqoSeasaltContainer(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                            child: Text(
                              localizedText.show_public_courses,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: BloqoColors.russianViolet,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                        BloqoSwitch(
                          value: publicCoursesToggle,
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
                        )
                      ],
                    ),
                  ),
                ),
                BloqoSeasaltContainer(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                            child: Text(
                              localizedText.show_private_courses,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: BloqoColors.russianViolet,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                        BloqoSwitch(
                          value: privateCoursesToggle,
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
                        )
                      ],
                    ),
                  ),
                ),
                BloqoSeasaltContainer(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              localizedText.search_page_tag_header,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: BloqoColors.russianViolet
                            )
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                  child: Icon(
                                    Icons.label,
                                    color: Color(0xFFFF00FF),
                                    size: 24,
                                  ),
                                ),
                                Expanded(
                                    child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                          double availableWidth = constraints.maxWidth;
                                          return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children:[
                                                BloqoDropdown(
                                                    controller: languageTagController,
                                                    dropdownMenuEntries: languageTags,
                                                    initialSelection: languageTags[0].value,
                                                    label: localizedText.language_tag,
                                                    width: availableWidth
                                                ),
                                              ]
                                          );
                                        }
                                    )
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                  child: Icon(
                                    Icons.label,
                                    color: Color(0xFFFF0000),
                                    size: 24,
                                  ),
                                ),
                                Expanded(
                                    child: LayoutBuilder(
                                      builder: (BuildContext context, BoxConstraints constraints) {
                                        double availableWidth = constraints.maxWidth;
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children:[
                                            BloqoDropdown(
                                                controller: subjectTagController,
                                                dropdownMenuEntries: subjectTags,
                                                initialSelection: subjectTags[0].value,
                                                label: localizedText.subject_tag,
                                                width: availableWidth
                                            ),
                                          ]
                                        );
                                      }
                                    )
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                  child: Icon(
                                    Icons.label,
                                    color: Color(0xFF0000FF),
                                    size: 24,
                                  ),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      double availableWidth = constraints.maxWidth;
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children:[
                                          BloqoDropdown(
                                              controller: durationTagController,
                                              dropdownMenuEntries: durationTags,
                                              initialSelection: durationTags[0].value,
                                              label: localizedText.duration_tag,
                                              width: availableWidth
                                          ),
                                        ]
                                      );
                                    }
                                  )
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                  child: Icon(
                                    Icons.label,
                                    color: Color(0xFF00FF00),
                                    size: 24,
                                  ),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      double availableWidth = constraints.maxWidth;
                                      return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children:[
                                            BloqoDropdown(
                                                controller: modalityTagController,
                                                dropdownMenuEntries: modalityTags,
                                                initialSelection: modalityTags[0].value,
                                                label: localizedText.modality_tag,
                                                width: availableWidth
                                            ),
                                          ]
                                      );
                                    }
                                  )
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                  child: Icon(
                                    Icons.label,
                                    color: Color(0xFFFFFF00),
                                    size: 24,
                                  ),
                                ),
                                Expanded(
                                    child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      double availableWidth = constraints.maxWidth;
                                      return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children:[
                                            BloqoDropdown(
                                                controller: difficultyTagController,
                                                dropdownMenuEntries: difficultyTags,
                                                initialSelection: difficultyTags[0].value,
                                                label: localizedText.difficulty_tag,
                                                width: availableWidth
                                            ),
                                          ]
                                      );
                                    }
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ),
                BloqoSeasaltContainer(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: Text(
                            localizedText.search_page_sort_header,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: BloqoColors.russianViolet,
                            ),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            double availableWidth = constraints.maxWidth;
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              children:[
                                BloqoDropdown(
                                  controller: sortByController,
                                  dropdownMenuEntries: sortingOptions,
                                  label: localizedText.sort_by,
                                  initialSelection: sortingOptions[0].value,
                                  width: availableWidth,
                                )
                              ]
                            );
                          }
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Center(
                    child: BloqoTextButton(
                      color: BloqoColors.error,
                      onPressed: () => _resetSearchCriteria(localizedText: localizedText),
                      text: localizedText.reset_search_criteria,
                    )
                  )
                )
              ]
            )
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: BloqoFilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Container()
                          )
                        );
                      },
                      color: BloqoColors.chineseViolet,
                      icon: Icons.qr_code,
                      text: localizedText.scan_qr_code,
                      fontSize: 16
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: BloqoFilledButton(
                      onPressed: () => widget.onPush(const SearchResultsPage()),
                      color: BloqoColors.russianViolet,
                      text: localizedText.search,
                      icon: Icons.search
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _resetSearchCriteria({required var localizedText}){

    setState(() {
      courseNameController.text = "";
      authorUsernameController.text = "";
      minimumPublicationDateController.text = "";
      maximumPublicationDateController.text = "";

      publicCoursesToggle.reset();
      privateCoursesToggle.reset();

      languageTagController.text = localizedText.none;
      subjectTagController.text = localizedText.none;
      durationTagController.text = localizedText.none;
      modalityTagController.text = localizedText.none;
      difficultyTagController.text = localizedText.none;
      sortByController.text = localizedText.none;
    });

  }

}

Future<DateTime?> _selectDate({required var localizedText, required BuildContext context}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2024),
    lastDate: DateTime(2100),
    keyboardType: TextInputType.datetime,
    confirmText: localizedText.ok,
    cancelText: localizedText.cancel,
    errorFormatText: localizedText.error_invalid_date_format,
    errorInvalidText: localizedText.error_date_out_of_range
  );
  return picked;
}