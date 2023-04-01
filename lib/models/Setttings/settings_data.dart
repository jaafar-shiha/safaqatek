import 'package:safaqtek/models/Setttings/settings.dart';

class SettingsData {
  SettingsData({
    required this.data,
  });

  Settings data;

  factory SettingsData.fromMap(Map<String, dynamic> json) => SettingsData(
    data: Settings.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data.toMap(),
  };
}
