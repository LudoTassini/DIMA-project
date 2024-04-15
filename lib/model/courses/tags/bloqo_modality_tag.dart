import 'bloqo_course_tag.dart';

class BloqoModalityTag extends BloqoCourseTag{

  BloqoModalityTag({super.type = BloqoCourseTagType.modality, required super.text});

}

enum BloqoModalityTagValue{
  lessonsOnly,
  quizzesOnly,
  lessonsAndQuizzes
}

extension BloqoModalityTagValueExtension on BloqoModalityTagValue{
  String get text {
    switch (this) {
      case BloqoModalityTagValue.lessonsOnly:
        return "Lessons Only";
      case BloqoModalityTagValue.quizzesOnly:
        return "Quizzes Only";
      case BloqoModalityTagValue.lessonsAndQuizzes:
        return "Lessons and Quizzes";
      default:
        throw Exception("Unknown ModalityTagValue");
    }
  }
}