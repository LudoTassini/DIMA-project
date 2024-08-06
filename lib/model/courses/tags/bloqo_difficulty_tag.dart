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

BloqoDifficultyTagValue getDifficultyTagFromString({required String tag}){
  Map<int, BloqoDifficultyTagValue> difficultyTagMap = {};
  Map<String, int> difficultyTagStringMap = {};
  int index = 0;
  for(BloqoDifficultyTagValue tagValue in BloqoDifficultyTagValue.values){
    difficultyTagMap[index] = tagValue;
    difficultyTagStringMap[tagValue.toString()] = index;
    index++;
  }
  int tagIndex = difficultyTagStringMap[tag]!;
  return difficultyTagMap[tagIndex]!;
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
