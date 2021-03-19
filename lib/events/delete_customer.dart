import 'customer_event.dart';

class DeleteCustomer extends CustomerEvent {
  int customerIndex;

  DeleteCustomer(int index) {
    customerIndex = index;
  }
}
