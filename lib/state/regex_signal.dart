import 'package:signals/signals_flutter.dart';

final Signal<RegExp> sEmailRegexp = Signal<RegExp>(
  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
  debugLabel: 'sEmailRegexp',
);
