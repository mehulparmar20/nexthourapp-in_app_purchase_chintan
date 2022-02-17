import '/models/video_link.dart';

class Episode {
  Episode({
    this.id,
    this.seasonsId,
    this.tmdbId,
    this.thumbnail,
    this.episodeNo,
    this.title,
    this.tmdb,
    this.duration,
    this.detail,
    this.aLanguage,
    this.subtitle,
    this.subtitleList,
    this.subtitleFiles,
    this.released,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.videoLink,
  });

  int? id;
  dynamic seasonsId;
  String? tmdbId;
  String? thumbnail;
  dynamic episodeNo;
  String? title;
  Tmdb? tmdb;
  dynamic duration;
  String? detail;
  dynamic aLanguage;
  dynamic subtitle;
  dynamic subtitleList;
  dynamic subtitleFiles;
  DateTime? released;
  EpisodeType? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  VideoLink? videoLink;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json["id"],
        seasonsId: json["seasons_id"],
        tmdbId: json["tmdb_id"],
        thumbnail: json["thumbnail"],
        episodeNo: json["episode_no"],
        title: json["title"],
        tmdb: tmdbValues.map[json["tmdb"]],
        duration: json["duration"],
        detail: json["detail"],
        aLanguage: json["a_language"],
        subtitle: json["subtitle"],
        subtitleList: json["subtitle_list"],
        subtitleFiles: json["subtitle_files"],
        released:
            json["released"] == null ? null : DateTime.parse(json["released"]),
        type: episodeTypeValues.map[json["type"]],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        videoLink: VideoLink.fromJson(json["video_link"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seasons_id": seasonsId,
        "tmdb_id": tmdbId,
        "thumbnail": thumbnail,
        "episode_no": episodeNo,
        "title": title,
        "tmdb": tmdbValues.reverse![tmdb!],
        "duration": duration,
        "detail": detail,
        "a_language": aLanguage,
        "subtitle": subtitle,
        "subtitle_list": subtitleList,
        "subtitle_files": subtitleFiles,
        "released":
            "${released!.year.toString().padLeft(4, '0')}-${released!.month.toString().padLeft(2, '0')}-${released!.day.toString().padLeft(2, '0')}",
        "type": episodeTypeValues.reverse![type!],
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "video_link": videoLink!.toJson(),
      };
}

enum Tmdb { Y }

final tmdbValues = EnumValues({"Y": Tmdb.Y});

enum DatumType { T, M }

final datumTypeValues = EnumValues({"M": DatumType.M, "T": DatumType.T});

enum EpisodeType { E }

final episodeTypeValues = EnumValues({"E": EpisodeType.E});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
