import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/assets/note_assets.dart';

@immutable
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        stretch: true,
        stretchTriggerOffset: 300.0,
        pinned: true,
        expandedHeight: 200.0,
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Calculate the collapse percentage
            var top = constraints.biggest.height;
            bool isCollapsed =
                top <= kToolbarHeight + MediaQuery.of(context).padding.top;

            return FlexibleSpaceBar(
              centerTitle: true,
              title: isCollapsed
                  ? const Text("Quick Notes") // Show when collapsed
                  : null, // Hide when expanded
              background: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(notebook1)),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Add new entry',
            onPressed: () {
              /* ... */
            },
          )
        ]);
  }
}
