import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:lyrics_library_project/pages/details_page.dart';
import 'package:lyrics_library_project/pages/main_page.dart';
import 'package:lyrics_library_project/pages/unknown_page.dart';

abstract class Routes {
  Routes._();

  static const main = "/main";

  static const unknown = "/unknown";

  static const details = "/details";

  ///页面合集
  static final routePage = [
    GetPage(
      name: main,
      page: () => const MainPage(),
    ),
    GetPage(
      name: unknown,
      page: () => const UnknownPage(),
    ),
    GetPage(
      name: details,
      page: () => const DetailsPage(),
    ),
  ];

  static final unknownPage = GetPage(
    name: Routes.unknown,
    page: () => const UnknownPage(),
  );
}
