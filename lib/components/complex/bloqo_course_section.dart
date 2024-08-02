import 'package:bloqo/model/courses/bloqo_section.dart';
import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';

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
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8)),
            backgroundColor: WidgetStateProperty.resolveWith((states) => BloqoColors.seasalt),
            shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 10, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                        child: Text(
                          'Section $index',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 12,
                            color: BloqoColors.russianViolet,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 50, 10),
                        child: Text(
                          section.name,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 18,
                            color: BloqoColors.russianViolet,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 5, 5),
                child: Icon(
                  Icons.play_circle,
                  color: BloqoColors.russianViolet,
                  size: 24,
                ),
              ),
            ],
          ),
        )
    );
  }
}