class Codes {
  String? no;

  Codes({this.no});

  Codes.fromJson(Map<String, dynamic> json) {
    no = json['no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this.no;
    return data;
  }
}