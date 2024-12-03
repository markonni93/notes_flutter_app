import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/product_bloc.dart';
import '../../common/widgets/note_loading_indicator.dart';
import '../../data/remote/product_repository.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            ProductBloc(RepositoryProvider.of<ProductRepository>(context))
              ..add(GetProductEvent()),
        child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                    leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios)),
                    title: const Text("Create note"),
                    backgroundColor: Colors.blueAccent),
                body: BlocConsumer<ProductBloc, ProductState>(
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
                    return state is ProductLoadingState ||
                        state is ProductSuccessState;
                  },
                  builder: (context, state) {
                    if (state is ProductLoadingState) {
                      return const Center(child: NoteLoadingIndicator());
                    } else if (state is ProductSuccessState) {
                      return const Text("Successfully fetched data");
                    } else {
                      throw Exception("Unhandled state");
                    }
                  },
                ))));
  }
}
