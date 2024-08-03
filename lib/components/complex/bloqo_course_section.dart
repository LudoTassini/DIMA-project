import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/courses/bloqo_section.dart';
import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class BloqoCourseSection extends StatelessWidget{
  const BloqoCourseSection({
    super.key,
    required this.onPressed,
    required this.section,
    required this.index,
  });

  final Function() onPressed;
  final BloqoSection section;
  final int index;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;

    return BloqoSeasaltContainer(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8)),
          backgroundColor: WidgetStateProperty.resolveWith((states) => BloqoColors.seasalt),
          shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: BloqoColors.russianViolet,
              width: 3,
            ),
          )),
        ),
        onPressed: onPressed,
        child: Column(
          children: [
            Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                child: Text(
                  '${localizedText.section} ${index+1}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 14,
                    color: BloqoColors.russianViolet,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                  child: Text(
                    section.name,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 18,
                      color: BloqoColors.russianViolet,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
            const Column(
            children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 5, 5, 5),
              child: Icon(
                Icons.play_circle,
                color: BloqoColors.russianViolet,
                size: 24,
              ),
            ),
            ],
            ),
          ],
        ),
        ],
      ),
      ),
    );
  }
}