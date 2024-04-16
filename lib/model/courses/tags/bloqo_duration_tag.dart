import 'bloqo_course_tag.dart';

class BloqoDurationTag extends BloqoCourseTag{

  BloqoDurationTag({super.type = BloqoCourseTagType.duration, required super.text});

}

enum BloqoDurationTagValue{
  lessThanOneHour,
  oneHourTwoHours,
  twoHoursThreeHours,
  moreThanThreeHours
}

extension BloqoDurationTagValueExtension on BloqoDurationTagValue{
  String get text {
    switch (this) {
      case BloqoDurationTagValue.lessThanOneHour:
        return "1 hour or less";
      case BloqoDurationTagValue.oneHourTwoHours:
        return "1-2 hours";
      case BloqoDurationTagValue.twoHoursThreeHours:
        return "2-3 hours";
      case BloqoDurationTagValue.moreThanThreeHours:
        return "3 hours or more";
      default:
        throw Exception("Unknown DurationTagValue");
    }
  }
}