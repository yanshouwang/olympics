import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'medal_standings_answer.g.dart';

abstract class MedalStandingsAnswer {
  int get code;
  MedalStandingsContent get content;
  String get version;

  factory MedalStandingsAnswer.fromJSON(String source) {
    final sourceJSON = json.decode(source);
    return _MedalStandingsAnswer.fromJson(sourceJSON);
  }

  Map<String, dynamic> toJSON();
}

abstract class MedalStandingsContent {
  List<MedalStandingsHead> get heads;
  MedalStandings get standings;
  Team get top;

  factory MedalStandingsContent.fromJSON(String source) {
    final sourceJSON = json.decode(source);
    return _MedalStandingsContent.fromJson(sourceJSON);
  }

  Map<String, dynamic> toJSON();
}

abstract class MedalStandingsHead {
  String get description;
  String get descriptionWithEnglish;

  factory MedalStandingsHead.fromJSON(String source) {
    final sourceJSON = json.decode(source);
    return _MedalStandingsHead.fromJson(sourceJSON);
  }

  Map<String, dynamic> toJSON();
}

abstract class MedalStandings {
  List<Team> get total;
  List<Team> get men;
  List<Team> get women;
  List<Team> get mix;

  factory MedalStandings.fromJSON(String source) {
    final sourceJSON = json.decode(source);
    return _MedalStandings.fromJson(sourceJSON);
  }

  Map<String, dynamic> toJSON();
}

abstract class Team {
  String get id;
  String get name;
  String? get shortName;
  String get logoUrl;
  String get url;
  String get total;
  String get totalOfGold;
  String get totalOfSilver;
  String get totalOfBronze;
  String get rank;
  String get rankOfGold;
  String get rankOfSilver;
  String get rankOfBronze;

  factory Team.fromJSON(String source) {
    final sourceJSON = json.decode(source);
    return _Team.fromJson(sourceJSON);
  }

  Map<String, dynamic> toJSON();
}

@JsonSerializable()
class _MedalStandingsAnswer implements MedalStandingsAnswer {
  @override
  final int code;
  @JsonKey(name: 'data')
  @override
  final _MedalStandingsContent content;
  @override
  final String version;

  _MedalStandingsAnswer(this.code, this.content, this.version);

  factory _MedalStandingsAnswer.fromJson(Map<String, dynamic> sourceJSON) =>
      _$_MedalStandingsAnswerFromJson(sourceJSON);

  @override
  Map<String, dynamic> toJSON() => _$_MedalStandingsAnswerToJson(this);
}

@JsonSerializable()
class _MedalStandingsContent implements MedalStandingsContent {
  @JsonKey(name: 'head')
  @override
  final List<_MedalStandingsHead> heads;
  @JsonKey(name: 'data')
  @override
  final _MedalStandings standings;
  @JsonKey(name: 'medalsInfo')
  @override
  final _Team top;

  _MedalStandingsContent(this.heads, this.standings, this.top);

  factory _MedalStandingsContent.fromJson(Map<String, dynamic> sourceJSON) =>
      _$_MedalStandingsContentFromJson(sourceJSON);

  @override
  Map<String, dynamic> toJSON() => _$_MedalStandingsContentToJson(this);
}

@JsonSerializable()
class _MedalStandingsHead implements MedalStandingsHead {
  @JsonKey(name: 'desc')
  @override
  final String description;
  @JsonKey(name: 'endesc')
  @override
  final String descriptionWithEnglish;

  _MedalStandingsHead(this.description, this.descriptionWithEnglish);

  factory _MedalStandingsHead.fromJson(Map<String, dynamic> sourceJSON) =>
      _$_MedalStandingsHeadFromJson(sourceJSON);

  @override
  Map<String, dynamic> toJSON() => _$_MedalStandingsHeadToJson(this);
}

@JsonSerializable()
class _MedalStandings implements MedalStandings {
  @override
  final List<_Team> total;
  @override
  final List<_Team> men;
  @override
  final List<_Team> women;
  @override
  final List<_Team> mix;

  _MedalStandings(this.total, this.men, this.women, this.mix);

  factory _MedalStandings.fromJson(Map<String, dynamic> sourceJSON) =>
      _$_MedalStandingsFromJson(sourceJSON);

  @override
  Map<String, dynamic> toJSON() => _$_MedalStandingsToJson(this);
}

@JsonSerializable()
class _Team implements Team {
  @JsonKey(name: 'nocId')
  @override
  final String id;
  @JsonKey(name: 'nocName')
  @override
  final String name;
  @JsonKey(name: 'nocShortName')
  @override
  final String? shortName;
  @JsonKey(name: 'nocLogo')
  @override
  final String logoUrl;
  @JsonKey(name: 'nocUrl')
  @override
  final String url;
  @override
  final String total;
  @JsonKey(name: 'gold')
  @override
  final String totalOfGold;
  @JsonKey(name: 'silver')
  @override
  final String totalOfSilver;
  @JsonKey(name: 'bronze')
  @override
  final String totalOfBronze;
  @JsonKey(name: 'nocRank')
  @override
  final String rank;
  @JsonKey(name: 'nocGoldRank')
  @override
  final String rankOfGold;
  @JsonKey(name: 'nocSilverRank')
  @override
  final String rankOfSilver;
  @JsonKey(name: 'nocBronzeRank')
  @override
  final String rankOfBronze;

  _Team(
    this.id,
    this.name,
    this.shortName,
    this.logoUrl,
    this.url,
    this.totalOfGold,
    this.totalOfSilver,
    this.totalOfBronze,
    this.total,
    this.rank,
    this.rankOfGold,
    this.rankOfSilver,
    this.rankOfBronze,
  );

  factory _Team.fromJson(Map<String, dynamic> sourceJSON) =>
      _$_TeamFromJson(sourceJSON);

  @override
  Map<String, dynamic> toJSON() => _$_TeamToJson(this);
}
