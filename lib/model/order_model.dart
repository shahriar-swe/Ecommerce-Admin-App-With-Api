// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

class OrderModel {
  OrderModel({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.vat,
    this.orderDateAndTime,
    this.user,
    this.payment,
    this.orderStatus,
  });

  final int? id;
  final int? quantity;
  final int? price;
  final dynamic discount;
  final dynamic vat;
  final DateTime? orderDateAndTime;
  final User? user;
  final Payment? payment;
  final OrderStatus? orderStatus;


  //ekhane shodhu fromJson gola rakhbo toJson fele dibo

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json["id"],
    quantity: json["quantity"],
    price: json["price"],
    discount: json["discount"],
    vat: json["VAT"],
    orderDateAndTime: DateTime.parse(json["order_date_and_time"]),
    user: User.fromJson(json["user"]),
    payment: Payment.fromJson(json["payment"]),
    orderStatus: OrderStatus.fromJson(json["order_status"]),
  );
}

class OrderStatus {
  OrderStatus({
    this.orderStatusCategory,
  });

  final User? orderStatusCategory;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    orderStatusCategory: User.fromJson(json["order_status_category"]),
  );
}

class User {
  User({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
  );
}

class Payment {
  Payment({
    this.paymentStatus,
  });

  final int? paymentStatus;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    paymentStatus: json["payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "payment_status": paymentStatus,
  };
}
