import 'package:bloqo/model/courses/tags/bloqo_course_tag.dart';

class BloqoSubjectTag extends BloqoCourseTag{

  BloqoSubjectTag({super.type = BloqoCourseTagType.subject, required super.text});

}

enum BloqoSubjectTagValue{
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

extension BloqoSubjectTagValueExtension on BloqoSubjectTagValue {
  String get text {
    switch (this) {
      case BloqoSubjectTagValue.architecture:
        return "Architecture";
      case BloqoSubjectTagValue.cooking:
        return "Cooking";
      case BloqoSubjectTagValue.design:
        return "Design";
      case BloqoSubjectTagValue.economics:
        return "Economics";
      case BloqoSubjectTagValue.education:
        return "Education";
      case BloqoSubjectTagValue.esotericism:
        return "Esotericism";
      case BloqoSubjectTagValue.fashion:
        return "Fashion";
      case BloqoSubjectTagValue.figurativeArts:
        return "Figurative Arts";
      case BloqoSubjectTagValue.geography:
        return "Geography";
      case BloqoSubjectTagValue.health:
        return "Health";
      case BloqoSubjectTagValue.history:
        return "History";
      case BloqoSubjectTagValue.languages:
        return "Languages";
      case BloqoSubjectTagValue.law:
        return "Law";
      case BloqoSubjectTagValue.literature:
        return "Literature";
      case BloqoSubjectTagValue.mathematics:
        return "Mathematics";
      case BloqoSubjectTagValue.medicine:
        return "Medicine";
      case BloqoSubjectTagValue.music:
        return "Music";
      case BloqoSubjectTagValue.naturalScience:
        return "Natural Science";
      case BloqoSubjectTagValue.other:
        return "Other";
      case BloqoSubjectTagValue.performativeArts:
        return "Performative Arts";
      case BloqoSubjectTagValue.philosophy:
        return "Philosophy";
      case BloqoSubjectTagValue.politics:
        return "Politics";
      case BloqoSubjectTagValue.psychology:
        return "Psychology";
      case BloqoSubjectTagValue.society:
        return "Society";
      case BloqoSubjectTagValue.sports:
        return "Sports";
      case BloqoSubjectTagValue.sustainability:
        return "Sustainability";
      case BloqoSubjectTagValue.technology:
        return "Technology";
      case BloqoSubjectTagValue.visualArts:
        return "Visual Arts";
      default:
        throw Exception("Unknown SubjectTagValue");
    }
  }
}