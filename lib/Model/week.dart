class Week {
  String title;
  String url;
  String img;
  int malId;
  String desc;

  Week({this.title, this.url, this.img, this.malId, this.desc});

  Week.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    img = json['img'];
    malId = json['malId'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['url'] = this.url;
    data['img'] = this.img;
    data['malId'] = this.malId;
    data['desc'] = this.desc;
    return data;
  }
}
