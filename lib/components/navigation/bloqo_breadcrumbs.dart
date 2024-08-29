import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class BloqoBreadcrumbs extends StatelessWidget {
  const BloqoBreadcrumbs({
    super.key,
    required this.breadcrumbs,
    this.disable,
  });

  final List<String> breadcrumbs;
  final bool? disable;

  @override
  Widget build(BuildContext context) {
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    List<List<String>> arrangeBreadcrumbs() {
      if (breadcrumbs.length == 1) {
        return [breadcrumbs]; // Single breadcrumb fully visible
      }

      double screenWidth = MediaQuery.of(context).size.width;
      TextPainter painter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
      );

      List<List<String>> rows = [];
      List<String> currentRow = [];
      double currentRowWidth = 0;

      for (var breadcrumb in breadcrumbs) {
        painter.text = TextSpan(
          text: breadcrumb,
          style: theme.getThemeData().textTheme.displayMedium!.copyWith(
            fontSize: 20,
          ),
        );
        painter.layout();

        double breadcrumbWidth = painter.width +
            (currentRow.isNotEmpty ? painter.width * 0.1 : 0); // Add chevron spacing if necessary

        if (currentRowWidth + breadcrumbWidth <= screenWidth * 0.8) {
          currentRow.add(breadcrumb);
          currentRowWidth += breadcrumbWidth;
        } else {
          if (currentRow.isNotEmpty) { // Ensure we only add non-empty rows
            rows.add(currentRow);
          }
          currentRow = [breadcrumb];
          currentRowWidth = breadcrumbWidth;
        }
      }

      if (currentRow.isNotEmpty) {
        rows.add(currentRow);
      }

      // Adjust the number of rows based on the rules you provided
      if (rows.length == 1 && rows[0].length == 3) {
        return [rows[0]];
      } else if (rows.length == 2 && breadcrumbs.length == 3) {
        return [rows[0], rows[1]];
      } else if (rows.length == 3 || (rows.length == 2 && rows[0].length < 2)) {
        return rows;
      } else if (rows.length == 2 && breadcrumbs.length == 2) {
        return [rows[0]];
      }

      return rows;
    }

    var arrangedBreadcrumbs = arrangeBreadcrumbs();

    return Padding(
      padding: !isTablet
          ? const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10)
          : Constants.tabletPaddingBreadcrumbs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(arrangedBreadcrumbs.length, (rowIndex) {
          return Row(
            children: List.generate(arrangedBreadcrumbs[rowIndex].length, (index) {
              bool isSingleBreadcrumb = breadcrumbs.length == 1;
              String breadcrumb = arrangedBreadcrumbs[rowIndex][index];

              return Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      if (index > 0 || rowIndex > 0)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.chevron_right,
                            color: theme.colors.highContrastColor,
                          ),
                        ),
                      TextSpan(
                        text: breadcrumb,
                        style: theme.getThemeData().textTheme.displayMedium!.copyWith(
                          color: theme.colors.highContrastColor,
                          fontWeight: FontWeight.w500,
                          decoration: (disable == true || (index == arrangedBreadcrumbs[rowIndex].length - 1 && rowIndex == arrangedBreadcrumbs.length - 1))
                              ? TextDecoration.none // No underline for the last breadcrumb
                              : TextDecoration.underline, // Underline for other breadcrumbs
                          decorationColor: theme.colors.highContrastColor, // Set underline color to white
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (!(disable == true || (index == arrangedBreadcrumbs[rowIndex].length - 1 && rowIndex == arrangedBreadcrumbs.length - 1))) {
                              int popCount = breadcrumbs.length - breadcrumbs.indexOf(breadcrumb) - 1;
                              for (int j = 0; j < popCount; j++) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                      ),
                    ],
                  ),
                  overflow: isSingleBreadcrumb ? TextOverflow.visible : TextOverflow.ellipsis,
                  maxLines: isSingleBreadcrumb ? null : 1,
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}