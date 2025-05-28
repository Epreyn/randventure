import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/combat_controller.dart';
import '../controllers/combat_animation_controller.dart';

class ActionIndicatorWidget extends StatelessWidget {
  final CombatController combatController;
  final CombatAnimationController animController;

  const ActionIndicatorWidget({
    Key? key,
    required this.combatController,
    required this.animController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!combatController.isFocusing.value ||
          combatController.activeCard.value == null ||
          combatController.targetCard.value == null) {
        return const SizedBox.shrink();
      }

      return Center(
        child: AnimatedBuilder(
          animation: animController.animationController,
          builder: (context, child) {
            return AnimatedOpacity(
              opacity: animController.animationController.value,
              duration: const Duration(milliseconds: 200),
              child: _buildIndicatorContent(),
            );
          },
        ),
      );
    });
  }

  Widget _buildIndicatorContent() {
    final actor = combatController.activeCard.value!;
    final target = combatController.targetCard.value!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionRow(actor, target),
          const SizedBox(height: 12),
          _buildActionLine(),
        ],
      ),
    );
  }

  Widget _buildActionRow(actor, target) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCharacterInfo(actor.name, Colors.blue),
        _buildArrowIcon(),
        _buildCharacterInfo(target.name, Colors.red),
      ],
    );
  }

  Widget _buildCharacterInfo(String name, Color color) {
    return Text(
      name,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildArrowIcon() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Icon(Icons.arrow_forward, size: 24, color: Colors.orange),
    );
  }

  Widget _buildActionLine() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
