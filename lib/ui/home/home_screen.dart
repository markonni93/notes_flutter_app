import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Home screen"),
      floatingActionButton: FloatingActionButton(onPressed: () => {

      }, child: const Icon(Icons.add),),
    );
  }
}
