class ProfileData {
  Data? data;

  ProfileData({this.data});

  ProfileData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? fullName;
  String? avatar;
  String? email;
  String? createdAt;
  String? role;
  String? firstName;
  String? lastName;
  Country? country;
  City? city;
  String? phone;
  String? store;
  String? twoFactorEnabled;

  String? walletAmount;
  num? unreadNotifications;

  Data(
      {this.id,
        this.fullName,
        this.avatar,
        this.email,
        this.createdAt,
        this.role,
        this.firstName,
        this.lastName,
        this.country,
        this.city,
        this.phone,
        this.store,
        this.twoFactorEnabled,
        this.walletAmount,
        this.unreadNotifications});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    avatar = json['avatar'];
    email = json['email'];
    createdAt = json['created_at'];
    role = json['role'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    phone = json['phone'];
    store = json['store'];
    twoFactorEnabled = json['two_factor_enabled'];
    walletAmount = json['wallet_amount'];
    unreadNotifications = json['unread_notifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['role'] = this.role;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    data['phone'] = this.phone;
    data['store'] = this.store;
    data['two_factor_enabled'] = this.twoFactorEnabled;
    data['wallet_amount'] = this.walletAmount;
    data['unread_notifications'] = this.unreadNotifications;
    return data;
  }
}

class Country {
  int? id;
  String? phone;
  String? name;
  String? currency;
  String? symbol;
  Country({this.id, this.phone, this.name, this.currency,this.symbol});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    currency = json['currency'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['currency'] = this.currency;
    data['symbol'] = this.symbol;
    return data;
  }
}

class City {
  int? id;
  String? name;

  City({this.id, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}