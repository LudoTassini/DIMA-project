import 'package:flutter/material.dart';

class BloqoDropdown extends StatefulWidget {
  const BloqoDropdown({
    super.key,
    required this.controller,
    required this.dropdownMenuEntries,
    required this.width,
    this.label,
    this.initialSelection,
    this.hintText,
  });

  final TextEditingController controller;
  final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  final double width;
  final String? label;
  final String? initialSelection;
  final String? hintText;

  @override
  State<BloqoDropdown> createState() => _BloqoDropdownState();
}

class _BloqoDropdownState extends State<BloqoDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: widget.width,
      controller: widget.controller,
      dropdownMenuEntries: widget.dropdownMenuEntries,
      initialSelection: widget.initialSelection,
      hintText: widget.hintText,
      label: widget.label != null ? Text(widget.label!) : null,
      menuHeight: 300.0,
      requestFocusOnTap: false,
    );
  }
}