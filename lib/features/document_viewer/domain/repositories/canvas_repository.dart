import 'package:mindspace/features/document_viewer/domain/entities/canvas_card.dart';

abstract class CanvasRepository {
  Future<List<CanvasCard>> getCards(String documentId);
  Future<void> saveCard(CanvasCard card);
  Future<void> deleteCard(String cardId);
  Future<void> updateCardPosition(String cardId, double posX, double posY);
  Future<void> clearCanvas(String documentId);
}
