import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app.dart';
import 'config/constants.dart';
import 'config/env.dart';
import 'core/services/file_upload_service.dart';
import 'services/ai/ai_usage_tracker.dart';
import 'features/auth/data/repositories/puter_auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Open all required Hive boxes
  await Hive.openBox(AppConstants.documentsBox);
  await Hive.openBox(AppConstants.foldersBox);
  await Hive.openBox(AppConstants.highlightsBox);
  await Hive.openBox(AppConstants.notesBox);
  await Hive.openBox(AppConstants.chatHistoryBox);
  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox(AppConstants.summariesBox);
  await Hive.openBox(AppConstants.canvasCardsBox);

  // Ensure web PDF persistence box is opened
  await FileUploadService.ensureWebPdfsBox();

  // Ensure AI usage tracker box is opened
  await AiUsageTracker.ensureBox();

  // Load Puter auth token from secure storage if not provided via dart-define
  const secureStorage = FlutterSecureStorage();
  var puterToken = Env.puterAuthToken;
  if (puterToken.isEmpty) {
    puterToken = await secureStorage.read(key: 'puter_auth_token') ?? '';
  }

  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          PuterAuthRepository(initialToken: puterToken),
        ),
      ],
      child: const MindSpaceApp(),
    ),
  );
}
