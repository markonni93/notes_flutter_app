import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_notes/config/assets/note_assets.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

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
                  Scaffold.of(context).closeEndDrawer();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ))
        ],
      ),
    );
  }
}
