import 'package:flutter_test/flutter_test.dart';
import 'package:mindspace/features/folders/domain/entities/folder.dart';

void main() {
  final fixedDate = DateTime.utc(2024);

  group('Folder', () {
    test('copyWith preserves unchanged fields', () {
      final folder = Folder(id: '1', name: 'Original', color: '#FF0000', createdAt: fixedDate);
      final updated = folder.copyWith(name: 'New Name');
      expect(updated.name, 'New Name');
      expect(updated.color, '#FF0000');
      expect(updated.id, '1');
    });

    test('equality is based on id', () {
      final f1 = Folder(id: '1', name: 'A', createdAt: fixedDate);
      final f2 = Folder(id: '1', name: 'B', createdAt: DateTime.utc(2025));
      final f3 = Folder(id: '2', name: 'A', createdAt: fixedDate);
      expect(f1, equals(f2));
      expect(f1 == f3, isFalse);
    });
  });
}
