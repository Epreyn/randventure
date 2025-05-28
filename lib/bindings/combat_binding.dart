// lib/bindings/combat_binding.dart

import 'package:get/get.dart';
import '../controllers/combat_controller.dart';

class CombatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CombatController>(() => CombatController());
  }
}
