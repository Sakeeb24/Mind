import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mindspace/services/cloud/puter_kv_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late PuterKVService kvService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    kvService = PuterKVService(mockDio);
  });

  group('PuterKVService', () {
    test('set returns false when token is empty', () async {
      final result = await kvService.set(
        token: '',
        key: 'test-key',
        value: 'test-value',
      );
      expect(result, isFalse);
    });

    test('get returns null when token is empty', () async {
      final result = await kvService.get(
        token: '',
        key: 'test-key',
      );
      expect(result, isNull);
    });

    test('del returns false when token is empty', () async {
      final result = await kvService.del(
        token: '',
        key: 'test-key',
      );
      expect(result, isFalse);
    });

    test('listKeys returns empty when token is empty', () async {
      final result = await kvService.listKeys(token: '');
      expect(result, isEmpty);
    });

    test('getDocument returns null when token is empty', () async {
      final result = await kvService.getDocument('', 'doc1');
      expect(result, isNull);
    });

    test('saveDocument returns false when token is empty', () async {
      final result = await kvService.saveDocument('', 'doc1', {'title': 'test'});
      expect(result, isFalse);
    });

    test('getHighlights returns empty list when token is empty', () async {
      final result = await kvService.getHighlights('', 'doc1');
      expect(result, isEmpty);
    });

    test('saveHighlights returns false when token is empty', () async {
      final result = await kvService.saveHighlights('', 'doc1', []);
      expect(result, isFalse);
    });

    test('getChatHistory returns empty list when token is empty', () async {
      final result = await kvService.getChatHistory('', 'doc1');
      expect(result, isEmpty);
    });

    test('listDocumentIds returns empty when token is empty', () async {
      final result = await kvService.listDocumentIds('');
      expect(result, isEmpty);
    });

    test('listFolderIds returns empty when token is empty', () async {
      final result = await kvService.listFolderIds('');
      expect(result, isEmpty);
    });

    test('getSettings returns null when token is empty', () async {
      final result = await kvService.getSettings('');
      expect(result, isNull);
    });
  });
}
