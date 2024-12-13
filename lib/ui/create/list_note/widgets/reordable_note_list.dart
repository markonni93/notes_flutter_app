import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/model/note_list_ui_model.dart';

class ReorderableNoteList extends StatefulWidget {
  const ReorderableNoteList({super.key});

  @override
  State<ReorderableNoteList> createState() => _ReorderableNoteListState();
}

class _ReorderableNoteListState extends State<ReorderableNoteList> {
  List<NoteListUiModel> _listItems = [];
  final _animatedListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return AnimatedList(
      key: _animatedListKey,
      initialItemCount: _listItems.length,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        return SizeTransition(
            sizeFactor: animation,
            child: myListItem(
                _listItems[index], index, oddItemColor, evenItemColor));
      },
    );
  }

  Widget myListItem(NoteListUiModel item, int index, Color oddItemColor,
      Color evenItemColor) {
    return ListTile(
        leading: Checkbox(
            value: item.isChecked,
            onChanged: (value) => {
                  setState(() {
                    _listItems[index] =
                        _listItems[index].copyWith(isChecked: value);
                    _listItems.sort((a, b) {
                      if (a.isChecked == b.isChecked) {
                        return 0;
                      }
                      return a.isChecked ? 1 : -1;
                    });
                  })
                }),
        trailing: IconButton(
            onPressed: () =>
                _removeItemAtIndex(index, oddItemColor, evenItemColor),
            icon: const Icon(Icons.clear)),
        title: TextField(
          key: Key(item.id),
          maxLines: 1,
          autofocus: true,
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.text,
          onSubmitted: (value) => _addNoteToListAndCreateNewItem(value, index),
        ));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _listItems.add(
          NoteListUiModel(id: const Uuid().v1(), text: "", isChecked: false));
      _animatedListKey.currentState?.insertItem(0);
    });
  }

  _removeItemAtIndex(int index, Color oddItemColor, Color evenItemColor) {
    setState(() {
      if (index > 0) {
        var removedItem = _listItems.removeAt(index);
        _animatedListKey.currentState?.removeItem(
            index,
            (context, animation) => SizeTransition(
                sizeFactor: animation,
                child: myListItem(
                    removedItem, index, oddItemColor, evenItemColor)));
      }
    });
  }

  _addNoteToListAndCreateNewItem(String text, int index) {
    setState(() {
      _listItems[index] = _listItems[index].copyWith(text: text);
      _listItems.insert(index + 1,
          NoteListUiModel(id: const Uuid().v1(), text: "", isChecked: false));
      _animatedListKey.currentState?.insertItem(index + 1);
    });
  }
}
