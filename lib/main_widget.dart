import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/business/note_bloc.dart';
import 'package:quick_notes/home/home_bloc.dart';
import 'package:quick_notes/main_bloc.dart';
import 'package:quick_notes/settings/settings_widget.dart';

import 'create/create_note_widget.dart';
import 'data/notes_repository.dart';
import 'home/home_widget.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MainWidgetBloc>(
              create: (BuildContext context) => MainWidgetBloc()),
          BlocProvider<HomeBloc>(
              create: (BuildContext context) => HomeBloc(
                  repository: RepositoryProvider.of<NotesRepository>(context))
                ..add(NotesFetched())),
        ],
        child: BlocBuilder<MainWidgetBloc, MainWidgetState>(
            builder: (context, state) {
          return SafeArea(
              child: Scaffold(
                  body: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: _getWidgetForIndex(state.currentIndex),
                  ),
                  floatingActionButton: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () => _navigateToCreateNoteScreen(context)),
                  floatingActionButtonAnimator:
                      FloatingActionButtonAnimator.scaling,
                  bottomNavigationBar: NavigationBar(
                      selectedIndex: state.currentIndex,
                      onDestinationSelected: (index) => context
                          .read<MainWidgetBloc>()
                          .add(TabClickedEvent(index: index)),
                      destinations: MainBottomBarItem.values
                          .map((e) => NavigationDestination(
                                icon: Icon(e.icon),
                                label: e.title,
                              ))
                          .toList())));
        }));
  }
}

Future<void> _navigateToCreateNoteScreen(BuildContext context) async {
  final result = await Navigator.push(context, _constructCreateScreenRoute());

  if (!context.mounted) return;

  switch (result) {
    case NoteStatus.success:
      context.read<HomeBloc>().add(NewNoteInserted());
      break;
    case NoteStatus.failure:
      const snackBar = SnackBar(
        content: Text('Error inserting note!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      break;
    case NoteStatus.discarded:
      const snackBar = SnackBar(
        content: Text('Empty note discarded!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    default:
      break;
  }
}

Route _constructCreateScreenRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const CreateNoteScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // Start position (bottom of screen)
      const end = Offset.zero; // End position (current screen)
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Widget _getWidgetForIndex(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return const HomeWidget();
    case 1:
      return const SettingsWidget();
    default:
      throw Exception("something went wrong");
  }
}

enum MainBottomBarItem {
  home(title: "Home", icon: Icons.home),
  settings(title: "Settings", icon: Icons.settings);

  const MainBottomBarItem({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
