import '../coupon/coupon.dart';

class CartData {
  List<Countries>? countries;
  Cart? cart;

  CartData({this.countries, this.cart});

  CartData.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(new Countries.fromJson(v));
      });
    }
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countries != null) {
      data['countries'] = this.countries!.map((v) => v.toJson()).toList();
    }
    if (this.cart != null) {
      data['cart'] = this.cart!.toJson();
    }
    return data;
  }
}

class Countries {
  int? id;
  String? phone;
  String? name;
  String? currency;

  Countries({this.id, this.phone, this.name, this.currency});

  Countries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['currency'] = this.currency;
    return data;
  }
}

class Cart {
  int? id;
  Product? product;
  int? subtotal;
  String? qty;
  Coupon? coupon;
  num? total;
  num? discount;
  String? pubgPlayerId;
  String? pubgPlayerName;

  Cart(
      {this.id,
        this.product,
        this.subtotal,
        this.qty,
        this.coupon,
        this.total,
        this.discount,
        this.pubgPlayerId,
        this.pubgPlayerName});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    subtotal = json['subtotal'];
    qty = json['qty'];
    coupon =
    json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : null;
    total = json['total'];
    discount = json['discount'];
    pubgPlayerId = json['pubg_player_id'];
    pubgPlayerName = json['pubg_player_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['subtotal'] = this.subtotal;
    data['qty'] = this.qty;
    if (this.coupon != null) {
      data['coupon'] = this.coupon!.toJson();
    }
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['pubg_player_id'] = this.pubgPlayerId;
    data['pubg_player_name'] = this.pubgPlayerName;
    return data;
  }
}

class Product {
  int? id;
  String? title;
  String? customerPrice;
  String? image;

  Product({this.id, this.title, this.customerPrice, this.image});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    customerPrice = json['customer_price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['customer_price'] = this.customerPrice;
    data['image'] = this.image;
    return data;
  }
}


