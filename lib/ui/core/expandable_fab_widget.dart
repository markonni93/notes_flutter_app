import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/notes_routes.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab(
      {super.key,
      this.initialOpen,
      required this.distance,
      required this.onFabPressed});

  final bool? initialOpen;
  final double distance;
  final ValueChanged<bool> onFabPressed;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
        value: _open ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        vsync: this);
    _expandAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.easeOutQuad);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      _open ? _controller.forward() : _controller.reverse();
      widget.onFabPressed(_open);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab()
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            child: InkWell(
                onTap: _toggle,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.close,
                        color: Theme.of(context).primaryColor)))),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform:
            Matrix4.diagonal3Values(_open ? 0.7 : 1.0, _open ? 0.7 : 1.0, 1.0),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
            opacity: _open ? 0.0 : 1.0,
            curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
            duration: const Duration(milliseconds: 250),
            child: FloatingActionButton(
                onPressed: _toggle, child: const Icon(Icons.add))),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = FabItem.values.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          onPressed: () {
            _toggle();
            context.go(_getRouteForFabAction(i));
          },
          child: FabActionButton(item: FabItem.values[i]),
        ),
      );
    }
    return children;
  }
}

_getRouteForFabAction(int index) {
  return switch (FabItem.values[index]) {
    FabItem.note => Routes.createNote,
    FabItem.list => Routes.createListNote,
    FabItem.drawing => Routes.createDrawingNote,
  };
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton(
      {required this.directionInDegrees,
      required this.maxDistance,
      required this.progress,
      required this.child,
      this.onPressed});

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: progress,
        builder: (context, child) {
          final offset = Offset.fromDirection(
            directionInDegrees * (math.pi / 180.0),
            progress.value * maxDistance,
          );
          return Positioned(
            right: 4.0 + offset.dx,
            bottom: 4.0 + offset.dy,
            child: Transform.rotate(
              angle: (1.0 - progress.value) * math.pi / 2,
              child: child!,
            ),
          );
        },
        child: FadeTransition(
            opacity: progress,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onPressed,
                  child: child),
            )));
  }
}

@immutable
class FabActionButton extends StatelessWidget {
  const FabActionButton({super.key, required FabItem item}) : _fabItem = item;

  final FabItem _fabItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Icon icon;
    switch (_fabItem) {
      case FabItem.note:
        icon = const Icon(Icons.format_size);
        break;
      case FabItem.list:
        icon = const Icon(Icons.check_box);
        break;
      case FabItem.drawing:
        icon = const Icon(Icons.insert_photo);
        break;
    }
    return Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.secondary,
        elevation: 4,
        child: IgnorePointer(
          child: IconButton(
            onPressed: () {},
            icon: icon,
            color: theme.colorScheme.onSecondary,
          ),
        ));
  }
}

enum FabItem { note, list, drawing }
