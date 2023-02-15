

import '../codes/code.dart';
import '../coupon/coupon.dart';
import 'order_detail_data.dart';


class OrderData {
  List<Order>? data;

  OrderData({this.data});

  OrderData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Order>[];
      json['data'].forEach((v) {
        data!.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? id;
  String? no;
  Product? product;
  num? price;
  String? qty;
  String? phone;
  Coupon? coupon;
  num? categorizedDiscountInAmount;
  String? createdAt;
  List<Codes>? codes;
  String? paymentType;
  String? status;
  String? deliveryCarge;
  dynamic wholesaler_profit;
  Order(
      {this.id,
        this.no,
        this.product,
        this.price,
        this.qty,
        this.phone,
        this.coupon,
        this.categorizedDiscountInAmount,
        this.createdAt,
        this.codes,
        this.paymentType,
        this.status,
      this.deliveryCarge,
      this.wholesaler_profit});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    no = json['no'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    price = json['price'];
    qty = json['qty'];
    phone = json['phone'];
    coupon =
    json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : null;
    categorizedDiscountInAmount = json['categorized_discount_in_amount'];
    createdAt = json['created_at'];
    if (json.containsKey("codes")&&json['codes'] != null) {
      codes = <Codes>[];
      json['codes'].forEach((v) {
        codes!.add(new Codes.fromJson(v));
      });
    }
    paymentType = json['payment_type'];
    status = json['status'];
    if(json.containsKey("cod_delivery_charge")){
      deliveryCarge=json['cod_delivery_charge']??"0";
    }
    if(json.containsKey("wholesaler_profit")){
      wholesaler_profit=json['wholesaler_profit']??0;
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
    if (this.codes != null) {
      data['codes'] = this.codes!.map((v) => v.toJson()).toList();
    }
    data['payment_type'] = this.paymentType;
    data['status'] = this.status;
    data['cod_delivery_charge'] = this.deliveryCarge;
    data['wholesaler_profit'] = this.wholesaler_profit;
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


