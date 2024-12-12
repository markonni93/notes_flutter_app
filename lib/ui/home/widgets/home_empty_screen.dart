import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/assets/note_assets.dart';

class HomeEmptyScreen extends StatelessWidget {
  const HomeEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 32, bottom: 16),
              child:
                  SvgPicture.asset(width: 250, height: 350, noteList, alignment: Alignment.topCenter)),
          Text(
            textAlign: TextAlign.center,
            "Notes list is empty",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ]);
  }
}
