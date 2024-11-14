import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:lyrics_library_project/bean/lyric_bean.dart';
import 'package:lyrics_library_project/db/DbManager.dart';

class SearchTextController extends GetxController {
  var searchText = "".obs;

  final searchTextEditingController = TextEditingController();

  final lyricLists = RxList<Map<String,Object?>>();
  List<Map<String,Object?>> allLyricList = [];

  @override
  void onInit() {
    ever(searchText, (callback) => queryLyric(searchText.value));
    queryLyric(searchText.value);
    super.onInit();
  }

  void searchTextChange(String? text) async {
    searchText(text ?? "");
  }

  ///清除搜索框中的文字
  void clearText() {
    searchText("");
  }

  ///查询数据库获取歌词列表
  void queryLyric(String? text) async {
    List<Map<String,Object?>>? list;
    if (text?.isNotEmpty == true) {
      list = await DbManager.getInstance().query(text!);
      lyricLists(list);
    } else {
      if (allLyricList.isEmpty) {
        allLyricList =  DbManager.getInstance().getAllData();
        // List<Map<String, String>> list = DbManager.getInstance().getAllData();
        // print("------------${list.length}");
      }
      lyricLists(allLyricList);
    }
  }
}
