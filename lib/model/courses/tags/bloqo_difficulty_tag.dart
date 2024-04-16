import 'bloqo_course_tag.dart';

class BloqoDifficultyTag extends BloqoCourseTag{

  BloqoDifficultyTag({super.type = BloqoCourseTagType.difficulty, required super.text});

}

enum BloqoDifficultyTagValue{
  basic,
  advanced,
}

extension BloqoDifficultyTagValueExtension on BloqoDifficultyTagValue {
  String get text {
    switch (this) {
      case BloqoDifficultyTagValue.basic:
        return "Basic";
      case BloqoDifficultyTagValue.advanced:
        return "Advanced";
      default:
        throw Exception("Unknown DifficultyTagValue");
    }
  }
}