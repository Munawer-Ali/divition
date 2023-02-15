class ContactUsData {
  Country? country;
  Contact? contact;

  ContactUsData({this.country, this.contact});

  ContactUsData.fromJson(Map<String, dynamic> json) {
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    contact =
    json['contact'] != null ? new Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
    }
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

class Contact {
  String? phone;
  String? email;
  String? whatsapp;
  String? messenger;
  String? facebook;
  String? instagram;
  String? pinterest;
  String? twitter;

  Contact(
      {this.phone,
        this.email,
        this.whatsapp,
        this.messenger,
        this.facebook,
        this.instagram,
        this.pinterest,
        this.twitter});

  Contact.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    whatsapp = json['whatsapp'];
    messenger = json['messenger'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    pinterest = json['pinterest'];
    twitter = json['twitter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['whatsapp'] = this.whatsapp;
    data['messenger'] = this.messenger;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['pinterest'] = this.pinterest;
    data['twitter'] = this.twitter;
    return data;
  }
}