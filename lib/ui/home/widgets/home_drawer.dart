import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_notes/config/assets/note_assets.dart';
import 'package:quick_notes/ui/home/view_models/home_drawer_viewmodel.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key, required this.viewModel});

  final HomeDrawerViewModel viewModel;

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onResult);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.logout.removeListener(_onResult);
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: ClipOval(
              child: SvgPicture.asset(avatarMale, width: 128, height: 128),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
              child: ElevatedButton(
                  onPressed: () => {},
                  child: const Row(
                    children: [Icon(Icons.archive), Text("Archive")],
                  ))),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ElevatedButton(
                  onPressed: () => {},
                  child: const Row(
                    children: [Icon(Icons.delete), Text("Bin")],
                  ))),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                ),
                onPressed: () {
                  widget.viewModel.logout.execute();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ))
        ],
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.logout.completed) {
      widget.viewModel.logout.clearResult();
    }

    if (widget.viewModel.logout.error) {
      widget.viewModel.logout.clearResult();

      const snackBar = SnackBar(
        content: Text('Error logging user out'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
