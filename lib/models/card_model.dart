// lib/models/card_model.dart

import 'package:get/get.dart';
import 'dart:math';
import 'skill.dart';

class CardModel {
  final int id;
  final String name;
  final int maxHp;
  final RxInt hp;
  final Skill leftSkill;
  final Skill rightSkill;

  CardModel({
    required this.id,
    required this.name,
    required this.maxHp,
    required int hp,
    required this.leftSkill,
    required this.rightSkill,
  }) : hp = hp.obs;

  bool get isAlive => hp.value > 0;

  void takeDamage(int dmg) {
    hp.value = max(0, hp.value - dmg);
  }

  void heal(int amount) {
    hp.value = min(maxHp, hp.value + amount);
  }
}
