// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/app_routes.dart';
import 'bindings/combat_binding.dart';
import 'views/combat_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Randventure TCG',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.combat,
      getPages: [
        GetPage(
          name: AppRoutes.combat,
          page: () => CombatPage(),
          binding: CombatBinding(),
        ),
      ],
    );
  }
}
