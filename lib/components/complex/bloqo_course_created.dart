import 'package:flutter/material.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../style/bloqo_colors.dart';
import '../containers/bloqo_seasalt_container.dart';

class BloqoCourseCreated extends StatelessWidget {

  const BloqoCourseCreated({
    super.key,
    required this.course,
  });

  final BloqoUserCourseCreated? course;

  @override
  Widget build(BuildContext context) {
    return BloqoSeasaltContainer(
      borderColor: BloqoColors.russianViolet,
      borderWidth: 3,
      borderRadius: 10,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: BloqoColors.russianViolet,
                            size: 24,
                          ),
                        ),
                        Text(
                          course!.courseName,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        '${course!.numChaptersCreated} chapters, ${course!.numSectionsCreated} sections',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.play_circle,
                  color: BloqoColors.russianViolet,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}