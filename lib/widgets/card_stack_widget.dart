import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/card_model.dart';
import 'card_widget.dart';
import 'swipeable_card.dart';

class CardStackWidget extends StatelessWidget {
  final RxList<CardModel> cards;
  final bool swipeEnabled;
  final void Function(String direction) onSwipe;
  final double offsetX;
  final double offsetY;
  final int maxVisibleCards;

  const CardStackWidget({
    Key? key,
    required this.cards,
    required this.onSwipe,
    this.swipeEnabled = true,
    this.offsetX = 12.0,
    this.offsetY = 8.0,
    this.maxVisibleCards = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cards.isEmpty) {
        return Container(
          width: 120,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: const Center(
            child: Icon(Icons.inbox_outlined, size: 40, color: Colors.grey),
          ),
        );
      }

      return SizedBox(
        width: 140,
        height: 180,
        child: Stack(alignment: Alignment.center, children: _buildCardStack()),
      );
    });
  }

  List<Widget> _buildCardStack() {
    List<Widget> stackItems = [];
    int totalCards = cards.length;
    int visibleCards =
        totalCards > maxVisibleCards ? maxVisibleCards : totalCards;

    for (int i = 0; i < visibleCards; i++) {
      int cardIndex = totalCards - 1 - i;
      final card = cards[cardIndex];

      Widget cardWidget = _buildCardAtIndex(cardIndex, i);

      // Position des cartes avec un léger décalage
      stackItems.add(
        Transform.translate(
          offset: Offset(-i * offsetX, i * offsetY),
          child: cardWidget,
        ),
      );
    }

    // Indicateur du nombre de cartes si plus que maxVisibleCards
    if (totalCards > maxVisibleCards) {
      stackItems.add(
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '+${totalCards - maxVisibleCards}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return stackItems;
  }

  Widget _buildCardAtIndex(int cardIndex, int stackPosition) {
    final card = cards[cardIndex];

    if (cardIndex == 0 && swipeEnabled) {
      return SwipeableCard(
        card: card,
        onSwipe: (direction) {
          // La logique de rotation est gérée par le controller, pas ici
          onSwipe(direction);
        },
      );
    } else {
      return Opacity(
        opacity:
            1.0 - (stackPosition * 0.15), // Léger fade pour les cartes arrière
        child: CardWidget(card: card),
      );
    }
  }
}
