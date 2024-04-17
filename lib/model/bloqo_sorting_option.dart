import 'package:flutter/material.dart';

enum BloqoSortingOption{
  publicationDateLatestFirst,
  publicationDateOldestFirst,
  courseNameAZ,
  courseNameZA,
  authorNameAZ,
  authorNameZA,
  bestRated
}

extension BloqoSortingOptionExtension on BloqoSortingOption{
  String get text {
    switch (this) {
      case BloqoSortingOption.publicationDateLatestFirst:
        return "Publication Date (latest first)";
      case BloqoSortingOption.publicationDateOldestFirst:
        return "Publication Date (oldest first)";
      case BloqoSortingOption.courseNameAZ:
        return "Course Name (alphabetical)";
      case BloqoSortingOption.courseNameZA:
        return "Course Name (reverse alphabetical)";
      case BloqoSortingOption.authorNameAZ:
        return "Author Name (alphabetical)";
      case BloqoSortingOption.authorNameZA:
        return "Author Name (reverse alphabetical)";
      case BloqoSortingOption.bestRated:
        return "Best Rated";
      default:
        throw Exception("Unknown SortingOption");
    }
  }
}

List<DropdownMenuEntry<String>> buildSortingOptionsList({bool withNone = true}){

  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [];

  for (var entry in BloqoSortingOption.values){
    dropdownMenuEntries.add(DropdownMenuEntry<String>(value: entry.text, label: entry.text));
  }

  if(withNone) {
    dropdownMenuEntries.insert(0, const DropdownMenuEntry<String>(value: "None", label: 'None'));
  }

  return dropdownMenuEntries;

}