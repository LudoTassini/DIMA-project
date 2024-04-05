class CourseTag{
  final CourseTagType type;
  final String text;

  CourseTag({
    required this.type,
    required this.text
  });
}

enum CourseTagType {
  subject,
  duration,
  modality,
  difficulty
}

extension CourseTagTypeExtension on CourseTagType {
  String get text {
    switch (this) {
      case CourseTagType.subject:
        return "Subject";
      case CourseTagType.duration:
        return "Duration";
      case CourseTagType.modality:
        return "Modality";
      case CourseTagType.difficulty:
        return "Difficulty";
      default:
        throw Exception("Unknown CourseTagType");
    }
  }
}

enum CourseTagSubjectValue{
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

extension CourseTagSubjectValueExtension on CourseTagSubjectValue {
  String get text {
    switch (this) {
      case CourseTagSubjectValue.architecture:
        return "Architecture";
      case CourseTagSubjectValue.cooking:
        return "Cooking";
      case CourseTagSubjectValue.design:
        return "Design";
      case CourseTagSubjectValue.economics:
        return "Economics";
      case CourseTagSubjectValue.education:
        return "Education";
      case CourseTagSubjectValue.esotericism:
        return "Esotericism";
      case CourseTagSubjectValue.fashion:
        return "Fashion";
      case CourseTagSubjectValue.figurativeArts:
        return "Figurative Arts";
      case CourseTagSubjectValue.geography:
        return "Geography";
      case CourseTagSubjectValue.health:
        return "Health";
      case CourseTagSubjectValue.history:
        return "History";
      case CourseTagSubjectValue.languages:
        return "Languages";
      case CourseTagSubjectValue.law:
        return "Law";
      case CourseTagSubjectValue.literature:
        return "Literature";
      case CourseTagSubjectValue.mathematics:
        return "Mathematics";
      case CourseTagSubjectValue.medicine:
        return "Medicine";
      case CourseTagSubjectValue.music:
        return "Music";
      case CourseTagSubjectValue.naturalScience:
        return "Natural Science";
      case CourseTagSubjectValue.other:
        return "Other";
      case CourseTagSubjectValue.performativeArts:
        return "Performative Arts";
      case CourseTagSubjectValue.philosophy:
        return "Philosophy";
      case CourseTagSubjectValue.politics:
        return "Politics";
      case CourseTagSubjectValue.psychology:
        return "Psychology";
      case CourseTagSubjectValue.society:
        return "Society";
      case CourseTagSubjectValue.sports:
        return "Sports";
      case CourseTagSubjectValue.sustainability:
        return "Sustainability";
      case CourseTagSubjectValue.technology:
        return "Technology";
      case CourseTagSubjectValue.visualArts:
        return "Visual Arts";
      default:
        throw Exception("Unknown CourseTagSubjectValue");
    }
  }
}