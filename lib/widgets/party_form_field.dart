import 'package:flutter/material.dart';

class PartyFormField extends StatelessWidget {
  final double spacing;
  final String label;
  final TextEditingController controller;
  int? maxLines;

   PartyFormField(
      {Key? key,
      required this.spacing,
      required this.label,
      required this.controller,
        this.maxLines,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    maxLines != null ? maxLines = maxLines : maxLines = 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacing),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Entrer du texte';
            }
            return null;
          },
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
          ),
          maxLines: maxLines,

        )
      ],
    );
  }
}
