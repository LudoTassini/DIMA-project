import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/model/bloqo_published_course.dart';
import 'package:flutter/material.dart';

class ViewStatisticsPage extends StatelessWidget {
  const ViewStatisticsPage({
    super.key,
    required this.publishedCourse
  });

  final BloqoPublishedCourse publishedCourse;

  @override
  Widget build(BuildContext context) {
    return BloqoMainContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                publishedCourse.courseName,
                style: Theme.of(context).textTheme.displayLarge
              )
            ]
          )
        )
    );
  }



}