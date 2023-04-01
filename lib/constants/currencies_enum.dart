import 'package:safaqtek/generated/l10n.dart';

enum Currencies {
  aed,
  // bhd,
  // omr,
  // qar,
  // sar,
  // kwd
}

extension CurrenciesHelper on Currencies{
  String getCurrencyCode(){
    switch(this){
      case Currencies.aed:
        return S().AEDCurrency;
      // case Currencies.bhd:
      //   return S().BHD;
      // case Currencies.omr:
      //   return S().OMR;
      // case Currencies.qar:
      //   return S().QAR;
      // case Currencies.sar:
      //   return S().SAR;
      // case Currencies.kwd:
      //   return S().KWD;
      default:
        return S().AEDCurrency;
    }
  }

  String getCurrencyFlag(){
    switch(this){
      case Currencies.aed:
        return 'assets/countriesFlags/ae.png';
      // case Currencies.bhd:
      //   return 'assets/countriesFlags/bh.png';
      // case Currencies.omr:
      //   return 'assets/countriesFlags/om.png';
      // case Currencies.qar:
      //   return 'assets/countriesFlags/qa.png';
      // case Currencies.sar:
      //   return 'assets/countriesFlags/sa.png';
      default:
        return 'assets/countriesFlags/ae.png';
    }
  }


}
