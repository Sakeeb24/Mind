import 'package:hive_ce/hive.dart';
import 'package:mindspace/features/document_viewer/domain/entities/canvas_card.dart';
import 'package:mindspace/features/document_viewer/domain/repositories/canvas_repository.dart';

class HiveCanvasRepository implements CanvasRepository {
  HiveCanvasRepository(this._box);

  final Box _box;

  @override
  Future<List<CanvasCard>> getCards(String documentId) async {
    final List<CanvasCard> cards = [];
    for (var i = 0; i < _box.length; i++) {
      final raw = _box.getAt(i);
      if (raw is Map) {
        final card = CanvasCard.fromMap(raw);
        if (card.documentId == documentId) {
          cards.add(card);
        }
      }
    }
    return cards;
  }

  @override
  Future<void> saveCard(CanvasCard card) async {
    await _box.put(card.id, card.toMap());
  }

  @override
  Future<void> deleteCard(String cardId) async {
    await _box.delete(cardId);
  }

  @override
  Future<void> updateCardPosition(String cardId, double posX, double posY) async {
    final raw = _box.get(cardId);
    if (raw is Map) {
      final card = CanvasCard.fromMap(raw).copyWith(posX: posX, posY: posY);
      await _box.put(cardId, card.toMap());
    }
  }

  @override
  Future<void> clearCanvas(String documentId) async {
    final keysToDelete = <dynamic>[];
    for (var key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map && raw['documentId'] == documentId) {
        keysToDelete.add(key);
      }
    }
    await _box.deleteAll(keysToDelete);
  }
}
