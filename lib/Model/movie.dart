class Movie {
  String title;
  String url;
  String picture;
  String infotext;
  int score;

  Movie({this.title, this.url, this.picture, this.infotext, this.score});

  Movie.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    picture = json['picture'];
    infotext = json['infotext'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['url'] = this.url;
    data['picture'] = this.picture;
    data['infotext'] = this.infotext;
    data['score'] = this.score;
    return data;
  }
}
