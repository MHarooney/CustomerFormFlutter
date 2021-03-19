import 'package:regform/model/customer.dart';

import 'customer_event.dart';

class UpdateCustomer extends CustomerEvent {
  Customer newCustomer;
  int customerIndex;

  UpdateCustomer(int index, Customer customer) {
    newCustomer = customer;
    customerIndex = index;
  }
}
