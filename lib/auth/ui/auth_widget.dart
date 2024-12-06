import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/auth/bloc/auth_bloc.dart';
import 'package:flutter_notes/auth/repository/auth_repository.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(
            repository:
                RepositoryProvider.of<AuthenticationRepository>(context)),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return SafeArea(
              child: Center(
                  child: Column(children: [
            const Padding(
                padding: EdgeInsets.all(32),
                child: Text("Welcome to QuickNotes")),
            Padding(
                padding: const EdgeInsets.only(top: 48),
                child: ElevatedButton(
                    onPressed: () =>
                        context.read<AuthBloc>().add(SignupUserEvent()),
                    child: const Text("Sign In with Google"))),
          ])));
        }));
  }
}
