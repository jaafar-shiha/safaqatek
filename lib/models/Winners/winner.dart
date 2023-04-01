class Winner {
  Winner({
    required this.firstName,
    required this.lastName,
    required this.url,
    required this.awardName,
    required this.announcedOn,
    required this.coupon,
    required this.isCurrentUser,
  });

  String firstName;
  String lastName;
  String url;
  String awardName;
  String announcedOn;
  String coupon;
  bool isCurrentUser;

  factory Winner.fromMap(Map<String, dynamic> json) => Winner(
    firstName: json["firstname"],
    lastName: json["lastname"],
    url: json["url"],
    awardName: json["award_name"],
    announcedOn: json["announced_on"],
    coupon: json["coupon"],
    isCurrentUser: json["is_current_user"],
  );

  Map<String, dynamic> toMap() => {
    "firstname": firstName,
    "lastname": lastName,
    "url": url,
    "award_name": awardName,
    "announced_on": announcedOn,
    "coupon": coupon,
    "is_current_user": isCurrentUser,
  };
}