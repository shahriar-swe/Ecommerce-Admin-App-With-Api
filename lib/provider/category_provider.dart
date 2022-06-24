import 'package:flutter/cupertino.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> categoryList = [];

  getCategoryData() async {
    categoryList = await CustomHttpRequest().fetchCategoryData();
    notifyListeners();
  }
}
