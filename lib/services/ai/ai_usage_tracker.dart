import 'package:hive_ce/hive.dart';
import 'package:mindspace/config/env.dart';

/// Shared AI usage tracker that enforces the daily query limit across ALL AI operations.
/// Persists usage in Hive so it survives app restarts.
/// All AI features (chat, summarize, flashcards, quiz, formulas, explain) share this single counter.
class AiUsageTracker {
  static const String _boxName = 'ai_usage';
  static const String _countKey = 'daily_count';
  static const String _dateKey = 'current_date';

  /// Get the number of AI queries used today.
  static int getUsedToday() {
    try {
      final box = Hive.box(_boxName);
      final today = _todayString();
      final storedDate = box.get(_dateKey, defaultValue: '') as String;
      if (storedDate != today) {
        // New day — reset counter
        box.put(_dateKey, today);
        box.put(_countKey, 0);
        return 0;
      }
      return (box.get(_countKey, defaultValue: 0) as num).toInt();
    } catch (_) {
      return 0;
    }
  }

  /// Get the number of AI queries remaining today.
  static int getRemaining() {
    return Env.freeDailyQueryLimit - getUsedToday();
  }

  /// Check if the daily limit has been reached.
  static bool isLimitReached() {
    return getUsedToday() >= Env.freeDailyQueryLimit;
  }

  /// Increment the usage counter. Returns true if successful, false if limit reached.
  static bool increment() {
    if (isLimitReached()) return false;

    try {
      final box = Hive.box(_boxName);
      final today = _todayString();
      final storedDate = box.get(_dateKey, defaultValue: '') as String;

      if (storedDate != today) {
        box.put(_dateKey, today);
        box.put(_countKey, 1);
      } else {
        final current = (box.get(_countKey, defaultValue: 0) as num).toInt();
        box.put(_countKey, current + 1);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Ensure the Hive box is opened at app startup.
  static Future<void> ensureBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  /// Reset the counter (for testing or admin purposes).
  static void reset() {
    try {
      final box = Hive.box(_boxName);
      box.put(_countKey, 0);
      box.put(_dateKey, _todayString());
    } catch (_) {}
  }

  static String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
