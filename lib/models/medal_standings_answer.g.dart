// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medal_standings_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedalStandingsAnswer _$_MedalStandingsAnswerFromJson(
    Map<String, dynamic> json) {
  return _MedalStandingsAnswer(
    json['code'] as int,
    _MedalStandingsContent.fromJson(json['data'] as Map<String, dynamic>),
    json['version'] as String,
  );
}

Map<String, dynamic> _$_MedalStandingsAnswerToJson(
        _MedalStandingsAnswer instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.content,
      'version': instance.version,
    };

_MedalStandingsContent _$_MedalStandingsContentFromJson(
    Map<String, dynamic> json) {
  return _MedalStandingsContent(
    (json['head'] as List<dynamic>)
        .map((e) => _MedalStandingsHead.fromJson(e as Map<String, dynamic>))
        .toList(),
    _MedalStandings.fromJson(json['data'] as Map<String, dynamic>),
    _Team.fromJson(json['medalsInfo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_MedalStandingsContentToJson(
        _MedalStandingsContent instance) =>
    <String, dynamic>{
      'head': instance.heads,
      'data': instance.standings,
      'medalsInfo': instance.top,
    };

_MedalStandingsHead _$_MedalStandingsHeadFromJson(Map<String, dynamic> json) {
  return _MedalStandingsHead(
    json['desc'] as String,
    json['endesc'] as String,
  );
}

Map<String, dynamic> _$_MedalStandingsHeadToJson(
        _MedalStandingsHead instance) =>
    <String, dynamic>{
      'desc': instance.description,
      'endesc': instance.descriptionWithEnglish,
    };

_MedalStandings _$_MedalStandingsFromJson(Map<String, dynamic> json) {
  return _MedalStandings(
    (json['total'] as List<dynamic>)
        .map((e) => _Team.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['men'] as List<dynamic>)
        .map((e) => _Team.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['women'] as List<dynamic>)
        .map((e) => _Team.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['mix'] as List<dynamic>)
        .map((e) => _Team.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$_MedalStandingsToJson(_MedalStandings instance) =>
    <String, dynamic>{
      'total': instance.total,
      'men': instance.men,
      'women': instance.women,
      'mix': instance.mix,
    };

_Team _$_TeamFromJson(Map<String, dynamic> json) {
  return _Team(
    json['nocId'] as String,
    json['nocName'] as String,
    json['nocShortName'] as String?,
    json['nocLogo'] as String,
    json['nocUrl'] as String,
    json['gold'] as String,
    json['silver'] as String,
    json['bronze'] as String,
    json['total'] as String,
    json['nocRank'] as String,
    json['nocGoldRank'] as String,
    json['nocSilverRank'] as String,
    json['nocBronzeRank'] as String,
  );
}

Map<String, dynamic> _$_TeamToJson(_Team instance) => <String, dynamic>{
      'nocId': instance.id,
      'nocName': instance.name,
      'nocShortName': instance.shortName,
      'nocLogo': instance.logoUrl,
      'nocUrl': instance.url,
      'total': instance.total,
      'gold': instance.totalOfGold,
      'silver': instance.totalOfSilver,
      'bronze': instance.totalOfBronze,
      'nocRank': instance.rank,
      'nocGoldRank': instance.rankOfGold,
      'nocSilverRank': instance.rankOfSilver,
      'nocBronzeRank': instance.rankOfBronze,
    };
