class StepsData {
  Content? content;


  StepsData({this.content});

  StepsData.fromJson(Map<String, dynamic> json) {
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }

    return data;
  }
}

class Content {

  List<Steps>? steps;

  Content({this.steps});

  Content.fromJson(Map<String, dynamic> json) {

    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(new Steps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.steps != null) {
      data['steps'] = this.steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class Steps {
  String? title;
  String? plainDescription;

  Steps({this.title, this.plainDescription});

  Steps.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    plainDescription = json['plain_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['plain_description'] = this.plainDescription;
    return data;
  }
}

