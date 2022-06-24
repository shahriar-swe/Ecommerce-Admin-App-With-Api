import 'package:flutter/cupertino.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/model/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> productList = [];

  getProductData() async {
    productList = await CustomHttpRequest().fetchProductData();
    notifyListeners();
  }
}
