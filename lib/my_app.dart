import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'package:lyrics_library_project/routes/routes.dart';
import 'package:lyrics_library_project/utils/AppTranslations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //title: "歌词搜索",
      /// 通过使用initialRoute来保证绑定的操作
      initialRoute: Routes.main,
      // unknownRoute: Routes.unknownPage,
      getPages: Routes.routePage,
      theme: _getMaterialCurrentTheme(),
      translations: AppTranslations(),
      locale: getSystemLocal(),
      fallbackLocale: const Locale('zh', 'CN'),
      builder: (c, w) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          // Global GestureDetector that will dismiss the keyboard
          body: GestureDetector(
            onTap: () {
              hideKeyboard(c);
            },
            child: w,
          ),
        );
      },
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  Locale getSystemLocal() {
    print(
        "gaoqing---------ui locale ${ui.window.locale.languageCode}   : ${ui.window.locale.countryCode}");
    Locale locale = ui.window.locale;
    if (locale.languageCode == "ko" && locale.countryCode == 'KR') {
      return const Locale("ko", 'KR');
    } else {
      return const Locale('zh', 'CN');
    }
    // return ui.window.locale;
  }

  Color get primaryColor {
    return const Color(0xFF5B6ABF);
  }

  /// App运行过程中,如果在iOS的设置中更改了亮度模式,还是无法实时进行更改,只能下次运行的时候才能体现变化,体验不好
  ThemeData _getMaterialCurrentTheme() {
    //return WidgetsBinding.instance.platformDispatcher.platformBrightness.themeData;
    //return View.of(context).platformDispatcher.platformBrightness.themeData;
    //return SchedulerBinding.instance.window.platformBrightness.themeData;

    //  return ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),  useMaterial3: true,);
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: primaryColor,
        //主色
        appBarTheme: appBarTheme(),
        cardTheme: cardTheme(color: Colors.white),
        dividerColor: Colors.grey,
        indicatorColor: primaryColor,
        tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: primaryColor));
  }

  CardTheme cardTheme({Color? color}) {
    return CardTheme(
        clipBehavior: Clip.antiAlias,
        color: color,
        margin: const EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))));
  }

  AppBarTheme appBarTheme() {
    return AppBarTheme(
      centerTitle: true,
      color: primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  CupertinoThemeData _getCupertinoCurrentTheme() {
    return const CupertinoThemeData(
        primaryColor: Colors.blue,
        barBackgroundColor: Colors.white,
        brightness: Brightness.light);
  }
}
