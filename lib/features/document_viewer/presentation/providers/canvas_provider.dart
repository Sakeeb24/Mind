import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:mindspace/config/constants.dart';
import 'package:mindspace/features/document_viewer/data/repositories/hive_canvas_repository.dart';
import 'package:mindspace/features/document_viewer/domain/entities/canvas_card.dart';
import 'package:mindspace/features/document_viewer/domain/repositories/canvas_repository.dart';
import 'package:mindspace/providers/ai_service_provider.dart';
import 'package:mindspace/services/ai/ai_service.dart';

class _InMemoryCanvasRepository implements CanvasRepository {
  final Map<String, CanvasCard> _store = {};

  @override
  Future<List<CanvasCard>> getCards(String documentId) async {
    return _store.values.where((c) => c.documentId == documentId).toList();
  }

  @override
  Future<void> saveCard(CanvasCard card) async {
    _store[card.id] = card;
  }

  @override
  Future<void> deleteCard(String cardId) async {
    _store.remove(cardId);
  }

  @override
  Future<void> updateCardPosition(String cardId, double posX, double posY) async {
    final card = _store[cardId];
    if (card != null) {
      _store[cardId] = card.copyWith(posX: posX, posY: posY);
    }
  }

  @override
  Future<void> clearCanvas(String documentId) async {
    _store.removeWhere((_, c) => c.documentId == documentId);
  }
}

final canvasRepositoryProvider = Provider<CanvasRepository>((ref) {
  try {
    final box = Hive.box(AppConstants.canvasCardsBox);
    return HiveCanvasRepository(box);
  } catch (_) {
    return _InMemoryCanvasRepository();
  }
});

class CanvasState {
  const CanvasState({
    this.cards = const [],
    this.selectedCardId,
    this.isConnectingMode = false,
    this.connectingFromCardId,
    this.isAiProcessingCardId,
    this.scale = 1.0,
  });

  final List<CanvasCard> cards;
  final String? selectedCardId;
  final bool isConnectingMode;
  final String? connectingFromCardId;
  final String? isAiProcessingCardId;
  final double scale;

  CanvasState copyWith({
    List<CanvasCard>? cards,
    String? selectedCardId,
    bool clearSelectedCard = false,
    bool? isConnectingMode,
    String? connectingFromCardId,
    bool clearConnectingFrom = false,
    String? isAiProcessingCardId,
    bool clearAiProcessing = false,
    double? scale,
  }) {
    return CanvasState(
      cards: cards ?? this.cards,
      selectedCardId: clearSelectedCard ? null : (selectedCardId ?? this.selectedCardId),
      isConnectingMode: isConnectingMode ?? this.isConnectingMode,
      connectingFromCardId: clearConnectingFrom ? null : (connectingFromCardId ?? this.connectingFromCardId),
      isAiProcessingCardId: clearAiProcessing ? null : (isAiProcessingCardId ?? this.isAiProcessingCardId),
      scale: scale ?? this.scale,
    );
  }
}

class CanvasNotifier extends Notifier<CanvasState> {
  @override
  CanvasState build() => const CanvasState();

  Future<void> loadCards(String documentId) async {
    final repo = ref.read(canvasRepositoryProvider);
    final cards = await repo.getCards(documentId);
    state = state.copyWith(cards: cards);
  }

  Future<CanvasCard> addExcerpt({
    required String documentId,
    required String content,
    required int pageNumber,
    String? title,
    double? anchorX,
    double? anchorY,
    String color = '#1E293B', // Stitch Navy Slate
  }) async {
    final repo = ref.read(canvasRepositoryProvider);
    final offsetCount = state.cards.length;
    final card = CanvasCard(
      id: 'card_${DateTime.now().millisecondsSinceEpoch}',
      documentId: documentId,
      type: CanvasCardType.textExcerpt,
      title: title ?? 'Excerpt (p. $pageNumber)',
      content: content,
      pageNumber: pageNumber,
      anchorX: anchorX ?? 0.5,
      anchorY: anchorY ?? 0.5,
      posX: 40.0 + (offsetCount % 4) * 30.0,
      posY: 40.0 + (offsetCount % 6) * 70.0,
      color: color,
      createdAt: DateTime.now(),
    );

    await repo.saveCard(card);
    state = state.copyWith(cards: [...state.cards, card], selectedCardId: card.id);
    return card;
  }

  Future<CanvasCard> addStickyNote({
    required String documentId,
    required String content,
    required int pageNumber,
    String? title,
    String color = '#1E293B',
  }) async {
    final repo = ref.read(canvasRepositoryProvider);
    final offsetCount = state.cards.length;
    final card = CanvasCard(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      documentId: documentId,
      type: CanvasCardType.stickyNote,
      title: title ?? 'Note (p. $pageNumber)',
      content: content,
      pageNumber: pageNumber,
      posX: 50.0 + (offsetCount % 4) * 30.0,
      posY: 50.0 + (offsetCount % 6) * 70.0,
      color: color,
      createdAt: DateTime.now(),
    );

    await repo.saveCard(card);
    state = state.copyWith(cards: [...state.cards, card], selectedCardId: card.id);
    return card;
  }

