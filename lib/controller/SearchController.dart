import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:lyrics_library_project/bean/lyric_bean.dart';
import 'package:lyrics_library_project/db/DbManager.dart';

class SearchTextController extends GetxController {
  var searchText = "".obs;

  final searchTextEditingController = TextEditingController();

  final lyricLists = RxList<LyricBean>();
  List<LyricBean> allLyricList = [];

  @override
  void onInit() {
    ever(searchText, (callback) => queryLyric(searchText.value));
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
    List<LyricBean> list;
    if (text?.isNotEmpty == true) {
      list = await DbManager.getInstance().query(text!);
      lyricLists(list);
    } else {
      if (allLyricList.isEmpty) {
        allLyricList = DbManager.getInstance().getAllData();
      }
      lyricLists(allLyricList);
    }
  }
}
