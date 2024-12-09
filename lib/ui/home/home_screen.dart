import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/assets/note_assets.dart';
import '../core/action_button.dart';
import '../core/expandable_fab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _fabOpened = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleFab(bool fabValue) {
    setState(() {
      _fabOpened = fabValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
              stretch: true,
              stretchTriggerOffset: 300.0,
              pinned: true,
              expandedHeight: 200.0,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Calculate the collapse percentage
                  var top = constraints.biggest.height;
                  bool isCollapsed = top <=
                      kToolbarHeight + MediaQuery.of(context).padding.top;

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

              // FlexibleSpaceBar(
              //   background: Padding(padding: const EdgeInsets.all(16) , child: SvgPicture.asset(notebook1)),
              // ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Add new entry',
                  onPressed: () {
                    /* ... */
                  },
                )
              ]),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index',
                        textScaler: const TextScaler.linear(5.0)),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),

      // Stack(children: [
      //   Positioned.fill(
      //     child: AnimatedOpacity(
      //       opacity: _fabOpened ? 1.0 : 0.0,
      //       duration: const Duration(milliseconds: 250),
      //       child: Container(
      //         color: Colors.black26,
      //         width: MediaQuery.of(context).size.width,
      //         height: MediaQuery.of(context).size.height,
      //       ),
      //     ),
      //   )
      // ]),
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
        onFabPressed: (bool value) => {_toggleFab(value)},
      ),
    );
  }
}
