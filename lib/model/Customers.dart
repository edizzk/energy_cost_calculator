import 'dart:collection';

import 'package:energy_cost_calculator/model/Customer.dart';

class Customers {
  static Map<String, Customer> customers = HashMap();

  static Customer getCustomer (String serviceNumber) {
    customers.putIfAbsent(serviceNumber, () => Customer(serviceNumber: serviceNumber));
    return customers[serviceNumber]!;
  }

}