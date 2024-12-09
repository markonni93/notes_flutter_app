import 'package:flutter/material.dart';

import '../core/action_button.dart';
import '../core/expandable_fab_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Home screen"),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.format_size),
          ),
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => {},
            icon: const Icon(Icons.videocam),
          )
        ],
      ),
    );
  }
}


// Positioned.fill(
// child:
// AnimatedOpacity(
// opacity: _open ? 1.0 : 0.0,
// duration: const Duration(milliseconds: 250),
// child: GestureDetector(
// onTap: () {
// _toggle();
// },
// child: Container(
// color: Colors.black26,
// width: MediaQuery.of(context).size.width,
// height: MediaQuery.of(context).size.height,
// ),
// ),
// )),
