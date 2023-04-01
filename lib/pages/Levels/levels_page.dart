import 'package:flutter/material.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/levels_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/pages/Levels/level_card.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class LevelsPage extends StatefulWidget {
  const LevelsPage({Key? key}) : super(key: key);

  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {

  Levels currentActiveLevel(){
    int userPurchases = locator<MainApp>().currentUser!.purchases!;
    if (userPurchases >= 0 && userPurchases <25){
      return Levels.bronze;
    }
    else if (userPurchases >= 25 && userPurchases <50){
      return Levels.silver;
    }
    else if (userPurchases >= 50 && userPurchases <100){
      return Levels.gold;
    }
    else if (userPurchases >= 100){
      return Levels.platinum;
    }
    return Levels.bronze;
}
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.whiteLilac,
                    ),
                  ),
                  Text(
                    S.of(context).levels,
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.whiteLilac,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:  [
                    LevelCard(
                      level: Levels.bronze,
                      isActive: currentActiveLevel().index == Levels.bronze.index,
                      message: currentActiveLevel().index == Levels.bronze.index ? S.of(context).youAreHere : S.of(context).startHere,
                    ),
                    LevelCard(
                      level: Levels.silver,
                      isActive: currentActiveLevel().index == Levels.silver.index,
                      message: currentActiveLevel().index == Levels.silver.index ? S.of(context).youAreHere : S.of(context).getMore25PurchasesToReachThisLevel,
                    ),
                    LevelCard(
                      level: Levels.gold,
                      isActive: currentActiveLevel().index == Levels.gold.index,
                      message: currentActiveLevel().index == Levels.gold.index ? S.of(context).youAreHere : S.of(context).getMore50PurchasesToReachThisLevel,
                    ),
                    LevelCard(
                      level: Levels.platinum,
                      isActive: currentActiveLevel().index == Levels.platinum.index,
                      message: currentActiveLevel().index == Levels.platinum.index ? S.of(context).youAreHere : S.of(context).getMore100PurchasesToReachThisLevel,
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
