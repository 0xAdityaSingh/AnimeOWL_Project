// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.anime,
  });

  Map<String, Anime> anime;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        anime: Map.from(json["anime"])
            .map((k, v) => MapEntry<String, Anime>(k, Anime.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "anime": Map.from(anime)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Anime {
  Anime({
    this.malId,
    this.url,
    this.title,
    this.imageUrl,
    this.type,
    this.airingStart,
    this.episodes,
    this.members,
    this.source,
    this.score,
    this.r18,
    this.kids,
    this.continuing,
  });

  int malId;
  String url;
  String title;
  String imageUrl;
  Type type;
  DateTime airingStart;
  int episodes;
  int members;
  String source;
  double score;
  bool r18;
  bool kids;
  bool continuing;

  factory Anime.fromJson(Map<String, dynamic> json) => Anime(
        malId: json["mal_id"],
        url: json["url"],
        title: json["title"],
        imageUrl: json["image_url"],
        type: typeValues.map[json["type"]],
        airingStart: json["airing_start"] == null
            ? null
            : DateTime.parse(json["airing_start"]),
        episodes: json["episodes"] == null ? null : json["episodes"],
        members: json["members"],
        source: json["source"],
        score: json["score"] == null ? null : json["score"].toDouble(),
        r18: json["r18"],
        kids: json["kids"],
        continuing: json["continuing"],
      );

  Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "title": title,
        "image_url": imageUrl,
        "type": typeValues.reverse[type],
        "airing_start":
            airingStart == null ? null : airingStart.toIso8601String(),
        "episodes": episodes == null ? null : episodes,
        "members": members,
        "source": source,
        "score": score == null ? null : score,
        "r18": r18,
        "kids": kids,
        "continuing": continuing,
      };
}

enum Type { TV, ONA, OVA, MOVIE }

final typeValues = EnumValues(
    {"Movie": Type.MOVIE, "ONA": Type.ONA, "OVA": Type.OVA, "TV": Type.TV});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
