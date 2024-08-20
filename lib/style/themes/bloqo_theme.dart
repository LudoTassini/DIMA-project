import 'package:bloqo/style/themes/purple_orchid_theme.dart';
import 'package:flutter/material.dart';

import '../bloqo_colors.dart';
import 'ocean_cornflower_theme.dart';

enum BloqoAppThemeType {
  purpleOrchid,
  oceanCornflower
}

extension BloqoAppThemeTypeExtension on BloqoAppThemeType {
  String text({required var localizedText}) {
    switch (this) {
      case BloqoAppThemeType.purpleOrchid:
        return localizedText.purple_orchid;
      case BloqoAppThemeType.oceanCornflower:
        return localizedText.ocean_cornflower;
      default:
        throw Exception("Unknown BloqoAppThemeType");
    }
  }
}

List<DropdownMenuEntry<String>> buildThemesList({required var localizedText}) {
  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [];

  for (var entry in BloqoAppThemeType.values) {
    dropdownMenuEntries.add(DropdownMenuEntry<String>(
      value: entry.toString(),
      label: entry.text(localizedText: localizedText),
      labelWidget: Text(
        entry.text(localizedText: localizedText),
        overflow: TextOverflow.ellipsis,
        maxLines: 2, // Adjust the maxLines as needed
      ),
    )
    );
  }

  dropdownMenuEntries.sort((a, b) =>
      a.label.compareTo(b.label)); // sorts the list alphabetically

  return dropdownMenuEntries;

}

abstract class BloqoAppTheme {

  abstract BloqoAppThemeType type;
  abstract BloqoColors colors;
  ThemeData getThemeData();

}

BloqoAppTheme getAppThemeBasedOnStringType({required String stringType}){
  BloqoAppThemeType type = getBloqoAppThemeTypeFromString(type: stringType);
  switch(type){
    case BloqoAppThemeType.purpleOrchid:
      return PurpleOrchidTheme();
    case BloqoAppThemeType.oceanCornflower:
      return OceanCornflowerTheme();
    default:
      return PurpleOrchidTheme();
  }
}

BloqoAppThemeType getBloqoAppThemeTypeFromString({required String type}){
  Map<int, BloqoAppThemeType> themeTypesMap = {};
  Map<String, int> themeTypesStringMap = {};
  int index = 0;
  for(BloqoAppThemeType type in BloqoAppThemeType.values){
    themeTypesMap[index] = type;
    themeTypesStringMap[type.toString()] = index;
    index++;
  }
  int tagIndex = themeTypesStringMap[type]!;
  return themeTypesMap[tagIndex]!;
}