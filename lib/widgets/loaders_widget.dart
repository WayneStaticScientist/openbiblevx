import 'package:flutter/material.dart';

class NormalLoader extends StatelessWidget {
  const NormalLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
