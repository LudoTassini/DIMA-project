import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';

class BloqoSnackBar{

  static get({required Widget child}){
    return SnackBar(
      content: child,
      backgroundColor: BloqoColors.russianViolet,
      padding: const EdgeInsets.all(24),
    );
  }

}