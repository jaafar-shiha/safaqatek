// import 'package:safaqtek/models/Products/link.dart';
//
// class Meta {
//   Meta({
//     required this.currentPage,
//      this.from,
//     required this.lastPage,
//     required this.links,
//     required this.path,
//     required this.perPage,
//     required this.to,
//     required this.total,
//   });
//
//   int currentPage;
//   int from;
//   int lastPage;
//   List<Link> links;
//   String path;
//   int perPage;
//   int to;
//   int total;
//
//   factory Meta.fromMap(Map<String, dynamic> json) => Meta(
//     currentPage: json["current_page"],
//     from: json["from"],
//     lastPage: json["last_page"],
//     links: List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
//     path: json["path"],
//     perPage: json["per_page"],
//     to: json["to"],
//     total: json["total"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "current_page": currentPage,
//     "from": from,
//     "last_page": lastPage,
//     "links": List<dynamic>.from(links.map((x) => x.toMap())),
//     "path": path,
//     "per_page": perPage,
//     "to": to,
//     "total": total,
//   };
// }