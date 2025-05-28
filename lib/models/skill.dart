// lib/models/skill.dart

enum SkillType { attack, heal }

enum SkillTarget { enemy, self }

class Skill {
  final String name;
  final String description;
  final SkillType type;
  final SkillTarget target;
  final int power;

  Skill({
    required this.name,
    required this.description,
    required this.type,
    required this.target,
    required this.power,
  });
}
