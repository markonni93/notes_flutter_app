import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key,
      required NoteUiModel model,
      required int index,
      required Color color})
      : _model = model,
        _index = index,
        _baseColor = color;

  final NoteUiModel _model;
  final int _index;
  final Color _baseColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {print("card clciked")},
        child: Card(
          color: _createMaterialColor(_baseColor)[100 * (_index % 9)],
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
              Text(
                _model.note,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
        ));
  }
}

MaterialColor _createMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: _tintColor(color, 0.9),
    100: _tintColor(color, 0.8),
    200: _tintColor(color, 0.6),
    300: _tintColor(color, 0.4),
    400: _tintColor(color, 0.2),
    500: color, // Base color
    600: _shadeColor(color, 0.1),
    700: _shadeColor(color, 0.2),
    800: _shadeColor(color, 0.3),
    900: _shadeColor(color, 0.4),
  });
}

// Helper to create lighter shades (tints)
Color _tintColor(Color color, double factor) {
  return Color.fromRGBO(
    color.red + ((255 - color.red) * factor).round(),
    color.green + ((255 - color.green) * factor).round(),
    color.blue + ((255 - color.blue) * factor).round(),
    1,
  );
}

// Helper to create darker shades
Color _shadeColor(Color color, double factor) {
  return Color.fromRGBO(
    (color.red * (1 - factor)).round(),
    (color.green * (1 - factor)).round(),
    (color.blue * (1 - factor)).round(),
    1,
  );
}
