import 'package:intl/intl.dart';
import 'package:signals/signals_flutter.dart';

class Now {
  final Signal<DateTime> now = Signal<DateTime>(
    DateTime.now(),
    debugLabel: 'now',
  );

  Signal<String> get day {
    return Signal<String>(DateFormat('d').format(now.value), debugLabel: 'day');
  }

  Signal<String> get suffix {
    return Signal<String>(
      _getSuffix(int.parse(day.value)),
      debugLabel: 'suffix',
    );
  }

  Signal<String> get month {
    return Signal<String>(
      DateFormat('MMMM').format(now.value),
      debugLabel: 'month',
    );
  }

  Signal<String> get year {
    return Signal<String>(
      DateFormat('yyyy').format(now.value),
      debugLabel: 'year',
    );
  }

  Signal<String> get time {
    return Signal<String>(
      DateFormat('HH:mm').format(now.value),
      debugLabel: 'time',
    );
  }

  static String _getSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
