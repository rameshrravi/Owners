import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/requests/favourite.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FavouritesViewModel extends MyBaseViewModel {
  //
  FavouriteRequest favouriteRequest = FavouriteRequest();
  List<Product> products = [];

  //
  FavouritesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  void initialise() {
    //
    fetchProducts();
  }

  //
  fetchProducts() async {
    //
    setBusyForObject(products, true);
    try {
      products = await favouriteRequest.favourites();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(products, false);
  }

  //
  removeFavourite(Product product) {
    //
    AlertService.confirm(
      title: "Remove Product From Favourite".tr(),
      text:
          "Are you sure you want to remove this product from your favourite list?"
              .tr(),
      confirmBtnText: "Remove".tr(),
      onConfirm: () {
        processRemove(product);
      },
    );
  }

  //
  processRemove(Product product) async {
    setBusy(true);
    //
    final apiResponse = await favouriteRequest.removeFavourite(
      product.id,
    );

    //remove from list
    if (apiResponse.allGood) {
      products.remove(product);
    }

    setBusy(false);

    AlertService.dynamic(
      type: apiResponse.allGood ? AlertType.success : AlertType.error,
      title: "Remove Product From Favourite".tr(),
      text: apiResponse.message,
    );
  }

  openProductDetails(Product product) {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );
  }
}
