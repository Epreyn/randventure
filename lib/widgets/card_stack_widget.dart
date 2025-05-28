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

  const CardStackWidget({
    Key? key,
    required this.cards,
    required this.onSwipe,
    this.swipeEnabled = true,
    this.offsetX = 24.0,
    this.offsetY = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cards.isEmpty) return const SizedBox.shrink();

      List<Widget> stackItems = [];
      int n = cards.length;

      for (int i = 0; i < n; i++) {
        int idx = n - 1 - i;
        final card = cards[idx];
        Widget widgetCard;

        if (idx == 0 && swipeEnabled) {
          widgetCard = SwipeableCard(
            card: card,
            onSwipe: (dir) {
              final removed = cards.removeAt(0);
              if (removed.isAlive) {
                cards.insert(0, removed);
              }

              onSwipe(dir);
            },
          );
        } else {
          widgetCard = CardWidget(card: card);
        }

        stackItems.add(
          Transform.translate(
            offset: Offset(-i * offsetX, i * offsetY),
            child: widgetCard,
          ),
        );
      }

      return Stack(children: stackItems);
    });
  }
}
