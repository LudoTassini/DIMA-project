import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/complex/bloqo_editable_quiz_answer.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
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
import '../../model/courses/bloqo_block.dart';
import '../../model/courses/bloqo_course.dart';
import '../../model/courses/bloqo_section.dart';
import '../../style/bloqo_colors.dart';
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
  final BloqoBlock block;

  @override
  State<EditQuizBlockPage> createState() => _EditQuizBlockPageState();
}

class _EditQuizBlockPageState extends State<EditQuizBlockPage> with AutomaticKeepAliveClientMixin<EditQuizBlockPage> {

  bool firstBuild = true;
  bool callbackAdded = false;

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
    quizTypeController = TextEditingController();
    multipleChoiceQuestionController = TextEditingController();
    openQuestionController = TextEditingController();
    openQuestionAnswerController = TextEditingController();
  }

  void _onQuizTypeChanged() {
    setState(() {});
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
    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Consumer<EditorCourseAppState>(
        builder: (context, editorCourseAppState, _) {

          BloqoCourse course = getEditorCourseFromAppState(context: context)!;
          BloqoChapter chapter = getEditorCourseChapterFromAppState(context: context, chapterId: widget.chapterId)!;
          BloqoSection section = getEditorCourseSectionFromAppState(context: context, chapterId: widget.chapterId, sectionId: widget.sectionId)!;
          BloqoBlock block = getEditorCourseBlockFromAppState(context: context, sectionId: widget.sectionId, blockId: widget.block.id)!;
          List<DropdownMenuEntry<String>> quizTypes = buildQuizTypesList(localizedText: localizedText);

          if(firstBuild && block.type != null) {

            quizTypeController.text = quizTypes.where((entry) => entry.label ==
                BloqoBlockTypeExtension.fromString(block.type!)!.quizShortText(
                    localizedText: localizedText)!).first.label;

            if(BloqoBlockTypeExtension.fromString(block.type!) == BloqoBlockType.quizMultipleChoice) {
              int startIndex = block.content.indexOf("q:");
              int endIndex = block.content.indexOf("\$a:");

              if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
                String question = block.content.substring(startIndex + 2, endIndex);
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
            else{
              int startIndex = block.content.indexOf("q:");
              RegExp answerRegExp = RegExp(r"\$a<([yn]{2})>:");
              RegExpMatch? answerMatch = answerRegExp.firstMatch(block.content);
              String question = "", answer = "", letters = "";

              if (startIndex != -1 && answerMatch != null && startIndex < answerMatch.start) {
                int endIndex = answerMatch.start;
                question = block.content.substring(startIndex + 2, endIndex).trim();

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

            firstBuild = false;

          }

          if(!callbackAdded){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              quizTypeController.addListener(_onQuizTypeChanged);
            });
            callbackAdded = true;
          }

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
                  child: Column(
                    children: [
                      BloqoSeasaltContainer(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  localizedText.choose_quiz_type,
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: BloqoColors.russianViolet,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                                children:[
                                  Expanded(
                                      child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                          child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double availableWidth = constraints.maxWidth;
                                                return Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      BloqoDropdown(
                                                          controller: quizTypeController,
                                                          dropdownMenuEntries: quizTypes,
                                                          initialSelection: quizTypeController.text == "" ? quizTypes[0].value : quizTypeController.text,
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
                              if(quizTypeController.text == BloqoBlockType.quizMultipleChoice.quizShortText(localizedText: localizedText))
                                Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            localizedText.enter_question,
                                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                              color: BloqoColors.russianViolet,
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
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            localizedText.enter_possible_answers,
                                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                              color: BloqoColors.russianViolet,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if(multipleChoiceControllers.isEmpty)
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                          child: Text(
                                            localizedText.edit_block_quiz_page_no_answers,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: BloqoColors.primaryText,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      if(multipleChoiceControllers.isNotEmpty)
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                              multipleChoiceControllers.length,
                                                  (index) {
                                                TextEditingController controller = multipleChoiceControllers[index];
                                                Toggle toggle = multipleChoiceToggles[index];
                                                return BloqoEditableQuizAnswer(
                                                    controller: controller,
                                                    toggle: toggle,
                                                    answerNumber: index + 1,
                                                    onDelete: () => _deleteAnswer(index: index)
                                                );
                                              }
                                          ),
                                        ),
                                      Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 30),
                                          child: BloqoFilledButton(
                                              color: BloqoColors.russianViolet,
                                              onPressed: () => _addAnswer(),
                                              text: localizedText.add_answer,
                                              icon: Icons.add
                                          )
                                      ),
                                      Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                          child: BloqoFilledButton(
                                              color: BloqoColors.russianViolet,
                                              onPressed: () async {
                                                await _trySaveMultipleChoiceQuizChanges(
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
                              if(quizTypeController.text == BloqoBlockType.quizOpenQuestion.quizShortText(localizedText: localizedText))
                                Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            localizedText.enter_question,
                                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                              color: BloqoColors.russianViolet,
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
                                            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            localizedText.enter_answer,
                                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                              color: BloqoColors.russianViolet,
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
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0)
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Wrap(
                                          runSpacing: 10,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    localizedText.trim_extra_whitespaces,
                                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                        color: BloqoColors.russianViolet,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500
                                                    )
                                                  )
                                                ),
                                                BloqoSwitch(
                                                  value: trimToggle
                                                )
                                              ]
                                            ),
                                            Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      localizedText.comparison_ignore_case,
                                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                        color: BloqoColors.russianViolet,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500
                                                      )
                                                    )
                                                  ),
                                                  BloqoSwitch(
                                                      value: ignoreCaseToggle
                                                  )
                                                ]
                                            )
                                          ]
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                          child: BloqoFilledButton(
                                              color: BloqoColors.russianViolet,
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
    if(multipleChoiceQuestionController.text == ""){
      throw BloqoException(message: localizedText.question_not_empty_error);
    }
    if(multipleChoiceControllers.isEmpty){
      throw BloqoException(message: localizedText.no_answers_error);
    }
    for(TextEditingController answerController in multipleChoiceControllers){
      if(answerController.text == ""){
        throw BloqoException(message: localizedText.answer_not_empty_error);
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

  Future<void> _trySaveMultipleChoiceQuizChanges({required BuildContext context, required var localizedText, required String courseId, required String sectionId, required BloqoBlock block}) async {
    context.loaderOverlay.show();
    try{

      String content = _generateContentStringForMultipleChoiceQuiz(localizedText: localizedText);

      block.content = content;
      block.name = getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.quizMultipleChoice);
      block.type = BloqoBlockType.quizMultipleChoice.toString();

      await saveBlockMultipleChoiceQuiz(localizedText: localizedText, blockId: block.id, content: content);

      if (!context.mounted) return;
      BloqoUserCourseCreated userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((course) => course.courseId == courseId).first;
      updateEditorCourseBlockInAppState(context: context, sectionId: sectionId, block: block);

      await saveUserCourseCreatedChanges(localizedText: localizedText, updatedUserCourseCreated: userCourseCreated);

      if (!context.mounted) return;
      context.loaderOverlay.hide();

      ScaffoldMessenger.of(context).showSnackBar(
        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
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
    if(openQuestionController.text == ""){
      throw BloqoException(message: localizedText.question_not_empty_error);
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

  Future<void> _trySaveOpenQuestionQuizChanges({required BuildContext context, required var localizedText, required String courseId, required String sectionId, required BloqoBlock block}) async {
    context.loaderOverlay.show();
    try{

      String content = _generateContentStringForOpenQuestionQuiz(localizedText: localizedText);

      block.content = content;
      block.name = getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.quizOpenQuestion);
      block.type = BloqoBlockType.quizOpenQuestion.toString();

      await saveBlockOpenQuestionQuiz(localizedText: localizedText, blockId: block.id, content: content);

      if (!context.mounted) return;
      BloqoUserCourseCreated userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((course) => course.courseId == courseId).first;
      updateEditorCourseBlockInAppState(context: context, sectionId: sectionId, block: block);

      await saveUserCourseCreatedChanges(localizedText: localizedText, updatedUserCourseCreated: userCourseCreated);

      if (!context.mounted) return;
      context.loaderOverlay.hide();

      ScaffoldMessenger.of(context).showSnackBar(
        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
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