import 'bloqo_course_tag.dart';

class BloqoLanguageTag extends BloqoCourseTag {
  BloqoLanguageTag({
    super.type = BloqoCourseTagType.language,
    required super.text,
  });
}

enum BloqoLanguageTagValue {
  english,
  italian,
  other
}

BloqoLanguageTagValue getLanguageTagFromString({required String tag}){
  Map<int, BloqoLanguageTagValue> languageTagMap = {};
  Map<String, int> languageTagStringMap = {};
  int index = 0;
  for(BloqoLanguageTagValue tagValue in BloqoLanguageTagValue.values){
    languageTagMap[index] = tagValue;
    languageTagStringMap[tagValue.toString()] = index;
    index++;
  }
  int tagIndex = languageTagStringMap[tag]!;
  return languageTagMap[tagIndex]!;
}

extension BloqoLanguageTagValueExtension on BloqoLanguageTagValue {
  String text({required var localizedText}) {
    switch (this) {
      case BloqoLanguageTagValue.english:
        return localizedText.english;
      case BloqoLanguageTagValue.italian:
        return localizedText.italian;
      case BloqoLanguageTagValue.other:
        return localizedText.other;
      default:
        throw Exception("Unknown LanguageTagValue");
    }
  }
}