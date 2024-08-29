import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/complex/bloqo_editable_quiz_answer.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_created_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/text_validator.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/editor_course_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/forms/bloqo_switch.dart';
import '../../components/forms/bloqo_text_field.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/bloqo_block_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../model/courses/bloqo_section_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../../utils/toggle.dart';

class EditQuizBlockPage extends StatefulWidget {
  const EditQuizBlockPage({
    super.key,
    required this.onPush,
    required this.courseId,
    required this.chapterId,
    required this.sectionId,
    required this.block
  });

  final void Function(Widget) onPush;
  final String courseId;
  final String chapterId;
  final String sectionId;
  final BloqoBlockData block;

  @override
  State<EditQuizBlockPage> createState() => _EditQuizBlockPageState();
}

class _EditQuizBlockPageState extends State<EditQuizBlockPage> with AutomaticKeepAliveClientMixin<EditQuizBlockPage> {

  late bool firstBuild;
  late bool callbackAdded;

  final formKeyMultipleChoiceQuestion = GlobalKey<FormState>();
  final formKeyOpenQuestion = GlobalKey<FormState>();
  final formKeyOpenQuestionAnswer = GlobalKey<FormState>();

  late TextEditingController quizTypeController;

  late TextEditingController openQuestionController;
  late TextEditingController openQuestionAnswerController;
  Toggle trimToggle = Toggle(initialValue: true);
  Toggle ignoreCaseToggle = Toggle(initialValue: false);

  late TextEditingController multipleChoiceQuestionController;
  List<TextEditingController> multipleChoiceControllers = [];
  List<Toggle> multipleChoiceToggles = [];
  Toggle multipleAnswersToggle = Toggle(initialValue: false);

  @override
  void initState() {
    super.initState();
    firstBuild = true;
    callbackAdded = false;
    quizTypeController = TextEditingController();
    multipleChoiceQuestionController = TextEditingController();
    openQuestionController = TextEditingController();
    openQuestionAnswerController = TextEditingController();
  }

  void _onQuizTypeChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void initializeAnswers(String answerSingleString) {
    RegExp regex = RegExp(r"<([ny])>");
    Iterable<RegExpMatch> matches = regex.allMatches(answerSingleString);

    int startIndex = 0;

    for (RegExpMatch match in matches) {
      int delimiterIndex = match.start;

      String delimiterContent = match.group(1)!;
      bool initialValue = delimiterContent == 'y';
      multipleChoiceToggles.add(
        Toggle(
          initialValue: initialValue,
        ),
      );

      if (delimiterIndex > startIndex) {
        String answer = answerSingleString.substring(startIndex, delimiterIndex);
        multipleChoiceControllers.add(TextEditingController(text: answer));
      }

      startIndex = delimiterIndex + match.group(0)!.length;
    }

    if (startIndex < answerSingleString.length) {
      String remainingText = answerSingleString.substring(startIndex);
      multipleChoiceControllers.add(TextEditingController(text: remainingText));
    }
  }

