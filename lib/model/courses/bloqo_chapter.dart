import 'bloqo_section.dart';

class BloqoChapter{

  final String name;

  String? description;
  List<BloqoSection>? sections;

  BloqoChapter({
    required this.name,
    this.sections,
  });



}