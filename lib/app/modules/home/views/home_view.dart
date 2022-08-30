import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() => Text(
              'Latitude${controller.lat.value}\n Long${controller.long.value}\n',
              style: const TextStyle(fontSize: 20),
            )),
      ),
    );
  }
}
