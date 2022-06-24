// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

//String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.image,
    this.isVisible,
    this.isAvailable,
    this.foodItemCategory,
    this.price,
    this.stockItems,
  });

  int? id;
  String? name;
  String? image;
  int? isVisible;
  int? isAvailable;
  List<dynamic>? foodItemCategory;
  List<Price>? price;
  List<StockItem>? stockItems;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    isVisible: json["is_visible"],
    isAvailable: json["is_available"],
    foodItemCategory: List<dynamic>.from(json["food_item_category"].map((x) => x)),
    price: List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
    stockItems: List<StockItem>.from(json["stock_items"].map((x) => StockItem.fromJson(x))),
  );

  /*Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "is_visible": isVisible,
    "is_available": isAvailable,
    "food_item_category": List<dynamic>.from(foodItemCategory.map((x) => x)),
    "price": List<dynamic>.from(price.map((x) => x.toJson())),
    "stock_items": List<dynamic>.from(stockItems.map((x) => x.toJson())),
  };*/
}

class Price {
  Price({
    this.originalPrice,
    this.discountedPrice,
    this.discountType,
    this.fixedValue,
    this.percentOf,
  });

  int? originalPrice;
  int? discountedPrice;
  String? discountType;
  int? fixedValue;
  dynamic percentOf;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    originalPrice: json["original_price"],
    discountedPrice: json["discounted_price"],
    discountType: json["discount_type"],
    fixedValue: json["fixed_value"],
    percentOf: json["percent_of"],
  );

  /*Map<String, dynamic> toJson() => {
    "original_price": originalPrice,
    "discounted_price": discountedPrice,
    "discount_type": discountType,
    "fixed_value": fixedValue,
    "percent_of": percentOf,
  };*/
}

class StockItem {
  StockItem({
    this.quantity,
  });

  int? quantity;

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
    quantity: json["quantity"],
  );

  /*Map<String, dynamic> toJson() => {
    "quantity": quantity,
  };*/
}
