import 'package:firebase_ai/firebase_ai.dart';
import 'package:signals/signals_flutter.dart';

// Declare the global signal for the GenerativeModel
final Signal<GenerativeModel?> sGenerativeModel = Signal<GenerativeModel?>(
  null, // Initialize with null
  debugLabel: 'sGenerativeModel',
);
