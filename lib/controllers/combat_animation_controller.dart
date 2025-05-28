import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CombatAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  // Animations pour les transformations
  late Animation<double> actorTranslateX;
  late Animation<double> targetTranslateX;
  late Animation<double> scaleAnimation;
  late Animation<double> backgroundOpacity;

  // État des animations
  final RxBool isAnimating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _setupAnimationListeners();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animation de translation pour l'acteur (vers la gauche)
    actorTranslateX = Tween<double>(begin: 0.0, end: -100.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );

    // Animation de translation pour la cible (vers la droite)
    targetTranslateX = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );

    // Animation de scale
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );

    // Animation d'opacité pour le fond
    backgroundOpacity = Tween<double>(begin: 0.0, end: 0.7).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  void _setupAnimationListeners() {
    animationController.addStatusListener((status) {
      isAnimating.value =
          status == AnimationStatus.forward ||
          status == AnimationStatus.reverse;
    });
  }

  void startFocusAnimation() {
    animationController.forward();
  }

  void endFocusAnimation() {
    animationController.reverse();
  }

  double getActorTranslateX() => actorTranslateX.value;
  double getTargetTranslateX() => targetTranslateX.value;
  double getScaleValue() => scaleAnimation.value;
  double getBackgroundOpacity() => backgroundOpacity.value;

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
