import 'package:flutter/material.dart';

class AffirmationListScreen extends StatelessWidget {
  const AffirmationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('확언 목록'),
      ),
      body: const Center(
        child: Text('확언 목록 화면'),
      ),
    );
  }
}
