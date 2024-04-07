import 'package:bloqo/model/courses/tags/bloqo_course_tag.dart';

class BloqoSubjectTag extends BloqoCourseTag{

  BloqoSubjectTag({super.type = BloqoCourseTagType.subject, required super.text});

}

enum BloqoCourseTagSubjectValue{
  figurativeArts,
  technology,
  naturalScience,
  history,
  philosophy,
  languages,
  music,
  health,
  cooking,
  sports,
  economics,
  politics,
  society,
  psychology,
  sustainability,
  literature,
  mathematics,
  education,
  esotericism,
  architecture,
  design,
  fashion,
  visualArts,
  law,
  medicine,
  geography,
  performativeArts,
  other
}

extension BloqoCourseTagSubjectValueExtension on BloqoCourseTagSubjectValue {
  String get text {
    switch (this) {
      case BloqoCourseTagSubjectValue.architecture:
        return "Architecture";
      case BloqoCourseTagSubjectValue.cooking:
        return "Cooking";
      case BloqoCourseTagSubjectValue.design:
        return "Design";
      case BloqoCourseTagSubjectValue.economics:
        return "Economics";
      case BloqoCourseTagSubjectValue.education:
        return "Education";
      case BloqoCourseTagSubjectValue.esotericism:
        return "Esotericism";
      case BloqoCourseTagSubjectValue.fashion:
        return "Fashion";
      case BloqoCourseTagSubjectValue.figurativeArts:
        return "Figurative Arts";
      case BloqoCourseTagSubjectValue.geography:
        return "Geography";
      case BloqoCourseTagSubjectValue.health:
        return "Health";
      case BloqoCourseTagSubjectValue.history:
        return "History";
      case BloqoCourseTagSubjectValue.languages:
        return "Languages";
      case BloqoCourseTagSubjectValue.law:
        return "Law";
      case BloqoCourseTagSubjectValue.literature:
        return "Literature";
      case BloqoCourseTagSubjectValue.mathematics:
        return "Mathematics";
      case BloqoCourseTagSubjectValue.medicine:
        return "Medicine";
      case BloqoCourseTagSubjectValue.music:
        return "Music";
      case BloqoCourseTagSubjectValue.naturalScience:
        return "Natural Science";
      case BloqoCourseTagSubjectValue.other:
        return "Other";
      case BloqoCourseTagSubjectValue.performativeArts:
        return "Performative Arts";
      case BloqoCourseTagSubjectValue.philosophy:
        return "Philosophy";
      case BloqoCourseTagSubjectValue.politics:
        return "Politics";
      case BloqoCourseTagSubjectValue.psychology:
        return "Psychology";
      case BloqoCourseTagSubjectValue.society:
        return "Society";
      case BloqoCourseTagSubjectValue.sports:
        return "Sports";
      case BloqoCourseTagSubjectValue.sustainability:
        return "Sustainability";
      case BloqoCourseTagSubjectValue.technology:
        return "Technology";
      case BloqoCourseTagSubjectValue.visualArts:
        return "Visual Arts";
      default:
        throw Exception("Unknown CourseTagSubjectValue");
    }
  }
}