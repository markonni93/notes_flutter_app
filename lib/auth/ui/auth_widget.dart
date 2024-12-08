import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            case SignupStatus.success:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainWidget()));
            case SignupStatus.failure:
            case SignupStatus.skipSignup:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainWidget()));
          }
        }, builder: (context, state) {
          return SafeArea(
              child: Column(
            children: [
              const Expanded(
                  child: Center(
                child: Text("Welcome to Quick Notes"),
              )),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    _googleSignInButton(context),
                    _continueWithoutSignupButton(context)
                  ],
                ),
              )
            ],
          ));
        }));
  }
}

Widget _googleSignInButton(BuildContext context) {
  return IntrinsicWidth(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              color: Colors.grey, // Border color
              width: 2, // Border width
            ),
            backgroundColor: Colors.black12, // Set the background color
            foregroundColor: Colors.white, // Set the text color
          ),
          onPressed: () => context.read<AuthBloc>().add(SignupUserEvent()),
          child: Row(
            children: [
              SvgPicture.asset("assets/drawable/google_logo.svg",
                  semanticsLabel: "Google logo"),
              const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text("Sign in with Google"))
            ],
          )));
}

Widget _continueWithoutSignupButton(BuildContext context) {
  return ElevatedButton(
      onPressed: () =>
          context.read<AuthBloc>().add(ContinueWithoutSignupEvent()),
      child: const Text("Continue without signup"));
}
