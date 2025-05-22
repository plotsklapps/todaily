import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';

class JournalEntry {
  JournalEntry({
    required this.date,
    required this.title,
    required this.description,
    required this.mood,
    required this.images,
  });

  final DateTime date;
  final String title;
  final String description;
  final MoodType mood;
  final List<Uint8List?> images;
}

final Signal<String> sTitle = Signal<String>('', debugLabel: 'sTitle');

final Signal<String> sDescription = Signal<String>(
  '',
  debugLabel: 'sDescription',
);

final Signal<List<Uint8List?>> sImages = Signal<List<Uint8List?>>(
  List<Uint8List?>.filled(12, null),
);

final Signal<MoodType?> sMood = Signal<MoodType?>(
  null,
  debugLabel: 'sMood',
);

enum MoodType {
  angry(FontAwesomeIcons.faceAngry),
  sad(FontAwesomeIcons.faceSadTear),
  neutral(FontAwesomeIcons.faceMeh),
  relaxed(FontAwesomeIcons.faceSmile),
  happy(FontAwesomeIcons.faceGrin),
  excited(FontAwesomeIcons.faceGrinStars),
  confused(FontAwesomeIcons.faceFlushed),
  surprised(FontAwesomeIcons.faceSurprise),
  sick(FontAwesomeIcons.faceDizzy),
  sleepy(FontAwesomeIcons.faceTired),
  loving(FontAwesomeIcons.faceKiss),
  worried(FontAwesomeIcons.faceFrownOpen);

  const MoodType(this.icon);

  final IconData icon;
}
