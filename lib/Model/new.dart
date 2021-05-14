class Result {
  String title;
  String url;
  String picture;
  String infotext;
  String timetop;
  int score;

  Result(
      {this.title,
      this.url,
      this.picture,
      this.infotext,
      this.timetop,
      this.score});

  Result.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    picture = json['picture'];
    infotext = json['infotext'];
    timetop = json['timetop'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['url'] = this.url;
    data['picture'] = this.picture;
    data['infotext'] = this.infotext;
    data['timetop'] = this.timetop;
    data['score'] = this.score;
    return data;
  }
}
