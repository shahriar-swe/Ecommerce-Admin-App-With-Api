import 'package:flutter/cupertino.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/model/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> orderData = [];

  getOrderData() async {
    orderData = await CustomHttpRequest().fetchOrderData();
    notifyListeners();
  }
}