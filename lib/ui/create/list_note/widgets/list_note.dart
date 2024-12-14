import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/model/note_list_ui_model.dart';
import 'list_note_item.dart';

class ListNote extends StatefulWidget {
  const ListNote({super.key});

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  final List<NoteListUiModel> _listItems = [];
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
        return _buildItem(
            _listItems[index], index, animation, oddItemColor, evenItemColor);
      },
    );
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

  void _onItemChecked(NoteListUiModel item, int oldIndex, bool isChecked,
      Color oddItemColor, Color evenItemColor) {
    setState(() {
      _listItems[oldIndex] =
          _listItems[oldIndex].copyWith(isChecked: isChecked);

      var removedItem = _listItems.removeAt(oldIndex);

      if (isChecked) {
        _listItems.add(removedItem);
        _animatedListKey.currentState?.removeItem(
          oldIndex,
          (context, animation) => _buildItem(
              item, oldIndex, animation, oddItemColor, evenItemColor),
        );
        _animatedListKey.currentState?.insertItem(_listItems.length - 1);
      } else {
        _listItems.insert(0, removedItem);
        _animatedListKey.currentState?.removeItem(
          oldIndex,
          (context, animation) => _buildItem(
              removedItem, oldIndex, animation, oddItemColor, evenItemColor),
        );
        _animatedListKey.currentState?.insertItem(0);
      }
    });
  }

  _removeItemAtIndex(int index, Color oddItemColor, Color evenItemColor) {
    setState(() {
      if (index > 0) {
        var removedItem = _listItems.removeAt(index);
        _animatedListKey.currentState?.removeItem(
            index,
            (context, animation) => _buildItem(
                removedItem, index, animation, oddItemColor, evenItemColor));
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

  SizeTransition _buildItem(NoteListUiModel item, int index,
      Animation<double> animation, Color oddItemColor, Color evenItemColor) {
    return SizeTransition(
        key: Key(item.id),
        sizeFactor: animation,
        child: ListNoteItemWidget(
          item: item,
          removeItem: () =>
              _removeItemAtIndex(index, oddItemColor, evenItemColor),
          insertNewItem: (value) =>
              _addNoteToListAndCreateNewItem(value, index),
          checkItem: (value) =>
              {_onItemChecked(item, index, value, oddItemColor, evenItemColor)},
        ));
  }
}
