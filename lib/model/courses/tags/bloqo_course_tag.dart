import 'package:flutter/material.dart';

import 'bloqo_difficulty_tag.dart';
import 'bloqo_duration_tag.dart';
import 'bloqo_modality_tag.dart';
import 'bloqo_subject_tag.dart';

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

List<DropdownMenuEntry<String>> buildTagList({required BloqoCourseTagType type, bool withNone = true}){

  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [];

  switch(type){
    case BloqoCourseTagType.subject:
      for (var entry in BloqoSubjectTagValue.values){
        dropdownMenuEntries.add(DropdownMenuEntry<String>(value: entry.text, label: entry.text));
      }
      dropdownMenuEntries.sort((a, b) => a.value.compareTo(b.value)); // sorts the list alphabetically
      break;
    case BloqoCourseTagType.difficulty:
      for (var entry in BloqoDifficultyTagValue.values){
        dropdownMenuEntries.add(DropdownMenuEntry<String>(value: entry.text, label: entry.text));
      }
      break;
    case BloqoCourseTagType.modality:
      for (var entry in BloqoModalityTagValue.values){
        dropdownMenuEntries.add(DropdownMenuEntry<String>(value: entry.text, label: entry.text));
      }
      break;
    case BloqoCourseTagType.duration:
      for (var entry in BloqoDurationTagValue.values){
        dropdownMenuEntries.add(DropdownMenuEntry<String>(value: entry.text, label: entry.text));
      }
      break;
    default:
      throw Exception("Unknown CourseTagType");
  }

  if(withNone) {
    dropdownMenuEntries.insert(0, const DropdownMenuEntry<String>(value: "None", label: 'None'));
  }

  return dropdownMenuEntries;

}