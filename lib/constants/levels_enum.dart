import 'package:safaqtek/generated/l10n.dart';

enum Levels {
  bronze,
  silver,
  gold,
  platinum,
}

extension LevelsHelper on Levels {


  String getString() {
    switch (this) {
      case Levels.bronze:
        return S().bronze;
      case Levels.silver:
        return S().silver;
      case Levels.gold:
        return S().goldy;
      case Levels.platinum:
        return S().platinum;
      default:
        return S().bronze;
    }
  }
}
