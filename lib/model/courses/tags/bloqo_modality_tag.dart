import 'bloqo_course_tag.dart';

class BloqoModalityTag extends BloqoCourseTag{

  BloqoModalityTag({super.type = BloqoCourseTagType.modality, required super.text});

}

enum BloqoModalityTagValue{
  lessonsOnly,
  quizzesOnly,
  lessonsAndQuizzes
}

BloqoModalityTagValue getModalityTagFromString({required String tag}){
  Map<int, BloqoModalityTagValue> modalityTagMap = {};
  Map<String, int> modalityTagStringMap = {};
  int index = 0;
  for(BloqoModalityTagValue tagValue in BloqoModalityTagValue.values){
    modalityTagMap[index] = tagValue;
    modalityTagStringMap[tagValue.toString()] = index;
    index++;
  }
  int tagIndex = modalityTagStringMap[tag]!;
  return modalityTagMap[tagIndex]!;
}

extension BloqoModalityTagValueExtension on BloqoModalityTagValue{
  String text({required var localizedText}) {
    switch (this) {
      case BloqoModalityTagValue.lessonsOnly:
        return localizedText.lessons_only;
      case BloqoModalityTagValue.quizzesOnly:
        return localizedText.quizzes_only;
      case BloqoModalityTagValue.lessonsAndQuizzes:
        return localizedText.lessons_quizzes;
      default:
        throw Exception("Unknown ModalityTagValue");
    }
  }
}