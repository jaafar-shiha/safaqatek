class Setting {
  Setting({
    required this.userAgreement,
    required this.privacyPolicy,
    required this.termsConditions,
    required this.about,
    required this.supportPhone,
    required this.supportMessage,
    required this.donateOption,
    required this.showPrizeDetails,
  });

  String userAgreement;
  String privacyPolicy;
  String termsConditions;
  String about;
  String supportPhone;
  String supportMessage;
  bool donateOption;
  bool showPrizeDetails;

  factory Setting.fromMap(Map<String, dynamic> json) => Setting(
    userAgreement: json["user_agreement"],
    privacyPolicy: json["privecy_policy"],
    termsConditions: json["terms_conditions"],
    about: json["about"],
    supportPhone: json["support_phone"],
    supportMessage: json["support_message"],
    donateOption: json["donate_option"],
    showPrizeDetails: json["showPrizeDetails"],
  );

  Map<String, dynamic> toMap() => {
    "user_agreement": userAgreement,
    "privecy_policy": privacyPolicy,
    "terms_conditions": termsConditions,
    "about": about,
    "support_phone": supportPhone,
    "support_message": supportMessage,
    "donate_option": donateOption,
    "showPrizeDetails": showPrizeDetails,
  };
}
