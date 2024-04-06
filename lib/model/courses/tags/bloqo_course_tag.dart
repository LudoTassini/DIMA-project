abstract class BloqoCourseTag{
  final BloqoCourseTagType type;
  final String text;

  BloqoCourseTag({
    required this.type,
    required this.text
  });
}

enum BloqoCourseTagType {
  subject,
  duration,
  modality,
  difficulty
}

extension BloqoCourseTagTypeExtension on BloqoCourseTagType {
  String get text {
    switch (this) {
      case BloqoCourseTagType.subject:
        return "Subject";
      case BloqoCourseTagType.duration:
        return "Duration";
      case BloqoCourseTagType.modality:
        return "Modality";
      case BloqoCourseTagType.difficulty:
        return "Difficulty";
      default:
        throw Exception("Unknown CourseTagType");
    }
  }
}