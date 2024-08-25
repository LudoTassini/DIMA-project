import 'package:flutter/material.dart';

bool checkDevice(BuildContext context) {
  bool isTablet = false;
  // Get the screen width
  var screenWidth = MediaQuery.of(context).size.width;
  // Check if the device is a tablet
  if (screenWidth > 600) {
    isTablet = true;
  }
  return isTablet;
}