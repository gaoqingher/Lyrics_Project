import 'package:get/get.dart';
import 'package:lyrics_library_project/db/DbManager.dart';

class MainController extends GetxController {
  var initializationComplete = false.obs;

  @override
  Future<void> onInit() async {
    int count = await DbManager.getInstance().init();
    initializationComplete(true);
    super.onInit();
  }
}
