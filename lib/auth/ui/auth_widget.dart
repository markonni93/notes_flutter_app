import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(children: [
      const Padding(
          padding: EdgeInsets.all(32), child: Text("Welcome to QuickNotes")),
      Padding(
        padding: const EdgeInsets.only(top: 48),
        child: ElevatedButton(onPressed: () {}, child: const Text("Sign In with Google"))),
    ])));
  }
}
