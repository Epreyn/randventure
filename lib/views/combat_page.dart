import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/combat_controller.dart';
import '../widgets/card_stack_widget.dart';
import '../widgets/card_widget.dart';

class CombatPage extends StatelessWidget {
  final CombatController controller = Get.find();

  CombatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // 1) Mode focus : on centre actor & target, on cache les piles
        if (controller.isFocusing.value) {
          final actor = controller.activeCard.value!;
          final target = controller.targetCard.value!;

          return Stack(
            children: [
              // Dimming de fond
              Positioned.fill(child: Container(color: Colors.black54)),
              // Carte acteur à gauche
              Align(
                alignment: Alignment.centerLeft,
                child: CardWidget(card: actor),
              ),
              // Carte cible à droite
              Align(
                alignment: Alignment.centerRight,
                child: CardWidget(card: target),
              ),
            ],
          );
        }

        // 2) Mode résultat (fin de combat)
        if (controller.result.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.result.value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        }

        // 3) Mode normal : affichage des piles
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Pile ennemie (statique)
              CardStackWidget(
                cards: controller.enemyCards,
                swipeEnabled: false,
                onSwipe: (_) {},
              ),

              // Pile joueur (swipeable)
              CardStackWidget(
                cards: controller.playerCards,
                onSwipe: (dir) {
                  if (dir == 'left')
                    controller.onSwipeLeft();
                  else
                    controller.onSwipeRight();
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
