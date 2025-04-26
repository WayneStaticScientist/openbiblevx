import 'package:flutter/material.dart';

class NormalError extends StatelessWidget {
  final String errorText;
  const NormalError({super.key, required this.errorText});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorText,
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
