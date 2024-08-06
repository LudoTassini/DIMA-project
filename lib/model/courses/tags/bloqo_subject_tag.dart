import 'package:bloqo/model/courses/tags/bloqo_course_tag.dart';

class BloqoSubjectTag extends BloqoCourseTag{

  BloqoSubjectTag({super.type = BloqoCourseTagType.subject, required super.text});

}

enum BloqoSubjectTagValue{
  figurativeArts,
  technology,
  naturalSciences,
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

BloqoSubjectTagValue getSubjectTagFromString({required String tag}){
  Map<int, BloqoSubjectTagValue> subjectTagMap = {};
  Map<String, int> subjectTagStringMap = {};
  int index = 0;
  for(BloqoSubjectTagValue tagValue in BloqoSubjectTagValue.values){
    subjectTagMap[index] = tagValue;
    subjectTagStringMap[tagValue.toString()] = index;
    index++;
  }
  int tagIndex = subjectTagStringMap[tag]!;
  return subjectTagMap[tagIndex]!;
}

extension BloqoSubjectTagValueExtension on BloqoSubjectTagValue {
  String text({required var localizedText}) {
    switch (this) {
      case BloqoSubjectTagValue.architecture:
        return localizedText.architecture;
      case BloqoSubjectTagValue.cooking:
        return localizedText.cooking;
      case BloqoSubjectTagValue.design:
        return localizedText.design;
      case BloqoSubjectTagValue.economics:
        return localizedText.economics;
      case BloqoSubjectTagValue.education:
        return localizedText.education;
      case BloqoSubjectTagValue.esotericism:
        return localizedText.esotericism;
      case BloqoSubjectTagValue.fashion:
        return localizedText.fashion;
      case BloqoSubjectTagValue.figurativeArts:
        return localizedText.figurative_arts;
      case BloqoSubjectTagValue.geography:
        return localizedText.geography;
      case BloqoSubjectTagValue.health:
        return localizedText.health;
      case BloqoSubjectTagValue.history:
        return localizedText.history;
      case BloqoSubjectTagValue.languages:
        return localizedText.languages;
      case BloqoSubjectTagValue.law:
        return localizedText.law;
      case BloqoSubjectTagValue.literature:
        return localizedText.literature;
      case BloqoSubjectTagValue.mathematics:
        return localizedText.mathematics;
      case BloqoSubjectTagValue.medicine:
        return localizedText.medicine;
      case BloqoSubjectTagValue.music:
        return localizedText.music;
      case BloqoSubjectTagValue.naturalSciences:
        return localizedText.natural_sciences;
      case BloqoSubjectTagValue.other:
        return localizedText.other;
      case BloqoSubjectTagValue.performativeArts:
        return localizedText.performative_arts;
      case BloqoSubjectTagValue.philosophy:
        return localizedText.philosophy;
      case BloqoSubjectTagValue.politics:
        return localizedText.politics;
      case BloqoSubjectTagValue.psychology:
        return localizedText.psychology;
      case BloqoSubjectTagValue.society:
        return localizedText.society;
      case BloqoSubjectTagValue.sports:
        return localizedText.sports;
      case BloqoSubjectTagValue.sustainability:
        return localizedText.sustainability;
      case BloqoSubjectTagValue.technology:
        return localizedText.technology;
      case BloqoSubjectTagValue.visualArts:
        return localizedText.visual_arts;
      default:
        throw Exception("Unknown SubjectTagValue");
    }
  }
}