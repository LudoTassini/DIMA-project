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
  String text({required var localizedText}) {
    switch (this) {
      case BloqoDurationTagValue.lessThanOneHour:
        return localizedText.one_hour_less;
      case BloqoDurationTagValue.oneHourTwoHours:
        return localizedText.one_two_hours;
      case BloqoDurationTagValue.twoHoursThreeHours:
        return localizedText.two_three_hours;
      case BloqoDurationTagValue.moreThanThreeHours:
        return localizedText.three_hours_more;
      default:
        throw Exception("Unknown DurationTagValue");
    }
  }
}