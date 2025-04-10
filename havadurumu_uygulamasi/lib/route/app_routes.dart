import 'package:flutter/cupertino.dart';
import 'package:havadurumu_uygulamasi/screens/detail_screen.dart';
import 'package:havadurumu_uygulamasi/screens/home_page.dart';

class AppRoutes{
  static String home = "/";
  static String detail = "/detail";

  static Map<String,Widget Function(BuildContext)> get routes => {
    home: (context) => HomePage(),
    detail: (context) => DetailScreen()
  };
}