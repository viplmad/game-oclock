import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.title,
    required this.onBackPressed,
    required this.content,
  });

  final String title;
  final VoidCallback onBackPressed;
  final Widget content;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
        leading: BackButton(onPressed: onBackPressed),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
        child: content,
      ),
    );
  }
}
