class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'MindSpace';
  static const String appDescription =
      'A free, AI-powered document intelligence and study assistant for students.';

  // Limits
  static const int maxPdfSizeMb = 50;
  static const int maxPagesPerDocument = 200;
  static const int maxNoteLength = 500;
  static const int undoRedoStackDepth = 50;
  static const int freeDailyAiQueries = 20;
  static const int freeMaxDocuments = 30;

  // Hive Box Names
  static const String documentsBox = 'documents';
  static const String foldersBox = 'folders';
  static const String highlightsBox = 'highlights';
  static const String notesBox = 'notes';
  static const String chatHistoryBox = 'chat_history';
  static const String settingsBox = 'settings';
  static const String summariesBox = 'summaries';

  // Storage Keys
  static const String themeModeKey = 'theme_mode';
  static const String sortOrderKey = 'sort_order';
  static const String viewModeKey = 'view_mode';
  static const String lastDocumentIdKey = 'last_document_id';
  static const String onboardingDoneKey = 'onboarding_done';

  // Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration toastDuration = Duration(seconds: 3);
}
