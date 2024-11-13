import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyrics_library_project/widgets/base_indicator.dart';
import '../bean/lyric_bean.dart';
import '../controller/MainController.dart';
import '../controller/SearchController.dart';
import '../routes/routes.dart';
import '../widgets/CupertinoActionSheet.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final controller = Get.put(MainController());
  final searchController = Get.put(SearchTextController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lyrics_search'.tr),
        actions: [
          IconButton(
            onPressed: () {
              _showBottomSheet(context);
            },
            icon: const Icon(Icons.add_circle),
            color: Colors.white,
          )
        ],
      ),
      body: mainLayout(context),
    );
  }

  Widget mainLayout(BuildContext context) {
    return Obx(() {
      if (controller.initializationComplete.value == true) {
        return Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              searchWidget(context),
              Expanded(child: searchListWidget())
            ],
          ),
        );
      } else {
        return BaseIndicator(
          text: 'init_data'.tr,
        );
      }
    });
  }

  void _showBottomSheet(BuildContext context) {
    CustomCupertinoActionSheet(context, ["chinese".tr, "korean".tr], (element) {
      if (element == "chinese".tr) {
        Get.updateLocale(const Locale("zh"));
      } else {
        Get.updateLocale(const Locale("ko"));
      }
    }, "switch_language".tr, null)
        .showActionSheet();
  }

  Widget searchWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: searchController.searchTextEditingController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            // 搜索图标
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                clearTextField();
              },
            ),
            hintText: 'lyrics_search_hint'.tr,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12)),
        maxLines: 1,
        onChanged: (value) {
          searchController.searchTextChange(value);
        },
      ),
    );
  }

  void clearTextField() {
    searchController.searchTextEditingController.clear();
    searchController.searchTextChange("");
  }

  Widget searchListWidget() {
    return GetX<SearchTextController>(builder: (controller) {
      return controller.lyricLists.isEmpty
          ? Center(
              child: Text("search_result_hint".tr),
            )
          : ListView.builder(
              itemCount: controller.lyricLists.length,
              itemBuilder: (BuildContext context, int index) {
                return itemWidget(controller.lyricLists[index]);
              },
            );
    });
  }

  Widget itemWidget(LyricBean bean) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${'lyrics_title'.tr} : ${bean.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              "${'lyrics_number'.tr} : ${bean.number}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      onTap: () {
        Get.toNamed(Routes.details, arguments: bean.number);
      },
    );
  }
}
