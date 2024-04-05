abstract class BloqoBlock{

  final BloqoBlockType type;

  BloqoBlock({
    required this.type
  });

}

enum BloqoBlockType{
  text,
  multimediaYoutube,
  multimediaDevice,
  quizMultipleChoice,
  quizOpenQuestion
}