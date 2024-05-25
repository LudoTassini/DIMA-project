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
    required this.text,
  });
}

enum BloqoCourseTagType {
  subject,
  duration,
  modality,
  difficulty
}

List<DropdownMenuEntry<String>> buildTagList({required BloqoCourseTagType type, required var localizedText, bool withNone = true}) {
  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [];

  switch(type){
    case BloqoCourseTagType.subject:
      for (var entry in BloqoSubjectTagValue.values){
        dropdownMenuEntries.add(DropdownMenuEntry<String>(
            value: entry.name,
            label: entry.text(localizedText: localizedText),
            labelWidget: Text(
              entry.text(localizedText: localizedText),
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Adjust the maxLines as needed
            ),
          )
        );
      }
      dropdownMenuEntries.sort((a, b) => a.label.compareTo(b.label)); // sorts the list alphabetically
      break;
    case BloqoCourseTagType.difficulty:
      for (var entry in BloqoDifficultyTagValue.values){
        dropdownMenuEntries.add(DropdownMenuEntry<String>(
            value: entry.name,
            label: entry.text(localizedText: localizedText),
            labelWidget: Text(
              entry.text(localizedText: localizedText),
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Adjust the maxLines as needed
            ),
          )
        );
      }
      break;
    case BloqoCourseTagType.modality:
      for (var entry in BloqoModalityTagValue.values){
        dropdownMenuEntries.add(DropdownMenuEntry<String>(
            value: entry.name,
            label: entry.text(localizedText: localizedText),
            labelWidget: Text(
              entry.text(localizedText: localizedText),
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Adjust the maxLines as needed
            ),
          )
        );
      }
      break;
    case BloqoCourseTagType.duration:
      for (var entry in BloqoDurationTagValue.values){
        dropdownMenuEntries.add(DropdownMenuEntry<String>(
            value: entry.name,
            label: entry.text(localizedText: localizedText),
            labelWidget: Text(
                entry.text(localizedText: localizedText),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Adjust the maxLines as needed
              ),
            )
        );
      }
      break;
    default:
      throw Exception("Unknown CourseTagType");
  }

  if(withNone) {
    dropdownMenuEntries.insert(0, DropdownMenuEntry<String>(
        value: "None",
        label: localizedText.none,
        labelWidget: Text(
          localizedText.none,
          overflow: TextOverflow.ellipsis,
          maxLines: 2, // Adjust the maxLines as needed
        ),
      )
    );
  }

  return dropdownMenuEntries;
}