  Future<CanvasCard> addSummaryCard({
    required String documentId,
    required String summary,
    required int pageNumber,
    String color = '#1E293B',
  }) async {
    final repo = ref.read(canvasRepositoryProvider);
    final offsetCount = state.cards.length;
    final card = CanvasCard(
      id: 'summary_${DateTime.now().millisecondsSinceEpoch}',
      documentId: documentId,
      type: CanvasCardType.aiSummary,
      title: '✦ AI Summary (p. $pageNumber)',
      content: summary,
      pageNumber: pageNumber,
      posX: 45.0 + (offsetCount % 4) * 20.0,
      posY: 45.0 + (offsetCount % 6) * 60.0,
      width: 280.0,
      color: color,
      createdAt: DateTime.now(),
    );

    await repo.saveCard(card);
    state = state.copyWith(cards: [...state.cards, card], selectedCardId: card.id);
    return card;
  }

  Future<CanvasCard> addConceptCard({
    required String documentId,
    required String title,
    required String content,
    required int pageNumber,
    String? formulaOrDefinition,
    String color = '#1E293B',
  }) async {
    final repo = ref.read(canvasRepositoryProvider);
    final offsetCount = state.cards.length;
    final card = CanvasCard(
      id: 'concept_${DateTime.now().millisecondsSinceEpoch}',
      documentId: documentId,
      type: CanvasCardType.conceptCard,
      title: title,
      content: content,
      pageNumber: pageNumber,
      posX: 50.0 + (offsetCount % 4) * 25.0,
      posY: 50.0 + (offsetCount % 6) * 65.0,
      width: 270.0,
      color: color,
      createdAt: DateTime.now(),
    );

    await repo.saveCard(card);
    state = state.copyWith(cards: [...state.cards, card], selectedCardId: card.id);
    return card;
  }

  void updateCardPosition(String cardId, double posX, double posY) {
    state = state.copyWith(
      cards: state.cards.map((c) {
        if (c.id == cardId) {
          return c.copyWith(posX: posX, posY: posY);
        }
        return c;
      }).toList(),
    );
  }

  Future<void> persistCardPosition(String cardId, double posX, double posY) async {
    final repo = ref.read(canvasRepositoryProvider);
    await repo.updateCardPosition(cardId, posX, posY);
  }

  Future<void> updateCardContent(String cardId, String content, {String? title}) async {
    final repo = ref.read(canvasRepositoryProvider);
    final card = state.cards.firstWhere((c) => c.id == cardId);
    final updated = card.copyWith(content: content, title: title ?? card.title);
    await repo.saveCard(updated);
    state = state.copyWith(
      cards: state.cards.map((c) => c.id == cardId ? updated : c).toList(),
    );
  }

  Future<void> deleteCard(String cardId) async {
    final repo = ref.read(canvasRepositoryProvider);
    await repo.deleteCard(cardId);
    state = state.copyWith(
      cards: state.cards.where((c) => c.id != cardId).toList(),
      clearSelectedCard: state.selectedCardId == cardId,
    );
  }

  void selectCard(String? cardId) {
    state = state.copyWith(selectedCardId: cardId, clearSelectedCard: cardId == null);
  }

  Future<void> toggleConnection(String fromCardId, String toCardId) async {
    if (fromCardId == toCardId) return;
    final repo = ref.read(canvasRepositoryProvider);
    final fromCard = state.cards.firstWhere((c) => c.id == fromCardId);
    final currentLinks = List<String>.from(fromCard.connectedCardIds);

    if (currentLinks.contains(toCardId)) {
      currentLinks.remove(toCardId);
    } else {
      currentLinks.add(toCardId);
    }

    final updated = fromCard.copyWith(connectedCardIds: currentLinks);
    await repo.saveCard(updated);
    state = state.copyWith(
      cards: state.cards.map((c) => c.id == fromCardId ? updated : c).toList(),
      clearConnectingFrom: true,
      isConnectingMode: false,
    );
  }

  void startConnecting(String fromCardId) {
    state = state.copyWith(
      isConnectingMode: true,
      connectingFromCardId: fromCardId,
    );
  }

  Future<void> updateCardColor(String cardId, String color) async {
    final card = state.cards.firstWhere((c) => c.id == cardId);
    final repo = ref.read(canvasRepositoryProvider);
    final updated = card.copyWith(color: color);
    await repo.saveCard(updated);
    state = state.copyWith(
      cards: state.cards.map((c) => c.id == cardId ? updated : c).toList(),
    );
  }

  void cancelConnecting() {
    state = state.copyWith(
      isConnectingMode: false,
      clearConnectingFrom: true,
    );
  }

  /// AI Supercharger: Run AI explanation / synthesis on a specific excerpt card
  Future<void> explainCardWithAi(String cardId, {AIService? aiService}) async {
    final card = state.cards.firstWhere((c) => c.id == cardId);
    state = state.copyWith(isAiProcessingCardId: cardId);

    try {
      final AIService service = aiService ?? ref.read(aiServiceProvider);
      final explanation = await service.explainExcerpt(
        excerpt: card.content,
        documentContext: 'Card: ${card.title ?? ''}\nContent: ${card.content}',
      );

      final repo = ref.read(canvasRepositoryProvider);
      final updated = card.copyWith(aiExplanation: explanation);
      await repo.saveCard(updated);

      state = state.copyWith(
        cards: state.cards.map((c) => c.id == cardId ? updated : c).toList(),
        clearAiProcessing: true,
      );
    } catch (_) {
      state = state.copyWith(clearAiProcessing: true);
    }
  }
}

final canvasProvider = NotifierProvider<CanvasNotifier, CanvasState>(
  CanvasNotifier.new,
);