  @override
  void dispose() {
    for(TextEditingController controller in multipleChoiceControllers){
      controller.dispose();
    }
    multipleChoiceQuestionController.dispose();
    openQuestionController.dispose();
    openQuestionAnswerController.dispose();
    quizTypeController.removeListener(_onQuizTypeChanged);
    quizTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    bool isTablet = checkDevice(context);

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          var theme = getAppThemeFromAppState(context: context);
          return BloqoMainContainer(
            alignment: const AlignmentDirectional(-1.0, -1.0),
            child: Consumer<EditorCourseAppState>(
              builder: (context, editorCourseAppState, _) {
                BloqoCourseData course = getEditorCourseFromAppState(
                    context: context)!;
                BloqoChapterData chapter = getEditorCourseChapterFromAppState(
                    context: context, chapterId: widget.chapterId)!;
                BloqoSectionData section = getEditorCourseSectionFromAppState(
                    context: context,
                    chapterId: widget.chapterId,
                    sectionId: widget.sectionId)!;
                BloqoBlockData block = getEditorCourseBlockFromAppState(
                    context: context,
                    sectionId: widget.sectionId,
                    blockId: widget.block.id)!;
                List<DropdownMenuEntry<String>> quizTypes = buildQuizTypesList(
                    localizedText: localizedText);

                if (firstBuild && block.type != null &&
                    multipleChoiceControllers.isEmpty) {
                  quizTypeController.text = quizTypes.where((entry) =>
                  entry.label ==
                      BloqoBlockTypeExtension.fromString(block.type!)!
                          .quizShortText(
                          localizedText: localizedText)!).first.label;

                  if (BloqoBlockTypeExtension.fromString(block.type!) ==
                      BloqoBlockType.quizMultipleChoice) {
                    int startIndex = block.content.indexOf("q:");
                    int endIndex = block.content.indexOf("\$a:");

                    if (startIndex != -1 && endIndex != -1 &&
                        startIndex < endIndex) {
                      String question = block.content.substring(
                          startIndex + 2, endIndex);
                      multipleChoiceQuestionController.text = question;
                    }

                    String startAnswerSequence = "\$a:";
                    startIndex = block.content.indexOf(startAnswerSequence);
                    if (startIndex != -1) {
                      startIndex += startAnswerSequence.length;
                      String substring = block.content.substring(startIndex);
                      initializeAnswers(substring);
                    }
                  }
                  else {
                    int startIndex = block.content.indexOf("q:");
                    RegExp answerRegExp = RegExp(r"\$a<([yn]{2})>:");
                    RegExpMatch? answerMatch = answerRegExp.firstMatch(
                        block.content);
                    String question = "",
                        answer = "",
                        letters = "";

                    if (startIndex != -1 && answerMatch != null &&
                        startIndex < answerMatch.start) {
                      int endIndex = answerMatch.start;
                      question =
                          block.content.substring(startIndex + 2, endIndex).trim();

                      int answerStartIndex = answerMatch.end;
                      answer = block.content.substring(answerStartIndex).trim();

                      letters = answerMatch.group(1)!;
                    }

                    openQuestionController.text = question;
                    openQuestionAnswerController.text = answer;

                    bool trimValue = letters[0] == "y";
                    bool ignoreCaseValue = letters[1] == "y";

                    if (trimToggle.get() != trimValue) {
                      trimToggle.toggle();
                    }
                    if (ignoreCaseToggle.get() != ignoreCaseValue) {
                      ignoreCaseToggle.toggle();
                    }
                  }
                }

                firstBuild = false;

                if (!callbackAdded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    quizTypeController.addListener(_onQuizTypeChanged);
                  });
                  callbackAdded = true;
                }

                bool editable = !course.published;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BloqoBreadcrumbs(breadcrumbs: [
                      course.name,
                      chapter.name,
                      section.name,
                      block.name,
                    ]),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Padding(
                            padding: !isTablet
                                ? const EdgeInsetsDirectional.all(0)
                                : Constants.tabletPadding,
                            child: Column(
                              children: [
                                if(editable)
                                  BloqoSeasaltContainer(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20, 20, 20, 0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20, 20, 20, 0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              localizedText.choose_quiz_type,
                                              style: theme
                                                  .getThemeData()
                                                  .textTheme
                                                  .displayLarge
                                                  ?.copyWith(
                                                color: theme.colors.leadingColor,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                            children: [
                                              Expanded(
                                                  child: Padding(
                                                      padding: const EdgeInsetsDirectional
                                                          .fromSTEB(20, 20, 20, 20),
                                                      child: LayoutBuilder(
                                                          builder: (
                                                              BuildContext context,
                                                              BoxConstraints constraints) {
                                                            double availableWidth = constraints
                                                                .maxWidth;
                                                            return Column(
                                                                mainAxisSize: MainAxisSize
                                                                    .max,
                                                                children: [
                                                                  BloqoDropdown(
                                                                      controller: quizTypeController,
                                                                      dropdownMenuEntries: quizTypes,
                                                                      initialSelection: quizTypeController
                                                                          .text ==
                                                                          ""
                                                                          ? quizTypes[0]
                                                                          .value
                                                                          : quizTypeController
                                                                          .text,
                                                                      width: availableWidth
                                                                  )
                                                                ]
                                                            );
                                                          }
                                                      )
                                                  )
                                              )
                                            ]
                                        ),
                                      ],
                                    ),
                                  ),
                                BloqoSeasaltContainer(
                                    child: Column(
                                        children: [
                                          if(quizTypeController.text ==
                                              BloqoBlockType.quizMultipleChoice
                                                  .quizShortText(
                                                  localizedText: localizedText))
                                            Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(20, 20, 20, 0),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        localizedText
                                                            .enter_question,
                                                        style: theme
                                                            .getThemeData()
                                                            .textTheme
                                                            .displayLarge
                                                            ?.copyWith(
                                                          color: theme.colors
                                                              .leadingColor,
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Form(
                                                    key: formKeyMultipleChoiceQuestion,
                                                    child: BloqoTextField(
                                                        formKey: formKeyMultipleChoiceQuestion,
                                                        controller: multipleChoiceQuestionController,
                                                        labelText: localizedText.question,
                                                        hintText: localizedText.enter_question_here,
                                                        maxInputLength: Constants.maxQuizQuestionLength,
                                                        isTextArea: true,
                                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                                        isDisabled: !editable,
                                                        validator: (String? value) { return quizQuestionValidator(quizQuestion: value, localizedText: localizedText); },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(20, 20, 20, 0),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        localizedText
                                                            .enter_possible_answers,
                                                        style: theme
                                                            .getThemeData()
                                                            .textTheme
                                                            .displayLarge
                                                            ?.copyWith(
                                                          color: theme.colors
                                                              .leadingColor,
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if(multipleChoiceControllers
                                                      .isEmpty)
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional
                                                          .fromSTEB(20, 10, 20, 0),
                                                      child: Text(
                                                        localizedText
                                                            .edit_block_quiz_page_no_answers,
                                                        style: theme
                                                            .getThemeData()
                                                            .textTheme
                                                            .displaySmall
                                                            ?.copyWith(
                                                          color: theme.colors
                                                              .primaryText,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  if(multipleChoiceControllers
                                                      .isNotEmpty)
                                                    Column(
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      children: List.generate(
                                                          multipleChoiceControllers
                                                              .length,
                                                              (index) {
                                                            TextEditingController controller = multipleChoiceControllers[index];
                                                            Toggle toggle = multipleChoiceToggles[index];
                                                            return BloqoEditableQuizAnswer(
                                                                controller: controller,
                                                                toggle: toggle,
                                                                answerNumber: index +
                                                                    1,
                                                                editable: editable,
                                                                padding: !editable &&
                                                                    index ==
                                                                        multipleChoiceControllers
                                                                            .length -
                                                                            1
                                                                    ? const EdgeInsetsDirectional
                                                                    .all(15)
                                                                    : const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    15, 15, 15, 0),
                                                                onDelete: () =>
                                                                    _deleteAnswer(
                                                                        index: index)
                                                            );
                                                          }
                                                      ),
                                                    ),
                                                  if(editable)
                                                    Padding(
                                                        padding: const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            20, 20, 20, 30),
                                                        child: BloqoFilledButton(
                                                            color: theme.colors
                                                                .leadingColor,
                                                            onPressed: () =>
                                                                _addAnswer(),
                                                            text: localizedText
                                                                .add_answer,
                                                            icon: Icons.add
                                                        )
                                                    ),
                                                  if(editable)
                                                    Padding(
                                                        padding: const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            20, 20, 20, 20),
                                                        child: BloqoFilledButton(
                                                            color: theme.colors
                                                                .leadingColor,
                                                            fontSize: !isTablet
                                                                ? Constants
                                                                .fontSizeNotTablet
                                                                : Constants
                                                                .fontSizeTablet,
                                                            height: !isTablet
                                                                ? Constants
                                                                .heightNotTablet
                                                                : Constants
                                                                .heightTablet,
                                                            onPressed: () async {
                                                              await _trySaveMultipleChoiceQuizChanges(
                                                                  context: context,
                                                                  localizedText: localizedText,
                                                                  courseId: course
                                                                      .id,
                                                                  sectionId: section
                                                                      .id,
                                                                  block: widget
                                                                      .block
                                                              );
                                                            },
                                                            text: localizedText
                                                                .save_quiz_changes,
                                                            icon: Icons.edit
                                                        )
                                                    ),
                                                ]
                                            ),
                                          if(quizTypeController.text ==
                                              BloqoBlockType.quizOpenQuestion
                                                  .quizShortText(
                                                  localizedText: localizedText))
                                            Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(20, 20, 20, 0),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        localizedText
                                                            .enter_question,
                                                        style: theme
                                                            .getThemeData()
                                                            .textTheme
                                                            .displayLarge
                                                            ?.copyWith(
                                                          color: theme.colors
                                                              .leadingColor,
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Form(
                                                    key: formKeyOpenQuestion,
                                                    child: BloqoTextField(
                                                        formKey: formKeyOpenQuestion,
                                                        controller: openQuestionController,
                                                        labelText: localizedText.question,
                                                        hintText: localizedText.enter_question_here,
                                                        maxInputLength: Constants.maxQuizQuestionLength,
                                                        isTextArea: true,
                                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                                        isDisabled: !editable,
                                                        validator: (String? value) { return quizQuestionValidator(quizQuestion: value, localizedText: localizedText); },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(20, 20, 20, 0),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        localizedText.enter_answer,
                                                        style: theme
                                                            .getThemeData()
                                                            .textTheme
                                                            .displayLarge
                                                            ?.copyWith(
                                                          color: theme.colors
                                                              .leadingColor,
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Form(
                                                      key: formKeyOpenQuestionAnswer,
                                                      child: BloqoTextField(
                                                          formKey: formKeyOpenQuestionAnswer,
                                                          controller: openQuestionAnswerController,
                                                          labelText: localizedText.answer,
                                                          hintText: localizedText.enter_answer_here,
                                                          maxInputLength: Constants.maxQuizAnswerLength,
                                                          isTextArea: true,
                                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                                          isDisabled: !editable
                                                      )
                                                  ),
                                                  Padding(
                                                    padding: editable
                                                        ? const EdgeInsetsDirectional
                                                        .fromSTEB(20, 20, 20, 0)
                                                        : const EdgeInsetsDirectional
                                                        .all(20),
                                                    child: Wrap(
                                                        runSpacing: 10,
                                                        children: [
                                                          Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        localizedText.trim_extra_whitespaces,
                                                                        style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                                                            color: theme.colors.leadingColor,
                                                                            fontSize: 18,
                                                                            fontWeight: FontWeight.w500
                                                                        )
                                                                    )
                                                                ),
                                                                BloqoSwitch(
                                                                  value: trimToggle,
                                                                  editable: editable,
                                                                )
                                                              ]
                                                          ),
                                                          Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        localizedText.comparison_ignore_case,
                                                                        style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                                                            color: theme.colors.leadingColor,
                                                                            fontSize: 18,
                                                                            fontWeight: FontWeight.w500
                                                                        )
                                                                    )
                                                                ),
                                                                BloqoSwitch(
                                                                  value: ignoreCaseToggle,
                                                                  editable: editable,
                                                                )
                                                              ]
                                                          )
                                                        ]
                                                    ),
                                                  ),
                                                  if(editable)
                                                    Padding(
                                                        padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20) : Constants.tabletPaddingBloqoFilledButton,
                                                        child: BloqoFilledButton(
                                                            color: theme.colors.leadingColor,
                                                            fontSize: !isTablet ? Constants.fontSizeNotTablet : Constants.fontSizeTablet,
                                                            height: !isTablet ? Constants.heightNotTablet : Constants.heightTablet,
                                                            onPressed: () async {
                                                              await _trySaveOpenQuestionQuizChanges(
                                                                  context: context,
                                                                  localizedText: localizedText,
                                                                  courseId: course.id,
                                                                  sectionId: section.id,
                                                                  block: widget.block
                                                              );
                                                            },
                                                            text: localizedText.save_quiz_changes,
                                                            icon: Icons.edit
                                                        )
                                                    ),
                                                ]
                                            ),
                                        ]
                                    )
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _addAnswer(){
    setState(() {
      multipleChoiceControllers.add(TextEditingController());
      multipleChoiceToggles.add(Toggle(initialValue: false));
    });
  }

  void _deleteAnswer({required int index}){
    setState(() {
      multipleChoiceControllers[index].dispose();
      multipleChoiceControllers.removeAt(index);
      multipleChoiceToggles.removeAt(index);
    });
  }

  String _generateContentStringForMultipleChoiceQuiz({required var localizedText}){
    String? quizQuestionValidationResult = quizQuestionValidator(quizQuestion: multipleChoiceQuestionController.text, localizedText: localizedText);
    if(quizQuestionValidationResult != null){
      throw BloqoException(message: quizQuestionValidationResult);
    }
    if(multipleChoiceControllers.isEmpty){
      throw BloqoException(message: localizedText.no_answers_error);
    }
    for(TextEditingController answerController in multipleChoiceControllers){
      String? multipleChoiceAnswerValidationResult = multipleChoiceAnswerValidator(multipleChoiceAnswer: answerController.text, localizedText: localizedText);
      if(multipleChoiceAnswerValidationResult != null){
        throw BloqoException(message: multipleChoiceAnswerValidationResult);
      }
    }
    bool hasCorrectAnswer = false;
    for(Toggle toggle in multipleChoiceToggles){
      if(toggle.get() == true){
        hasCorrectAnswer = true;
      }
    }
    if(!hasCorrectAnswer){
      throw BloqoException(message: localizedText.no_correct_answer_error);
    }
    String question = "q:${multipleChoiceQuestionController.text}";
    String answer = "\$a:";
    for (int index = 0; index < multipleChoiceControllers.length; index++) {
      TextEditingController controller = multipleChoiceControllers[index];
      Toggle toggle = multipleChoiceToggles[index];
      String isAnswerCorrect = toggle.get() ? 'y' : 'n';
      answer += '<$isAnswerCorrect>${controller.text}';
    }
    return question + answer;
  }

  Future<void> _trySaveMultipleChoiceQuizChanges({required BuildContext context, required var localizedText, required String courseId, required String sectionId, required BloqoBlockData block}) async {
    context.loaderOverlay.show();
    try{

      String content = _generateContentStringForMultipleChoiceQuiz(localizedText: localizedText);

      block.content = content;
      block.name = getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.quizMultipleChoice);
      block.type = BloqoBlockType.quizMultipleChoice.toString();

      var firestore = getFirestoreFromAppState(context: context);

      await saveBlockMultipleChoiceQuiz(
          firestore: firestore,
          localizedText: localizedText,
          blockId: block.id,
          content: content
      );

      if (!context.mounted) return;
      BloqoUserCourseCreatedData userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((course) => course.courseId == courseId).first;
      updateEditorCourseBlockInAppState(context: context, sectionId: sectionId, block: block);

      await saveUserCourseCreatedChanges(
          firestore: firestore,
          localizedText: localizedText,
          updatedUserCourseCreated: userCourseCreated
      );

      if (!context.mounted) return;
      context.loaderOverlay.hide();

      showBloqoSnackBar(
          context: context,
          text: localizedText.done
      );
    }
    on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }

  String _generateContentStringForOpenQuestionQuiz({required var localizedText}){
    String? quizQuestionValidationResult = quizQuestionValidator(quizQuestion: openQuestionController.text, localizedText: localizedText);
    if(quizQuestionValidationResult != null){
      throw BloqoException(message: quizQuestionValidationResult);
    }
    if(openQuestionAnswerController.text == ""){
      throw BloqoException(message: localizedText.answer_not_empty_error);
    }
    String question = "q:${openQuestionController.text}";
    String trimExtraWhitespaces = trimToggle.get() == true ? "y" : "n";
    String comparisonIgnoreCase = ignoreCaseToggle.get() == true ? "y": "n";
    String answer = "\$a<$trimExtraWhitespaces$comparisonIgnoreCase>:${openQuestionAnswerController.text}";
    return question + answer;
  }

  Future<void> _trySaveOpenQuestionQuizChanges({required BuildContext context, required var localizedText, required String courseId, required String sectionId, required BloqoBlockData block}) async {
    context.loaderOverlay.show();
    try{

      String content = _generateContentStringForOpenQuestionQuiz(localizedText: localizedText);

      block.content = content;
      block.name = getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.quizOpenQuestion);
      block.type = BloqoBlockType.quizOpenQuestion.toString();

      var firestore = getFirestoreFromAppState(context: context);

      await saveBlockOpenQuestionQuiz(
          firestore: firestore,
          localizedText: localizedText,
          blockId: block.id,
          content: content
      );

      if (!context.mounted) return;
      BloqoUserCourseCreatedData userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((course) => course.courseId == courseId).first;
      updateEditorCourseBlockInAppState(context: context, sectionId: sectionId, block: block);

      await saveUserCourseCreatedChanges(
          firestore: firestore,
          localizedText: localizedText,
          updatedUserCourseCreated: userCourseCreated
      );

      if (!context.mounted) return;
      context.loaderOverlay.hide();

      showBloqoSnackBar(
          context: context,
          text: localizedText.done
      );
    }
    on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }

}