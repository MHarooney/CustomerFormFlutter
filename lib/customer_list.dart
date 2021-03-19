import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regform/customer_form.dart';
import 'package:regform/db/database_provider.dart';
import 'package:regform/events/delete_customer.dart';
import 'package:regform/events/set_customers.dart';
import 'package:regform/model/customer.dart';

import 'bloc/customer_bloc.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getAllCustomers().then(
      (customerList) {
        BlocProvider.of<CustomerBloc>(context).add(SetCustomers(customerList));
      },
    );
  }

  showCustomerDialog(BuildContext context, Customer customer, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer.firstName),
        content: Text("ID ${customer.id}"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomerForm(customer: customer, customerIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          TextButton(
            onPressed: () => DatabaseProvider.db.delete(customer.id).then((_) {
              BlocProvider.of<CustomerBloc>(context).add(
                DeleteCustomer(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire customer list scaffold");
    return Scaffold(
      appBar: AppBar(
        title: Text("Persistent storage"),
        leading: Icon(Icons.device_unknown),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: BlocConsumer<CustomerBloc, List<Customer>>(
          builder: (context, customerList) {
            return ListView.builder(
              itemBuilder: (context, index) {
                print("customerList: $customerList");

                Customer customer = customerList[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).unselectedWidgetColor,
                      child: Icon(Icons.supervised_user_circle_sharp,
                          color: Colors.white, size: 30),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    title: Text("${customer.firstName} ${customer.lastName}",
                        style: TextStyle(fontSize: 26)),
                    // subtitle: Text(
                    //   // "Calories: ${food.calories}\nVegan: ${customer.isVegan}",
                    //   "Last Name: ${customer.lastName}",
                    //   style: TextStyle(fontSize: 20),
                    // ),
                    onTap: () => showCustomerDialog(context, customer, index),
                  ),
                );
              },
              itemCount: customerList.length,
            );
          },
          listener: (BuildContext context, customerList) {},
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => CustomerForm()),
      ),
    );
  }
}
