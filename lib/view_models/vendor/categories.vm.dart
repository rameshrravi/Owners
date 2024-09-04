import 'package:flutter/material.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/category.request.dart';
import 'package:fuodz/services/navigation.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/category/subcategories.page.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoriesViewModel extends MyBaseViewModel {
  CategoriesViewModel(BuildContext context, {this.vendorType}) {
    this.viewContext = context;
  }

  //
  CategoryRequest _categoryRequest = CategoryRequest();
  // RefreshController refreshController = RefreshController();

  //
  List<Category> categories = [];
  VendorType? vendorType;

  //
  initialise() {
    loadCategories();
  }

  //
  loadCategories() async {
    categories = [];
    setBusy(true);

    try {
      categories = await _categoryRequest.categories(
        vendorTypeId: vendorType?.id,
      );
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  categorySelected(Category category) async {
    Widget page;
    if (category.hasSubcategories) {
      page = SubcategoriesPage(category: category);
    } else {
      final search = Search(
        vendorType: category.vendorType,
        category: category,
        showType: (category.vendorType?.isService ?? false) ? 5 : 4,
      );
      page = NavigationService().searchPageWidget(search);
    }
    viewContext.nextPage(page);
  }
}
