import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/auth/bloc/auth_bloc.dart';
import 'package:quick_notes/auth/repository/auth_repository.dart';
import 'package:quick_notes/main_widget.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(
            repository:
                RepositoryProvider.of<AuthenticationRepository>(context)),
        child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          switch (state.status) {
            case SignupStatus.notStarted:
              print("Signup not started");
            case SignupStatus.success:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainWidget()));
            case SignupStatus.failure:
              print("Error happened ${state.error}");
            case SignupStatus.skipSignup:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainWidget()));
          }
        }, builder: (context, state) {
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
