// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ielts/models/carousel.dart';
// import 'package:ielts/services/banner_service.dart';

// class CarouselController extends GetxController {
//   static CarouselController instance = Get.find();
//   RxList<CarouselModel> carouselItemList =
//       List<CarouselModel>.empty(growable: true).obs;
//   RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     getData();
//   }

//   void getData() async {
//     try {
//       isLoading(true);
//       var result = await BannerService().getBanners();
//       carouselItemList.assignAll(result);
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
// }
