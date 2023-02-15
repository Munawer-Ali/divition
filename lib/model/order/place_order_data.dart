import '../codes/code.dart';
import '../coupon/coupon.dart';
import 'order_data.dart';
import 'order_detail_data.dart';

class PlaceOrderData {
  PlaceData? data;
  String? message;

  PlaceOrderData({this.data, this.message});

  PlaceOrderData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PlaceData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class PlaceData {
  int? id;
  String? object;
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
  User? user;
  String? deliveryCharge;

  PlaceData(
      {this.id,
        this.object,
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
      this.user,
      this.deliveryCharge});

  PlaceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
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
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if(json.containsKey("cod_delivery_charge")){
      deliveryCharge=json['cod_delivery_charge'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
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
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['cod_delivery_charge']=this.deliveryCharge;
    return data;
  }
}
class User {
  int? id;
  String? fullName;
  String? store;

  User({this.id, this.fullName, this.store});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    store = json['store'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['store'] = this.store;
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



