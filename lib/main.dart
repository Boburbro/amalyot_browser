import 'package:amalyot_browser/bindings/home_binding.dart';
import 'package:amalyot_browser/view/home.dart';
import 'package:amalyot_browser/view/web_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  await Hive.openBox('mydata');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "WEB",
      initialRoute: '/home',
      initialBinding: HomeBinding(),
      getPages: [
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: "/web", page: () => const WebPage()),
      ],
    );
  }
}
