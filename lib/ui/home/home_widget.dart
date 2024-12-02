import 'package:flutter/cupertino.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        key: const ValueKey(1),
        constraints: const BoxConstraints(maxWidth: 840),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250),
            itemBuilder: (BuildContext context, int index) {
              return Text("Something $index");
            }));
  }
}
