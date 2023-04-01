class HourglassImage{

  static double getSoldOutQuantityPercent({required int soldOutQuantity, required int totalQuantity}) {
    if (soldOutQuantity > totalQuantity) {
      return 1.0;
    }
    double percent = soldOutQuantity * 100 / totalQuantity;
    return percent / 100;
  }

  static String getHourglass({required double percent}) {
    if (percent <= 0.35) {
      return 'assets/images/green_hourglass.png';
    } else if (percent > 0.35 && percent <= 0.75) {
      return 'assets/images/yellow_hourglass.png';
    } else if (percent > 0.75) {
      return 'assets/images/red_hourglass.png';
    } else {
      return 'assets/images/green_hourglass.png';
    }
  }
}