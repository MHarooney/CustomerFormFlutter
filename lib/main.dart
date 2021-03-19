import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regform/customer_list.dart';

import 'bloc/customer_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerBloc>(
      create: (context) => CustomerBloc([]),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Customer Form Sample',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: CustomerList(),
      ),
    );
  }
}
