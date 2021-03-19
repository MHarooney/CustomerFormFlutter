import 'package:regform/model/customer.dart';

import 'customer_event.dart';

class AddCustomer extends CustomerEvent {
  Customer newCustomer;

  AddCustomer(Customer customer) {
    newCustomer = customer;
  }
}
