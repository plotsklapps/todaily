import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';

final Signal<Map<String, dynamic>?> sJournalEntry =
    signal<Map<String, dynamic>?>(null, debugLabel: 'sJournalEntry');

final Signal<String> sTitle = Signal<String>('', debugLabel: 'sTitle');

final Signal<String> sDescription = Signal<String>(
  '',
  debugLabel: 'sDescription',
);

final Signal<List<Uint8List?>> sImages = Signal<List<Uint8List?>>(
  List<Uint8List?>.filled(12, null),
);

final Signal<MoodType> sMood = Signal<MoodType>(
  MoodType.relaxed,
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
