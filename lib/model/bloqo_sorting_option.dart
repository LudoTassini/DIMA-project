import 'package:flutter/material.dart';

enum BloqoSortingOption{
  bestRated,
  publicationDateLatestFirst,
  publicationDateOldestFirst,
  courseNameAZ,
  courseNameZA,
  authorNameAZ,
  authorNameZA
}

extension BloqoSortingOptionExtension on BloqoSortingOption{
  String text({required var localizedText}) {
    switch (this) {
      case BloqoSortingOption.bestRated:
        return localizedText.best_rated;
      case BloqoSortingOption.publicationDateLatestFirst:
        return localizedText.publication_date_latest;
      case BloqoSortingOption.publicationDateOldestFirst:
        return localizedText.publication_date_oldest;
      case BloqoSortingOption.courseNameAZ:
        return localizedText.course_name_az;
      case BloqoSortingOption.courseNameZA:
        return localizedText.course_name_za;
      case BloqoSortingOption.authorNameAZ:
        return localizedText.author_username_az;
      case BloqoSortingOption.authorNameZA:
        return localizedText.author_username_za;
      default:
        throw Exception("Unknown SortingOption");
    }
  }
}

List<DropdownMenuEntry<String>> buildSortingOptionsList({required var localizedText, bool withNone = true}){

  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [];

  for (var entry in BloqoSortingOption.values){
    dropdownMenuEntries.add(DropdownMenuEntry<String>(
      value: entry.toString(),
      label: entry.text(localizedText: localizedText),
      labelWidget: Text(
        entry.text(localizedText: localizedText),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,)
    ));
  }

  if(withNone) {
    dropdownMenuEntries.insert(0, DropdownMenuEntry<String>(
      value: "None",
      label: localizedText.none,
      labelWidget: Text(
        localizedText.none,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      )
    ));
  }

  return dropdownMenuEntries;

}