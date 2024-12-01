import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteLoadingIndicator extends StatelessWidget {
  const NoteLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: CircularProgressIndicator());
  }
}
