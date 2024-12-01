import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/business/product_bloc.dart';
import 'package:flutter_notes/data/remote/product_repository.dart';
import 'package:flutter_notes/ui/main_widget.dart';
import 'package:flutter_notes/ui/model/note_ui_model.dart';

import 'business/note_bloc.dart';
import 'common/widgets/note_loading_indicator.dart';
import 'data/notes_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotesRepository>(
            create: (context) => NotesRepository(),
          ),
          RepositoryProvider<ProductRepository>(
            create: (context) => ProductRepositoryImpl(),
          )
        ],
        child: MaterialApp(
          title: "Note App",
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true),
          home: const MainWidget(),
        ));
  }
}

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            ProductBloc(RepositoryProvider.of<ProductRepository>(context))
              ..add(GetProductEvent()),
        child: SafeArea(
            child: BlocConsumer<ProductBloc, ProductState>(
          listenWhen: (context, state) {
            return state is ProductErrorState;
          },
          listener: (context, state) {
            if (state is ProductErrorState) {
              const snackBar = SnackBar(
                content: Text('Error happened!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          buildWhen: (context, state) {
            return state is ProductLoadingState || state is ProductSuccessState;
          },
          builder: (context, state) {
            if (state is ProductLoadingState) {
              return const NoteLoadingIndicator();
            } else if (state is ProductSuccessState) {
              return const Text("Successfully fetched data");
            } else {
              throw Exception("Unhandled state");
            }
          },
        )));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            NoteBloc(RepositoryProvider.of<NotesRepository>(context))
              ..add(GetNoteEvent()),
        child: const NotesScreen());
  }
}

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NoteBloc, NoteState>(
        listenWhen: (context, state) {
          return state is NoteErrorState;
        },
        listener: (context, state) {
          if (state is NoteErrorState) {
            const snackBar = SnackBar(
              content: Text('Yay! A SnackBar!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        buildWhen: (context, state) {
          return state is NoteLoadingState || state is NoteSuccessState;
        },
        builder: (context, state) {
          if (state is NoteLoadingState) {
            return const NoteLoadingIndicator();
          } else if (state is NoteSuccessState) {
            return NoteList(items: state.data);
          } else {
            throw Exception("Unhandled state");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CreateScreen()))
              }),
    );
  }
}

class NoteList extends StatelessWidget {
  final List<NoteUiModel> items;

  const NoteList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            children: [
              Text("Title is ${item.title}"),
              Text("Description is ${item.note}")
            ],
          );
        });
  }
}
