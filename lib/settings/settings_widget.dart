import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/auth/repository/auth_repository.dart';
import 'package:quick_notes/settings/settings_bloc.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
        create: (BuildContext context) => SettingsBloc(
            repository:
                RepositoryProvider.of<AuthenticationRepository>(context))
          ..add(OnInitSettingsScreen()),
        child:
            BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          return Column(children: [
            Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ClipOval(
                  child: Image.network(
                    state.user?.photo == null ? "" : state.user!.photo!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          // Show an error icon if the image fails to load
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                )),
            ElevatedButton(
                onPressed: () =>
                    context.read<SettingsBloc>().add(OnLogoutClicked()),
                child: const Text("Logout user"))
          ]);
        }));
  }
}
