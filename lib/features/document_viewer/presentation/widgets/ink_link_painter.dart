import 'package:flutter/material.dart';
import 'package:mindspace/features/document_viewer/domain/entities/canvas_card.dart';

class InkLinkPainter extends CustomPainter {
  InkLinkPainter({
    required this.cards,
    required this.selectedCardId,
    required this.isConnectingMode,
    this.connectingFromCardId,
  });

  final List<CanvasCard> cards;
  final String? selectedCardId;
  final bool isConnectingMode;
  final String? connectingFromCardId;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw connections between cards (Mind-map links)
    for (final fromCard in cards) {
      for (final toCardId in fromCard.connectedCardIds) {
        final toCard = cards.where((c) => c.id == toCardId).firstOrNull;
        if (toCard != null) {
          _drawCurvedLink(
            canvas: canvas,
            start: Offset(fromCard.posX + fromCard.width, fromCard.posY + 40),
            end: Offset(toCard.posX, toCard.posY + 40),
            color: const Color(0xFF6C5CE7).withAlpha(180),
            strokeWidth: 2.5,
            isDashed: false,
          );
        }
      }
    }

    // 2. Draw active connecting line if in connecting mode
    if (isConnectingMode && connectingFromCardId != null) {
      final fromCard = cards.where((c) => c.id == connectingFromCardId).firstOrNull;
      if (fromCard != null) {
        final paint = Paint()
          ..color = const Color(0xFFFF7675)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

        // Visual pulse ring around source card
        canvas.drawCircle(
          Offset(fromCard.posX + fromCard.width / 2, fromCard.posY + 40),
          16.0,
          paint,
        );
      }
    }
  }

  void _drawCurvedLink({
    required Canvas canvas,
    required Offset start,
    required Offset end,
    required Color color,
    double strokeWidth = 2.0,
    bool isDashed = false,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(start.dx, start.dy);

    final dx = (end.dx - start.dx).abs();
    final controlPoint1 = Offset(start.dx + dx * 0.5, start.dy);
    final controlPoint2 = Offset(end.dx - dx * 0.5, end.dy);

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      end.dx,
      end.dy,
    );

    canvas.drawPath(path, paint);

    // Draw end anchor circle
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(end, 4.5, dotPaint);
    canvas.drawCircle(start, 4.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant InkLinkPainter oldDelegate) {
    return true; // Always repaint on drag/state change for smooth 60fps tracking
  }
}
