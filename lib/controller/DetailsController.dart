import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  var initializationComplete = false.obs;
  var lyricContent = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  ///读取文件  当为空时，表示可能发生了异常
  Future<void> readLyric(String lyricNumber) async {
    String readText =
        await readFromAssets(lyricNumber, pUpperCase: true, txtUpperCase: true);
    if (readText.isEmpty) {
      readText = await readFromAssets(lyricNumber,
          pUpperCase: true, txtUpperCase: false);
      if (readText.isEmpty) {
        readText = await readFromAssets(lyricNumber,
            pUpperCase: false, txtUpperCase: true);
        if (readText.isEmpty) {
          readText = await readFromAssets(lyricNumber,
              pUpperCase: false, txtUpperCase: false);
        }
      }
    }
    lyricContent(readText);
    initializationComplete(true);
  }

  ///从Assets 中读文件,因为fileName 开头的p 有可能大写也有可能小写，所以大写失败时，再用小写试一次
  Future<String> readFromAssets(String lyricNumber,
      {bool pUpperCase = true, bool txtUpperCase = true}) async {
    try {
      String filePath = getFilePath(lyricNumber,
          pUpperCase: pUpperCase, txtUpperCase: txtUpperCase);
      String readText = await rootBundle.loadString(filePath);
      return jsonDecode(jsonEncode(readText));
    } catch (e) {
      return "";
    }
  }

  ///获取文件路径  p ,txt 都有可能大小写
  String getFilePath(String lyricNumber,
      {bool pUpperCase = true, bool txtUpperCase = true}) {
    return "assets/${getFolderName(lyricNumber)}/${getFileName(lyricNumber, pUpperCase: pUpperCase)}.${txtUpperCase ? "TXT" : "txt"}";
  }

  ///获取文件名称 upperCase ---默认P 为大写
  String getFileName(String lyricNumber, {bool pUpperCase = true}) {
    return "${pUpperCase ? "P" : "p"}$lyricNumber";
  }

  ///获取文件夹名称
  String getFolderName(String lyricNumber) {
    String frontName = lyricNumber.substring(0, 2);
    return "P${frontName}000";
  }
}
