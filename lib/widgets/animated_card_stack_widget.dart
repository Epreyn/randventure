import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randventure/models/card_model.dart';
import '../controllers/combat_animation_controller.dart';
import '../widgets/card_stack_widget.dart';

enum CardAnimationType { actor, target }

class AnimatedCardStack extends StatelessWidget {
  final RxList<CardModel> cards;
  final bool swipeEnabled;
  final Function(String) onSwipe;
  final CardAnimationType animationType;
  final bool isActive;

  const AnimatedCardStack({
    Key? key,
    required this.cards,
    required this.swipeEnabled,
    required this.onSwipe,
    required this.animationType,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CombatAnimationController animController = Get.find();

    return AnimatedBuilder(
      animation: animController.animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_getTranslateX(animController), 0),
          child: Transform.scale(
            scale: _getScale(animController),
            child: CardStackWidget(
              cards: cards,
              swipeEnabled: swipeEnabled,
              onSwipe: onSwipe,
            ),
          ),
        );
      },
    );
  }

  double _getTranslateX(CombatAnimationController animController) {
    if (!isActive) return 0.0;

    return animationType == CardAnimationType.actor
        ? animController.getActorTranslateX()
        : animController.getTargetTranslateX();
  }

  double _getScale(CombatAnimationController animController) {
    if (!isActive) return 1.0;
    return animController.getScaleValue();
  }
}
