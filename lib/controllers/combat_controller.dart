import 'dart:math';
import 'package:get/get.dart';
import '../models/card_model.dart';
import '../models/skill.dart';

class CombatController extends GetxController {
  final RxList<CardModel> playerCards = <CardModel>[].obs;
  final RxList<CardModel> enemyCards = <CardModel>[].obs;
  final RxString result = ''.obs;

  /// Indique qu’on est en mode “focus” (animation centrée)
  final RxBool isFocusing = false.obs;

  /// Carte qui agit pendant le focus
  final Rx<CardModel?> activeCard = Rx<CardModel?>(null);

  /// Carte cible pendant le focus
  final Rx<CardModel?> targetCard = Rx<CardModel?>(null);

  final Random _random = Random();

  @override
  void onInit() {
    super.onInit();
    _initializeBattle();
  }

  void _initializeBattle() {
    int id = 1;
    // Exemple de cartes joueur
    playerCards.assignAll([
      CardModel(
        id: id++,
        name: 'Warrior',
        maxHp: 15,
        hp: 15,
        leftSkill: Skill(
          name: 'Slash',
          description: 'Basic slash',
          type: SkillType.attack,
          target: SkillTarget.enemy,
          power: 4,
        ),
        rightSkill: Skill(
          name: 'Shield',
          description: 'Block & heal',
          type: SkillType.heal,
          target: SkillTarget.self,
          power: 2,
        ),
      ),
      CardModel(
        id: id++,
        name: 'Mage',
        maxHp: 12,
        hp: 12,
        leftSkill: Skill(
          name: 'Fireball',
          description: 'Powerful fire',
          type: SkillType.attack,
          target: SkillTarget.enemy,
          power: 5,
        ),
        rightSkill: Skill(
          name: 'Heal',
          description: 'Restore HP',
          type: SkillType.heal,
          target: SkillTarget.self,
          power: 3,
        ),
      ),
      CardModel(
        id: id++,
        name: 'Archer',
        maxHp: 10,
        hp: 10,
        leftSkill: Skill(
          name: 'Pierce',
          description: 'Fast arrow',
          type: SkillType.attack,
          target: SkillTarget.enemy,
          power: 3,
        ),
        rightSkill: Skill(
          name: 'Double Shot',
          description: 'Two arrows',
          type: SkillType.attack,
          target: SkillTarget.enemy,
          power: 5,
        ),
      ),
    ]);

    // Exemple de cartes ennemi
    enemyCards.assignAll([
      CardModel(
        id: id++,
        name: 'Goblin',
        maxHp: 10,
        hp: 10,
        leftSkill: Skill(
          name: 'Stab',
          description: 'Quick stab',
          type: SkillType.attack,
          target: SkillTarget.enemy,
          power: 3,
        ),
        rightSkill: Skill(
          name: 'Terrify',
          description: 'Self-heal',
          type: SkillType.heal,
          target: SkillTarget.self,
          power: 2,
        ),
      ),
      CardModel(
        id: id++,
        name: 'Orc',
        maxHp: 14,
        hp: 14,
        leftSkill: Skill(
          name: 'Smash',
          description: 'Heavy blow',
          type: SkillType.attack,
          target: SkillTarget.enemy,
          power: 5,
        ),
        rightSkill: Skill(
          name: 'Roar',
          description: 'Buff & heal',
          type: SkillType.heal,
          target: SkillTarget.self,
          power: 1,
        ),
      ),
      CardModel(
        id: id++,
        name: 'Whelp',
        maxHp: 18,
        hp: 18,
        leftSkill: Skill(
          name: 'Flame',
          description: 'Small fire',
          type: SkillType.attack,
          target: SkillTarget.enemy,
          power: 6,
        ),
        rightSkill: Skill(
          name: 'Claw',
          description: 'Quick claw',
          type: SkillType.attack,
          target: SkillTarget.enemy,
          power: 4,
        ),
      ),
    ]);

    playerCards.shuffle();
    enemyCards.shuffle();
  }

  // Callbacks de swipe
  void onSwipeLeft() => _startAction(useLeftSkill: true);
  void onSwipeRight() => _startAction(useLeftSkill: false);

  /// Lance la séquence « focus → action → fin »
  Future<void> _startAction({required bool useLeftSkill}) async {
    if (result.isNotEmpty || isFocusing.value) return;

    // 1) Entrée en mode focus
    isFocusing.value = true;
    final actor = playerCards.first;
    final Skill skill = useLeftSkill ? actor.leftSkill : actor.rightSkill;

    // Détermination de la cible
    final CardModel target =
        skill.target == SkillTarget.enemy ? enemyCards.first : actor;

    activeCard.value = actor;
    targetCard.value = target;

    // 2) Laisser le temps à l'UI de centrer les cartes (~600ms)
    await Future.delayed(const Duration(milliseconds: 600));

    // 3) Appliquer visuellement la compétence
    _applySkill(actor, target, skill);

    // Si l'ennemi agit en riposte (si différent et toujours vivant)
    if (target != actor && target.isAlive) {
      final enemySkill =
          _random.nextBool() ? target.leftSkill : target.rightSkill;
      _applySkill(target, actor, enemySkill);
    }

    // 4) Fin du focus
    isFocusing.value = false;
    activeCard.value = null;
    targetCard.value = null;

    // 5) Rotation des piles (acteur et ennemi)
    _cycleCard(playerCards);
    _cycleCard(enemyCards);

    // 6) Vérification de fin de combat
    if (playerCards.isEmpty) {
      result.value = 'Defeat... You lost!';
    } else if (enemyCards.isEmpty) {
      result.value = 'Victory! You defeated all enemies.';
    }
  }

  void _applySkill(CardModel source, CardModel dest, Skill skill) {
    if (skill.type == SkillType.attack) {
      dest.takeDamage(skill.power);
    } else {
      source.heal(skill.power);
    }
  }

  void _cycleCard(RxList<CardModel> list) {
    if (list.isEmpty) return;
    final card = list.removeAt(0);
    if (card.isAlive) list.add(card);
  }
}
