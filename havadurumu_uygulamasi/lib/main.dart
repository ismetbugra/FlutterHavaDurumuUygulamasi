import 'package:flutter/material.dart';
import 'package:havadurumu_uygulamasi/route/app_routes.dart';
import 'package:havadurumu_uygulamasi/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.home,
    );
  }
}
