class Coupon {
  String? code;
  String? discount;

  Coupon({this.code, this.discount});

  Coupon.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['discount'] = this.discount;
    return data;
  }
}