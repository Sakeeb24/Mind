import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'config/constants.dart';
import 'config/env.dart';
import 'features/auth/data/repositories/supabase_auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );

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

  final supabaseClient = Supabase.instance.client;

  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          SupabaseAuthRepository(supabaseClient),
        ),
      ],
      child: const MindSpaceApp(),
    ),
  );
}