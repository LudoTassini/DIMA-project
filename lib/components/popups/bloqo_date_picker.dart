import 'package:flutter/material.dart';

class BloqoDatePicker extends StatelessWidget{
  const BloqoDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return DatePickerDialog(
        currentDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2100),
        keyboardType: TextInputType.datetime,
    );
  }

}

showBloqoDatePicker({required BuildContext context}){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const BloqoDatePicker(
      );
    },
  );
}