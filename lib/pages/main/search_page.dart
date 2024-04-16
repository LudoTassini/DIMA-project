import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/model/bloqo_sorting_option.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/forms/bloqo_dropdown.dart';
import '../../components/forms/bloqo_switch.dart';
import '../../model/courses/tags/bloqo_course_tag.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/constants.dart';
import '../../utils/toggle.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

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

    final List<DropdownMenuEntry<String>> subjectTags = buildTagList(type: BloqoCourseTagType.subject);
    final List<DropdownMenuEntry<String>> durationTags = buildTagList(type: BloqoCourseTagType.duration);
    final List<DropdownMenuEntry<String>> modalityTags = buildTagList(type: BloqoCourseTagType.modality);
    final List<DropdownMenuEntry<String>> difficultyTags = buildTagList(type: BloqoCourseTagType.difficulty);
    final List<DropdownMenuEntry<String>> sortingOptions = buildSortingOptionsList();

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
                    'Tell us what you are looking for.',
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
                    'Every field is optional. Freely choose your filters and sorting options.',
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
                      labelText: 'Course name',
                      hintText: 'e.g. Basic English for Italian Speakers',
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
                      labelText: 'Author username',
                      hintText: 'e.g. Vanessa Visconti',
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
                        labelText: 'Minimum publication date',
                        hintText: 'e.g. 2024/01/01',
                        keyboardType: TextInputType.datetime,
                        maxInputLength: 10,
                        onTap: () async {
                          // Below line stops keyboard from appearing
                          FocusScope.of(context).requestFocus(FocusNode());
                          // Show Date Picker Here
                          DateTime? picked = await _selectDate(context: context);
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
                        labelText: 'Maximum publication date',
                        hintText: 'e.g. 2024/01/31',
                        keyboardType: TextInputType.datetime,
                        maxInputLength: 10,
                        onTap: () async {
                          // Below line stops keyboard from appearing
                          FocusScope.of(context).requestFocus(FocusNode());
                          // Show Date Picker Here
                          DateTime? picked = await _selectDate(context: context);
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: BloqoSeasaltContainer(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 10, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                  child: Text(
                                    'Public\nCourses',
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontSize: 13,
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
                    ),
                    Flexible(
                      child: BloqoSeasaltContainer(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 20, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                  child: Text(
                                    'Private\nCourses',
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontSize: 13,
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
                    ),
                  ],
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
                            'You can also filter by tag.',
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
                                    color: Color(0xFFFF0000),
                                    size: 24,
                                  ),
                                ),
                                BloqoDropdown(
                                  controller: subjectTagController,
                                  dropdownMenuEntries: subjectTags,
                                  initialSelection: subjectTags[0].value,
                                  label: "Subject Tag"
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
                                    color: Color(0xFF0000FF),
                                    size: 24,
                                  ),
                                ),
                                BloqoDropdown(
                                  controller: durationTagController,
                                  dropdownMenuEntries: durationTags,
                                  initialSelection: durationTags[0].value,
                                  label: "Duration Tag"
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
                                BloqoDropdown(
                                  controller: modalityTagController,
                                  dropdownMenuEntries: modalityTags,
                                  initialSelection: modalityTags[0].value,
                                  label: "Modality Tag"
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
                                BloqoDropdown(
                                  controller: difficultyTagController,
                                  dropdownMenuEntries: difficultyTags,
                                  initialSelection: difficultyTags[0].value,
                                  label: "Difficulty Tag"
                                )
                              ],
                            ),
                          ),
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
                            'Finally, you can sort your results.',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: BloqoColors.russianViolet
                            )
                          ),
                        ),
                        BloqoDropdown(
                          controller: sortByController,
                          dropdownMenuEntries: sortingOptions,
                          label: "Sort by",
                          initialSelection: sortingOptions[0].value,
                        )
                      ]
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Center(
                    child: BloqoTextButton(
                      color: BloqoColors.error,
                      onPressed: () => _resetSearchCriteria(),
                      text: "Reset Search Criteria",
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
                      text: 'Scan QR Code',
                      fontSize: 16
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: BloqoFilledButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Container()
                            )
                        );
                      },
                      color: BloqoColors.russianViolet,
                      text: 'Search',
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

  void _resetSearchCriteria(){

    setState(() {
      courseNameController.text = "";
      authorUsernameController.text = "";
      minimumPublicationDateController.text = "";
      maximumPublicationDateController.text = "";

      publicCoursesToggle.reset();
      privateCoursesToggle.reset();

      subjectTagController.text = "None";
      durationTagController.text = "None";
      modalityTagController.text = "None";
      difficultyTagController.text = "None";
      sortByController.text = "None";
    });

  }

}

Future<DateTime?> _selectDate({required BuildContext context}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2024),
    lastDate: DateTime(2100),
    keyboardType: TextInputType.datetime,
  );
  return picked;
}