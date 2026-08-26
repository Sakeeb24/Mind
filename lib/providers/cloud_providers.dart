import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/env.dart';
import 'package:mindspace/services/cloud/puter_cloud_storage.dart';
import 'package:mindspace/services/cloud/puter_kv_service.dart';
import 'package:mindspace/services/cloud/cloud_sync_service.dart';

/// Dio instance dedicated to Puter cloud operations (storage + KV).
final cloudDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: Env.puterApiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );
});

/// Puter cloud storage service (PDF file persistence).
final cloudStorageProvider = Provider<PuterCloudStorage>((ref) {
  final dio = ref.read(cloudDioProvider);
  return PuterCloudStorage(dio);
});

/// Puter KV service (metadata persistence).
final kvServiceProvider = Provider<PuterKVService>((ref) {
  final dio = ref.read(cloudDioProvider);
  return PuterKVService(dio);
});

/// Cloud synchronization service (bridges Hive ↔ Puter cloud).
final cloudSyncServiceProvider = Provider<CloudSyncService>((ref) {
  return CloudSyncService(
    cloudStorage: ref.read(cloudStorageProvider),
    kvService: ref.read(kvServiceProvider),
  );
});
