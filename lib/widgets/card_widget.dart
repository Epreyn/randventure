// lib/widgets/card_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/card_model.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;

  const CardWidget({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.4;
    double height = width * 1.4;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 4)),
        ],
      ),
      child: Stack(
        children: [
          // Name top-left
          Positioned(
            left: 8,
            top: 8,
            child: Text(
              card.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // HP top-right
          Positioned(
            right: 8,
            top: 8,
            child: Obx(
              () => Text(
                '${card.hp.value} / ${card.maxHp} HP',
                style: const TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
