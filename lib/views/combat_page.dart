import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/combat_controller.dart';
import '../controllers/combat_animation_controller.dart';
import '../widgets/card_stack_widget.dart';
import '../widgets/combat_result_widget.dart';
import '../widgets/action_indicator_widget.dart';
import '../widgets/focus_overlay_widget.dart';
import '../widgets/animated_card_stack_widget.dart';

class CombatPage extends StatelessWidget {
  final CombatController controller = Get.find();
  final CombatAnimationController animController = Get.put(
    CombatAnimationController(),
  );

  CombatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Mode résultat (fin de combat)
        if (controller.result.value.isNotEmpty) {
          return CombatResultWidget(
            result: controller.result.value,
            onRestart: controller.resetBattle,
          );
        }

        // Mode normal avec animation de focus
        return Stack(
          children: [
            // Interface principale
            _buildMainInterface(),

            // Overlay d'animation de focus
            FocusOverlayWidget(animController: animController),

            // Indicateur d'action
            ActionIndicatorWidget(
              combatController: controller,
              animController: animController,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMainInterface() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pile ennemie
          AnimatedCardStack(
            cards: controller.enemyCards,
            swipeEnabled: false,
            onSwipe: (_) {},
            animationType: CardAnimationType.target,
            isActive: _isEnemyStackActive(),
          ),

          // Pile joueur
          AnimatedCardStack(
            cards: controller.playerCards,
            swipeEnabled: !controller.isFocusing.value,
            onSwipe: _handlePlayerSwipe,
            animationType: CardAnimationType.actor,
            isActive: _isPlayerStackActive(),
          ),
        ],
      ),
    );
  }

  bool _isEnemyStackActive() {
    return controller.isFocusing.value &&
        controller.targetCard.value != null &&
        controller.enemyCards.isNotEmpty &&
        controller.targetCard.value!.id == controller.enemyCards.first.id;
  }

  bool _isPlayerStackActive() {
    return controller.isFocusing.value &&
        controller.activeCard.value != null &&
        controller.playerCards.isNotEmpty &&
        controller.activeCard.value!.id == controller.playerCards.first.id;
  }

  void _handlePlayerSwipe(String direction) {
    if (direction == 'left') {
      controller.onSwipeLeft();
    } else {
      controller.onSwipeRight();
    }
  }
}
