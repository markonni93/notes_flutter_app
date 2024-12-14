import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/ui/core/model/note_list_ui_model.dart';

class ListNoteItemWidget extends StatefulWidget {
  const ListNoteItemWidget(
      {super.key,
      required this.item,
      required this.removeItem,
      required this.insertNewItem,
      required this.checkItem});

  final NoteListUiModel item;
  final Function() removeItem;
  final Function(String val) insertNewItem;
  final Function(bool isChecked) checkItem;

  @override
  State<ListNoteItemWidget> createState() => _ListNoteItemWidgetState();
}

class _ListNoteItemWidgetState extends State<ListNoteItemWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Checkbox(
            value: widget.item.isChecked,
            onChanged: (isChecked) => widget.checkItem(isChecked == true)),
        trailing: IconButton(
            onPressed: () => widget.removeItem(),
            icon: const Icon(Icons.clear)),
        title: TextField(
          controller: controller,
          maxLines: 1,
          autofocus: true,
          textInputAction: TextInputAction.go,
          keyboardType: TextInputType.text,
          onSubmitted: (value) => widget.insertNewItem(value),
        ));
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.item.text;
  }

  @override
  void dispose() {
    controller.dispose;
    super.dispose();
  }
}
