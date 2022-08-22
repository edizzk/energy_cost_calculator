import 'PriceItem.dart';

class Customer {
  String serviceNumber;
  int cost = 0;
  List<int> readings = [];
  Customer({required this.serviceNumber});

  static const maxValue = 999999999;

  List<PriceItem> priceItemList =  [
    PriceItem(maxValue: 0, price: 0),
    PriceItem(maxValue: 100, price: 5),
    PriceItem(maxValue: 500, price: 8),
    PriceItem(maxValue: maxValue, price: 10),
  ];

  /*     ANOTHER EXAMPLE
   List<PriceItem> priceItemList =  [
    PriceItem(maxValue: 0, price: 0),
    PriceItem(maxValue: 200, price: 10),
    PriceItem(maxValue: 400, price: 15),
    PriceItem(maxValue: 1000, price: 30),
    PriceItem(maxValue: maxValue, price: 50),
  ];
  */

  bool setReadings (int reading) {
    if (readings.isNotEmpty && readings.last > reading) {
      return false;
    }
    readings.add(reading);
    if (readings.length == 1) {
      cost = _calculateCost(reading);
    } else {
      cost = _calculateCost(reading - readings[readings.length-2]);
    }
    return true;
  }

  int _calculateCost(int diff) {
    int total = 0;
    for(int i=1; i < priceItemList.length; i++){
      if(priceItemList[i].maxValue >= diff) {
        total += (diff - priceItemList[i-1].maxValue) * priceItemList[i].price;
        break;
      } else {
        total += (priceItemList[i].maxValue - priceItemList[i-1].maxValue) * priceItemList[i].price;
      }
    }
    return total;
  }

}