// import 'package:safaqtek/generated/l10n.dart';
// import 'package:flutter/material.dart';
//
// import '../entities/prizes_type_model.dart';
//
// enum PrizesType{
//   allPrizes,
//   motors,
//   gold,
//   tech
// }
// extension PrizesTypeX on PrizesType{
//   PrizesTypeModel getAppropriatePrizesType(BuildContext context){
//     switch(this){
//       case PrizesType.allPrizes:
//         return PrizesTypeModel(label: S.of(context).allPrizes,);
//       case PrizesType.motors:
//         return PrizesTypeModel(label: S.of(context).motors,iconPath: 'assets/images/car.png');
//       case PrizesType.gold:
//         return PrizesTypeModel(label: S.of(context).gold,iconPath: 'assets/images/jewelry.png');
//       case PrizesType.tech:
//         return PrizesTypeModel(label: S.of(context).tech,iconPath: 'assets/images/phone.png');
//       default:
//         return PrizesTypeModel(label: S.of(context).allPrizes);
//     }
//   }
// }