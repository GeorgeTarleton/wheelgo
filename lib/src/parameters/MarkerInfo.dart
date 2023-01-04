import 'package:wheelgo/src/enums/AttractionType.dart';

class MarkerInfo {
  MarkerInfo({
    required this.id,
    required this.type,
    this.selected = false,
  });

  final int id;
  final AttractionType type;
  bool selected;
}