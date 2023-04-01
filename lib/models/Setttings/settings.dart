import 'package:safaqtek/models/Setttings/country.dart';
import 'package:safaqtek/models/Setttings/level.dart';
import 'package:safaqtek/models/Setttings/product_category.dart';
import 'package:safaqtek/models/Setttings/setting.dart';

class Settings {
  Settings({
    required this.levels,
    required this.countries,
    required this.setting,
    required this.productCategories,
    required this.currencies,
    required this.stripeKey,
  });

  List<Level> levels;
  List<Country> countries;
  Setting setting;
  List<ProductCategory> productCategories;
  List<String> currencies;
  String stripeKey;

  factory Settings.fromMap(Map<String, dynamic> json) => Settings(
        levels: List<Level>.from(json["levels"].map((x) => Level.fromMap(x))),
        countries: List<Country>.from(json["countries"].map((x) => Country.fromMap(x))),
        setting: Setting.fromMap(json["setting"]),
        productCategories:
            List<ProductCategory>.from(json["prouduct_categories"].map((x) => ProductCategory.fromMap(x))),
        currencies: List<String>.from(json["currencies"].map((x) => x)),
        stripeKey: json["stripe_key"],
      );

  Map<String, dynamic> toMap() => {
        "levels": List<dynamic>.from(levels.map((x) => x.toMap())),
        "countries": List<dynamic>.from(countries.map((x) => x.toMap())),
        "setting": setting.toMap(),
        "prouduct_categories": List<dynamic>.from(productCategories.map((x) => x.toMap())),
        "currencies": List<dynamic>.from(currencies.map((x) => x)),
        "stripe_key": stripeKey,
      };
}
