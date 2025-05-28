// lib/widgets/swipeable_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/card_model.dart';
import '../models/skill.dart';
import 'card_widget.dart';

/// Widget stateless qui gère un drag horizontal avec rotation légère
/// et affiche en preview la compétence active (nom + description).
class SwipeableCard extends StatelessWidget {
  final CardModel card;
  final void Function(String direction) onSwipe;

  // --- État réactif local au widget (jamais de StatefulWidget) ---
  final RxDouble _dragDx = 0.0.obs;
  final RxBool _showPreview = false.obs;
  final RxString _previewDir = ''.obs;
  final Rx<Skill?> _previewSkill = Rx<Skill?>(null);

  SwipeableCard({Key? key, required this.card, required this.onSwipe})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Largeur de l'écran pour calculer le seuil et l'angle
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.25;
    const maxAngle = 0.5; // en radians

    return Obx(() {
      final dx = _dragDx.value;
      final preview = _showPreview.value;
      final skill = _previewSkill.value;
      final angle = (dx / screenWidth) * maxAngle;

      return GestureDetector(
        onPanUpdate: (details) {
          // Mise à jour du déplacement
          _dragDx.value += details.delta.dx;
          final screenWidth = MediaQuery.of(context).size.width;
          final threshold = screenWidth * 0.25;
          if (_dragDx.value.abs() > threshold) {
            _showPreview.value = true;
            if (_dragDx.value >= 0) {
              _previewDir.value = 'right';
              _previewSkill.value = card.rightSkill;
            } else {
              _previewDir.value = 'left';
              _previewSkill.value = card.leftSkill;
            }
          } else {
            _showPreview.value = false;
          }
        },
        onPanEnd: (_) {
          // Si on dépasse le seuil, on déclenche le swipe
          if (_dragDx.value.abs() > threshold) {
            onSwipe(_previewDir.value);
          }
          // Toujours remettre à zéro et cacher le preview
          _dragDx.value = 0;
          _showPreview.value = false;
        },
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Carte déplacée + pivotée
            Transform.translate(
              offset: Offset(dx, 0),
              child: Transform.rotate(
                angle: angle,
                child: CardWidget(card: card),
              ),
            ),
            // Preview de la compétence en bas
            if (preview && skill != null)
              Positioned(
                bottom: 16,
                child: Container(
                  width: screenWidth * 0.6,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        skill.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skill.description,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
