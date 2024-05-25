import 'bloqo_course_tag.dart';

class BloqoDifficultyTag extends BloqoCourseTag {
  BloqoDifficultyTag({
    super.type = BloqoCourseTagType.difficulty,
    required super.text,
  });
}

enum BloqoDifficultyTagValue {
  forEveryone,
  forExperts
}

extension BloqoDifficultyTagValueExtension on BloqoDifficultyTagValue {
  String text({required var localizedText}) {
    switch (this) {
      case BloqoDifficultyTagValue.forEveryone:
        return localizedText.for_everyone;
      case BloqoDifficultyTagValue.forExperts:
        return localizedText.for_experts;
      default:
        throw Exception("Unknown DifficultyTagValue");
    }
  }
}
