import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mindspace/config/env.dart';
import 'package:mindspace/services/ai/ai_usage_tracker.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for testing
    if (!Hive.isAdapterRegistered(0)) {
      Hive.init('__test_hive__');
    }
    await AiUsageTracker.ensureBox();
  });

  setUp(() {
    AiUsageTracker.reset();
  });

  group('AiUsageTracker', () {
    test('getUsedToday returns 0 on fresh start', () {
      final used = AiUsageTracker.getUsedToday();
      expect(used, 0);
    });

    test('getRemaining returns full limit on fresh start', () {
      final remaining = AiUsageTracker.getRemaining();
      expect(remaining, Env.freeDailyQueryLimit);
    });

    test('isLimitReached returns false when under limit', () {
      expect(AiUsageTracker.isLimitReached(), isFalse);
    });

    test('increment increases the counter', () {
      final result = AiUsageTracker.increment();
      expect(result, isTrue);
      expect(AiUsageTracker.getUsedToday(), 1);
    });

    test('increment returns false when limit reached', () {
      // Use up the full limit
      for (var i = 0; i < Env.freeDailyQueryLimit; i++) {
        AiUsageTracker.increment();
      }
      expect(AiUsageTracker.isLimitReached(), isTrue);
      expect(AiUsageTracker.increment(), isFalse);
    });

    test('getRemaining decreases after increment', () {
      AiUsageTracker.increment();
      AiUsageTracker.increment();
      expect(AiUsageTracker.getRemaining(), Env.freeDailyQueryLimit - 2);
    });

    test('reset clears the counter', () {
      AiUsageTracker.increment();
      AiUsageTracker.increment();
      AiUsageTracker.reset();
      expect(AiUsageTracker.getUsedToday(), 0);
    });

    test('shared limit across all AI operations', () {
      // Simulate chat using the limit
      AiUsageTracker.increment(); // chat query
      AiUsageTracker.increment(); // summarize query
      AiUsageTracker.increment(); // flashcard query

      // All share the same counter
      expect(AiUsageTracker.getUsedToday(), 3);
      expect(AiUsageTracker.getRemaining(), Env.freeDailyQueryLimit - 3);
    });
  });
}
