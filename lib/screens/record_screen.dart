import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('녹음'),
      ),
      body: const Center(
        child: Text('녹음 화면'),
      ),
    );
  }
}
