import 'package:flutter/material.dart';

class NormalDesignerButton extends StatelessWidget {
  final String text;
  final Function()? tap;
  const NormalDesignerButton({super.key, required this.text, this.tap});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: tap,
      label: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
