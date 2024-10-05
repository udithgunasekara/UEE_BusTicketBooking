import 'package:flutter/material.dart';

class testPage extends StatelessWidget {
  const testPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: const Center(
        child: Text(
          'This is the test page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
