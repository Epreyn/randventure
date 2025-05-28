import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/combat_controller.dart';
import '../controllers/combat_animation_controller.dart';

class FocusOverlayWidget extends StatelessWidget {
  final CombatAnimationController animController;

  const FocusOverlayWidget({Key? key, required this.animController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CombatController combatController = Get.find();

    return Obx(() {
      if (!combatController.isFocusing.value) {
        return const SizedBox.shrink();
      }

      return AnimatedBuilder(
        animation: animController.animationController,
        builder: (context, child) {
          return Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(
                animController.getBackgroundOpacity(),
              ),
            ),
          );
        },
      );
    });
  }
}
