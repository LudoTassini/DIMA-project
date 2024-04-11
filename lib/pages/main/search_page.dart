import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:flutter/material.dart';

import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/popups/bloqo_date_picker.dart';
import '../../style/app_colors.dart';
import '../../utils/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

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
    return BloqoMainContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Text(
                    'Every field is optional. Freely choose your filters and sorting options.',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.seasalt,
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
                        hintText: 'e.g. 01/01/2024',
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
                              minimumPublicationDateController.text = picked.toString();
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
                        hintText: 'e.g. 01/01/2024',
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
                              maximumPublicationDateController.text = picked.toString();
                            }
                          });
                        }
                      )
                  ),
                ),
              ]
            )
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                    child: BloqoFilledButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Container()
                          )
                        );
                      },
                      color: AppColors.chineseViolet,
                      text: 'Scan QR Code',
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: BloqoFilledButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Container()
                            )
                        );
                      },
                      color: AppColors.russianViolet,
                      text: 'Find',
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

}

Future<DateTime?> _selectDate({required BuildContext context}) async {
  final DateTime picked = await showBloqoDatePicker(context: context);
  return picked;
}