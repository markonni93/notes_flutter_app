import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/note_material.dart';
import 'model/note_ui_model.dart';

class ListNoteCard extends StatelessWidget {
  const ListNoteCard(
      {super.key,
      required ListNoteUiModel model,
      required int index,
      required Color color})
      : _model = model,
        _index = index,
        _baseColor = color;

  final ListNoteUiModel _model;
  final int _index;
  final Color _baseColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {},
      child: Card(
          color: createMaterialColor(_baseColor)[100 * (_index % 9)],
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 12, right: 12, bottom: 4),
                  child: Text(
                    _model.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
              for (var item in _model.items.entries.take(2))
                IgnorePointer(
                    child: Row(children: [
                  Checkbox(value: item.value, onChanged: (value) {}),
                  Text(item.key,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: item.value
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough)
                          : const TextStyle())
                ]))
            ],
          )),
    );
  }
}
