import 'package:regform/model/customer.dart';

import 'customer_event.dart';

class SetCustomers extends CustomerEvent {
  List<Customer> customerList;

  SetCustomers(List<Customer> customers) {
    customerList = customers;
  }
}
