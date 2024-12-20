import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';

import '../../util/note_material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key,
      required TextNoteUiModel model,
      required int index,
      required Color color})
      : _model = model,
        _index = index,
        _baseColor = color;

  final TextNoteUiModel _model;
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
              Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    _model.note,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
        ));
  }
}
