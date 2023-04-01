import 'package:safaqtek/models/Winners/winner.dart';

class WinnersData {
  WinnersData({
    required this.winners,
  });

  List<Winner> winners;

  factory WinnersData.fromMap(Map<String, dynamic> json) => WinnersData(
    winners: List<Winner>.from(json["data"].map((x) => Winner.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(winners.map((x) => x.toMap())),
    // "links": links.toMap(),
    // "meta": meta.toMap(),
  };
}
