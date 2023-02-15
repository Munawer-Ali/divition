class HomeDeviceWiseData {
  List<DeviceWiseData>? data;

  HomeDeviceWiseData({this.data});

  HomeDeviceWiseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeviceWiseData>[];
      json['data'].forEach((v) {
        data!.add(new DeviceWiseData.fromJson(v));
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

class DeviceWiseData {
  int? id;
  String? slug;
  String? image;
  String? title;
  String? type;

  DeviceWiseData({this.id, this.slug, this.image, this.title, this.type});

  DeviceWiseData.fromJson(Map<String, dynamic> json) {
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