import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptySearch extends StatelessWidget {
  const EmptySearch({
    this.type = "",
    Key? key,
  }) : super(key: key);
  final String type;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //Image
        Image.asset(
          AppImages.emptySearch,
          height: context.screenWidth * 0.3,
          width: context.screenWidth * 0.3,
          fit: BoxFit.contain,
        ).centered(),
        VStack(
          [
            //title
            getTitle(type).text.xl.semiBold.center.make(),
            //body
            getBody(type).text.center.make(),
          ],
          crossAlignment: CrossAxisAlignment.center,
          alignment: MainAxisAlignment.center,
        ),
      ],
      crossAlignment: CrossAxisAlignment.center,
      spacing: 10,
    ).p(12);
  }

  String getTitle(String type) {
    switch (type) {
      case "vendor":
        return "No Vendor Found".tr();
      case "product":
        return "No Product Found".tr();
      case "service":
        return "No Service Found".tr();
      default:
        return "No Result Found".tr();
    }
  }

  String getBody(String type) {
    switch (type) {
      case "vendor":
        return "Sorry, no vendor match your search. Please try again or explore different categories. Check back for updates. Happy searching!"
            .tr();
      case "product":
        return "Sorry, no product match your search. Please try again or explore different categories. Check back for updates. Happy searching!"
            .tr();
      case "service":
        return "Sorry, no service match your search. Please try again or explore different categories. Check back for updates. Happy searching!"
            .tr();
      default:
        return "There seems to be no result".tr();
    }
  }
}
