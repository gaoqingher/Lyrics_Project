import 'package:flutter/material.dart';

import '../controller/DetailsController.dart';

import 'package:get/get.dart';

import '../widgets/base_indicator.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  final detailsController = Get.put(DetailsController());

  @override
  void initState() {
    detailsController.readLyric(Get.arguments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lyric_details'.tr),
      ),
      body: mainLayout(context),
      backgroundColor: Colors.white,
    );
  }

  Widget mainLayout(BuildContext context) {
    return Obx(() {
      if (detailsController.initializationComplete.value) {
        if (detailsController.lyricContent.value.isEmpty) {
          return Center(
            child: Text('load_lyric_error'.tr),
          );
        } else {
          return SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              // 使用屏幕宽度
              padding: const EdgeInsets.all(15),
              child: Text(detailsController.lyricContent.value),
            ),
          );
        }
      } else {
        return const BaseIndicator();
      }
    });
  }
}
