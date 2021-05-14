class Information {
  int malId;
  String url;
  String image_url;
  String trailerUrl;
  String title;
  String type;
  String source;
  Null episodes;
  String status;
  bool airing;
  String duration;
  String rating;
  double score;
  int scoredBy;
  int rank;
  int popularity;
  int members;
  int favorites;
  String synopsis;
  Null background;
  String premiered;
  String broadcast;
  int enumber;
  int denumber;

  Information(
      {this.malId,
      this.url,
      this.image_url,
      this.trailerUrl,
      this.title,
      this.type,
      this.source,
      this.episodes,
      this.status,
      this.airing,
      this.duration,
      this.rating,
      this.score,
      this.scoredBy,
      this.rank,
      this.popularity,
      this.members,
      this.favorites,
      this.synopsis,
      this.background,
      this.premiered,
      this.broadcast,
      this.enumber,
      this.denumber});

  Information.fromJson(Map<String, dynamic> json) {
    malId = json['mal_id'];
    url = json['url'];
    image_url = json['image_url'];
    trailerUrl = json['trailer_url'];
    title = json['title'];
    type = json['type'];
    source = json['source'];
    episodes = json['episodes'];
    status = json['status'];
    airing = json['airing'];
    duration = json['duration'];
    rating = json['rating'];
    score = json['score'];
    scoredBy = json['scored_by'];
    rank = json['rank'];
    popularity = json['popularity'];
    members = json['members'];
    favorites = json['favorites'];
    synopsis = json['synopsis'];
    background = json['background'];
    premiered = json['premiered'];
    broadcast = json['broadcast'];
    enumber = json['enumber'];
    denumber = json['denumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mal_id'] = this.malId;
    data['url'] = this.url;
    data['image_url'] = this.image_url;
    data['trailer_url'] = this.trailerUrl;
    data['title'] = this.title;
    data['type'] = this.type;
    data['source'] = this.source;
    data['episodes'] = this.episodes;
    data['status'] = this.status;
    data['airing'] = this.airing;
    data['duration'] = this.duration;
    data['rating'] = this.rating;
    data['score'] = this.score;
    data['scored_by'] = this.scoredBy;
    data['rank'] = this.rank;
    data['popularity'] = this.popularity;
    data['members'] = this.members;
    data['favorites'] = this.favorites;
    data['synopsis'] = this.synopsis;
    data['background'] = this.background;
    data['premiered'] = this.premiered;
    data['broadcast'] = this.broadcast;
    data['enumber'] = this.enumber;
    data['denumber'] = this.denumber;
    return data;
  }
}
