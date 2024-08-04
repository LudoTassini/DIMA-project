import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import '../utils/constants.dart';

class BloqoMarkdownStyleSheet{

  static MarkdownStyleSheet get(){
    return MarkdownStyleSheet(
      p: const TextStyle(fontSize: Constants.markdownBaseFontSize),
      h1: const TextStyle(fontSize: Constants.markdownBaseFontSize + 16),
      h2: const TextStyle(fontSize: Constants.markdownBaseFontSize + 12),
      h3: const TextStyle(fontSize: Constants.markdownBaseFontSize + 8),
      h4: const TextStyle(fontSize: Constants.markdownBaseFontSize + 4),
      h5: const TextStyle(fontSize: Constants.markdownBaseFontSize + 2),
      h6: const TextStyle(fontSize: Constants.markdownBaseFontSize + 1),
    );
  }

}