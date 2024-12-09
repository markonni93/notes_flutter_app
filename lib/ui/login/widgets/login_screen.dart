import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../config/assets/note_assets.dart';
import '../../../routing/notes_routes.dart';
import '../view_models/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);
    widget.viewModel.continueWithoutAccount.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onResult);
    widget.viewModel.continueWithoutAccount.removeListener(_onResult);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);

    oldWidget.viewModel.continueWithoutAccount.removeListener(_onResult);
    widget.viewModel.continueWithoutAccount.addListener(_onResult);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.viewModel.login,
        builder: (context, _) {
          return Stack(
            children: [
              Scaffold(
                body: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      const Spacer(),
                      Text("Welcome to Quick Notes",
                          style: Theme.of(context).textTheme.headlineLarge),
                      const Spacer(),
                      IntrinsicWidth(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.grey, // Border color
                                  width: 2, // Border width
                                ),
                                backgroundColor: Colors.black12,
                                // Set the background color
                                foregroundColor:
                                    Colors.white, // Set the text color
                              ),
                              onPressed: () => widget.viewModel.login.execute(),
                              child: Row(
                                children: [
                                  SvgPicture.asset(googleLogo,
                                      semanticsLabel: "Google logo"),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Text("Sign in with Google"))
                                ],
                              ))),
                      ElevatedButton(
                          onPressed: () =>
                              widget.viewModel.continueWithoutAccount.execute(),
                          child: const Text("Continue without account")),
                      const Padding(padding: EdgeInsets.only(bottom: 16))
                    ])),
              ),
              if (widget.viewModel.login.running) ...[
                Positioned.fill(
                  child: Container(
                    color: Colors.black26, // Semi-transparent scrim background
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          );
        });
  }

  void _onResult() {
    if (widget.viewModel.login.completed) {
      widget.viewModel.login.clearResult();
      context.go(Routes.home);
    }

    if (widget.viewModel.continueWithoutAccount.completed) {
      widget.viewModel.continueWithoutAccount.clearResult();
      context.go(Routes.home);
    }

    if (widget.viewModel.login.error) {
      widget.viewModel.login.clearResult();

      const snackBar = SnackBar(
        content: Text('Error happened'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (widget.viewModel.continueWithoutAccount.error) {
      widget.viewModel.continueWithoutAccount.clearResult();

      const snackBar = SnackBar(
        content: Text('Error happened!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
