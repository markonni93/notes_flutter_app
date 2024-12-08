import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/data/repositories/auth/auth_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold();

      // BlocProvider<SettingsBloc>(
      //   create: (BuildContext context) => SettingsBloc(
      //       repository:
      //           RepositoryProvider.of<AuthRepository>(context))
      //     ..add(OnInitSettingsScreen()),
      //   child:
      //       BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      //     return Column(children: [
      //       Padding(
      //           padding: const EdgeInsets.only(top: 32),
      //           child: ClipOval(
      //             child: Image.network(
      //               state.user?.photo == null ? "" : state.user!.photo!,
      //               width: 100,
      //               height: 100,
      //               fit: BoxFit.cover,
      //               loadingBuilder: (context, child, loadingProgress) {
      //                 if (loadingProgress == null) {
      //                   return child;
      //                 }
      //                 return const Center(
      //                   child: CircularProgressIndicator(),
      //                 );
      //               },
      //               errorBuilder: (context, error, stackTrace) {
      //                 return const Center(
      //                   child: Icon(
      //                     Icons.error,
      //                     // Show an error icon if the image fails to load
      //                     color: Colors.red,
      //                   ),
      //                 );
      //               },
      //             ),
      //           )),
      //       ElevatedButton(
      //           onPressed: () =>
      //               context.read<SettingsBloc>().add(OnLogoutClicked()),
      //           child: const Text("Logout user"))
      //     ]);
      //   }));
  }
}
