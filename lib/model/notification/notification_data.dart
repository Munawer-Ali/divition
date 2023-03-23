class NotificationData {
  List<NotificationList>? data;

  NotificationData({this.data});

  NotificationData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NotificationList>[];
      json['data'].forEach((v) {
        data!.add(new NotificationList.fromJson(v));
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

class NotificationList {
  int? id;
  String? message;
  String? createdAt;

  NotificationList({this.id, this.message, this.createdAt});

  NotificationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}