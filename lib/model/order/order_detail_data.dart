

import 'package:divisioniosfinal/model/order/place_order_data.dart';

import '../codes/code.dart';
import '../coupon/coupon.dart';

class OrderDetailData {
  OrderDetail? data;

  OrderDetailData({this.data});

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrderDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OrderDetail {
  int? id;
  String? no;
  Product? product;
  num? price;
  String? qty;
  String? phone;
  Coupon? coupon;
  num? categorizedDiscountInAmount;
  String? createdAt;
  String? playerId;
  String? playerName;
  List<Codes>? codes;
  String? paymentType;
  String? status;
  User? user;
  String? deliveryCharge;

  OrderDetail(
      {this.id,
        this.no,
        this.product,
        this.price,
        this.qty,
        this.phone,
        this.coupon,
        this.categorizedDiscountInAmount,
        this.createdAt,
        this.playerId,
        this.playerName,
        this.codes,
        this.paymentType,
        this.status,
        this.user,
      this.deliveryCharge});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    no = json['no'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    price = json['price'];
    qty = json['qty'];
    phone = json['phone'];
    coupon =
    json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : null;
    if(json.containsKey("categorized_discount_in_amount")){
      categorizedDiscountInAmount = json['categorized_discount_in_amount']??0;
    }
    createdAt = json['created_at'];
    if(json.containsKey("pubg_player_id")){
      playerId=json['pubg_player_id'];
    }
    if(json.containsKey("pubg_player_name")){
      playerName=json['pubg_player_name'];
    }
    if(json.containsKey("jawaker_player_id")){
      playerId=json['jawaker_player_id'];
    }
    if(json.containsKey("jawaker_player_name")){
      playerName=json['jawaker_player_name'];
    }
    if(json.containsKey("no_api_player_id")){
      playerId=json['no_api_player_id'];
    }
    if (json.containsKey("codes")&&json['codes'] != null) {
      codes = <Codes>[];
      json['codes'].forEach((v) {
        codes!.add(new Codes.fromJson(v));
      });
    }
    paymentType = json['payment_type'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if(json.containsKey("cod_delivery_charge")){
      deliveryCharge=json['cod_delivery_charge']??"0";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['no'] = this.no;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['phone'] = this.phone;
    if (this.coupon != null) {
      data['coupon'] = this.coupon!.toJson();
    }
    data['categorized_discount_in_amount'] = this.categorizedDiscountInAmount;
    data['created_at'] = this.createdAt;
    data['pubg_player_id']=this.playerId;
    data['pubg_player_name']=this.playerName;
    if (this.codes != null) {
      data['codes'] = this.codes!.map((v) => v.toJson()).toList();
    }
    data['payment_type'] = this.paymentType;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['cod_delivery_charge']=this.deliveryCharge;
    return data;
  }
}

class Product {
  int? id;
  String? slug;
  String? image;
  String? title;
  String? customerPrice;
  String? wholesalerPrice;
  Category? category;
  String? description;


  Product(
      {this.id,
        this.slug,
        this.image,
        this.title,
        this.customerPrice,
        this.wholesalerPrice,
        this.category,
        this.description});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    image = json['image'];
    title = json['title'];
    customerPrice = json['customer_price'];
    wholesalerPrice = json['wholesaler_price'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['title'] = this.title;
    data['customer_price'] = this.customerPrice;
    data['wholesaler_price'] = this.wholesalerPrice;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['description'] = this.description;
    return data;
  }
}

class Category {
  int? id;
  String? slug;
  String? image;
  String? title;
  String? type;

  Category({this.id, this.slug, this.image, this.title, this.type});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    image = json['image'];
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}

