import 'package:flutter/material.dart';

class FirstTimeLoader extends StatefulWidget {
  const FirstTimeLoader({super.key});

  @override
  State<FirstTimeLoader> createState() => _FirstTimeLoaderState();
}

class _FirstTimeLoaderState extends State<FirstTimeLoader> {
  @override
  void initState() {
    super.initState();
    _installBible();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }

  Future<void> _installBible() async {
    
  }
}
