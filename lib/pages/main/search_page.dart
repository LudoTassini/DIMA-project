import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/components/navigation/bloqo_app_bar.dart';
import 'package:bloqo/components/navigation/bloqo_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../style/app_colors.dart';
import '../../utils/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.title});

  final String title;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final formKeyCourseName = GlobalKey<FormState>();
  final formKeyAuthorUsername = GlobalKey<FormState>();
  final formKeyMinimumPublicationDate = GlobalKey<FormState>();
  final formKeyMaximumPublicationDate = GlobalKey<FormState>();

  late TextEditingController courseNameController;
  late TextEditingController authorUsernameController;
  late TextEditingController minimumPublicationDateController;
  late TextEditingController maximumPublicationDateController;

  @override
  void initState() {
    super.initState();
    courseNameController = TextEditingController();
    authorUsernameController = TextEditingController();
    minimumPublicationDateController = TextEditingController();
    maximumPublicationDateController = TextEditingController();
  }

  @override
  void dispose() {
    courseNameController.dispose();
    authorUsernameController.dispose();
    minimumPublicationDateController.dispose();
    maximumPublicationDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BloqoAppBar.get(context: context, title: widget.title),
      bottomNavigationBar: const BloqoNavBar(),
      body: // Generated code for this Column Widget...
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                      child: Text(
                        'Tell us what you are looking for.',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.seasalt,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                      child: Text(
                        'Every field is optional. Freely choose your filters and sorting options.',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.seasalt,
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
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
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
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
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Form(
                        key: formKeyMinimumPublicationDate,
                        child: BloqoTextField(
                          formKey: formKeyMinimumPublicationDate,
                          controller: minimumPublicationDateController,
                          labelText: 'Minimum publication date',
                          hintText: 'e.g. 01/01/2024',
                          keyboardType: TextInputType.datetime,
                          maxInputLength: 10,
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Form(
                        key: formKeyMaximumPublicationDate,
                        child: BloqoTextField(
                          formKey: formKeyMaximumPublicationDate,
                          controller: maximumPublicationDateController,
                          labelText: 'Maximum publication date',
                          hintText: 'e.g. 01/01/2024',
                          keyboardType: TextInputType.datetime,
                          maxInputLength: 10,
                        )
                    ),
                  ),
                  /*Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 10, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 10),
                                      child: Text(
                                        'Public Courses',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 14,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Switch.adaptive(
                                    value: _model.switchValue1 ??= true,
                                    onChanged: (newValue) async {
                                      setState(
                                              () => _model.switchValue1 = newValue!);
                                    },
                                    activeColor:
                                    FlutterFlowTheme.of(context).russianViolet2,
                                    activeTrackColor:
                                    FlutterFlowTheme.of(context).russianViolet2,
                                    inactiveTrackColor:
                                    FlutterFlowTheme.of(context).alternate,
                                    inactiveThumbColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 20, 20, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 10, 0, 10),
                                      child: Text(
                                        'Private Courses',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Switch.adaptive(
                                    value: _model.switchValue2 ??= false,
                                    onChanged: (newValue) async {
                                      setState(
                                              () => _model.switchValue2 = newValue!);
                                    },
                                    activeColor:
                                    FlutterFlowTheme.of(context).russianViolet2,
                                    activeTrackColor:
                                    FlutterFlowTheme.of(context).russianViolet2,
                                    inactiveTrackColor:
                                    FlutterFlowTheme.of(context).alternate,
                                    inactiveThumbColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose your tags:',
                              style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',
                                fontSize: 18,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 5, 0),
                                          child: Icon(
                                            Icons.label,
                                            color: Color(0xFFFF0000),
                                            size: 24,
                                          ),
                                        ),
                                        Text(
                                          'Subject Tag',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 150,
                                      ),
                                      decoration: BoxDecoration(),
                                      child: FlutterFlowDropDown<String>(
                                        controller:
                                        _model.dropDownValueController1 ??=
                                            FormFieldController<String>(null),
                                        options: [
                                          'none',
                                          'Math',
                                          'Computer Science'
                                        ],
                                        onChanged: (val) => setState(
                                                () => _model.dropDownValue1 = val),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0,
                                        ),
                                        hintText: 'Click here to select...',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2,
                                        borderColor: FlutterFlowTheme.of(context)
                                            .russianViolet2,
                                        borderWidth: 2,
                                        borderRadius: 8,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 16, 0),
                                        hidesUnderline: true,
                                        isOverButton: true,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 5, 0),
                                          child: Icon(
                                            Icons.label,
                                            color: Color(0xFF0000FF),
                                            size: 24,
                                          ),
                                        ),
                                        Text(
                                          'Duration Tag',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 150,
                                      ),
                                      decoration: BoxDecoration(),
                                      child: FlutterFlowDropDown<String>(
                                        controller:
                                        _model.dropDownValueController2 ??=
                                            FormFieldController<String>(null),
                                        options: [
                                          'none',
                                          'Math',
                                          'Computer Science'
                                        ],
                                        onChanged: (val) => setState(
                                                () => _model.dropDownValue2 = val),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0,
                                        ),
                                        hintText: 'Click here to select...',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2,
                                        borderColor: FlutterFlowTheme.of(context)
                                            .russianViolet2,
                                        borderWidth: 2,
                                        borderRadius: 8,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 16, 0),
                                        hidesUnderline: true,
                                        isOverButton: true,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 5, 0),
                                          child: Icon(
                                            Icons.label,
                                            color: Color(0xFF00FF00),
                                            size: 24,
                                          ),
                                        ),
                                        Text(
                                          'Modality Tag',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 150,
                                      ),
                                      decoration: BoxDecoration(),
                                      child: FlutterFlowDropDown<String>(
                                        controller:
                                        _model.dropDownValueController3 ??=
                                            FormFieldController<String>(null),
                                        options: [
                                          'none',
                                          'Math',
                                          'Computer Science'
                                        ],
                                        onChanged: (val) => setState(
                                                () => _model.dropDownValue3 = val),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0,
                                        ),
                                        hintText: 'Click here to select...',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2,
                                        borderColor: FlutterFlowTheme.of(context)
                                            .russianViolet2,
                                        borderWidth: 2,
                                        borderRadius: 8,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 16, 0),
                                        hidesUnderline: true,
                                        isOverButton: true,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 5, 0),
                                          child: Icon(
                                            Icons.label,
                                            color: Color(0xFFFFFF00),
                                            size: 24,
                                          ),
                                        ),
                                        Text(
                                          'Difficulty Tag',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 150,
                                      ),
                                      decoration: BoxDecoration(),
                                      child: FlutterFlowDropDown<String>(
                                        controller:
                                        _model.dropDownValueController4 ??=
                                            FormFieldController<String>(
                                              _model.dropDownValue4 ??= 'Basic',
                                            ),
                                        options: [
                                          'none',
                                          'Basic',
                                          'Intermediate',
                                          'Advanced'
                                        ],
                                        onChanged: (val) => setState(
                                                () => _model.dropDownValue4 = val),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0,
                                        ),
                                        hintText: 'Click here to select...',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2,
                                        borderColor: FlutterFlowTheme.of(context)
                                            .russianViolet2,
                                        borderWidth: 2,
                                        borderRadius: 8,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 16, 0),
                                        hidesUnderline: true,
                                        isOverButton: true,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                                  child: Text(
                                    'Sort by:',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 18,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 300,
                                    ),
                                    decoration: BoxDecoration(),
                                    child: FlutterFlowDropDown<String>(
                                      controller:
                                      _model.dropDownValueController5 ??=
                                          FormFieldController<String>(
                                            _model.dropDownValue5 ??=
                                            'Publication date (latest first)',
                                          ),
                                      options: [
                                        'Publication date (latest first)',
                                        'Publication date (oldest first)',
                                        'Course name (A -> Z)',
                                        'Course name (Z -> A)',
                                        'Author name (A -> Z)',
                                        'Author name (Z -> A)',
                                        'Best rated'
                                      ],
                                      onChanged: (val) => setState(
                                              () => _model.dropDownValue5 = val),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                      hintText: 'Click here to select...',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24,
                                      ),
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      elevation: 2,
                                      borderColor: FlutterFlowTheme.of(context)
                                          .russianViolet2,
                                      borderWidth: 2,
                                      borderRadius: 8,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          16, 0, 16, 0),
                                      hidesUnderline: true,
                                      isOverButton: true,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: 'Reset Search Criteria',
                          icon: Icon(
                            Icons.restart_alt_sharp,
                            size: 15,
                          ),
                          options: FFButtonOptions(
                            height: 40,
                            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).error,
                            textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
            child: Container(
              decoration: BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: 'Scan QR Code',
                        icon: Icon(
                          Icons.qr_code,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40,
                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).chineseViolet2,
                          textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                            letterSpacing: 0,
                          ),
                          elevation: 3,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: 'Find',
                        icon: Icon(
                          Icons.search,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40,
                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).russianViolet2,
                          textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                            letterSpacing: 0,
                          ),
                          elevation: 3,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

}