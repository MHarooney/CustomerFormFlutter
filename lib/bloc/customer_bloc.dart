import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regform/events/add_customer.dart';
import 'package:regform/events/customer_event.dart';
import 'package:regform/events/delete_customer.dart';
import 'package:regform/events/set_customers.dart';
import 'package:regform/events/update_customer.dart';
import 'package:regform/model/customer.dart';

class CustomerBloc extends Bloc<CustomerEvent, List<Customer>> {
  CustomerBloc(List<Customer> initialState) : super(initialState);

  List<Customer> get initialState => [];

  @override
  Stream<List<Customer>> mapEventToState(CustomerEvent event) async* {
    if (event is SetCustomers) {
      yield event.customerList;
    } else if (event is AddCustomer) {
      List<Customer> newState = List.from(state);
      if (event.newCustomer != null) {
        newState.add(event.newCustomer);
      }
      yield newState;
    } else if (event is DeleteCustomer) {
      List<Customer> newState = List.from(state);
      newState.removeAt(event.customerIndex);
      yield newState;
    } else if (event is UpdateCustomer) {
      List<Customer> newState = List.from(state);
      newState[event.customerIndex] = event.newCustomer;
      yield newState;
    }
  }
}
