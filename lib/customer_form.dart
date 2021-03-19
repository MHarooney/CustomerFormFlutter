import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:regform/bloc/customer_bloc.dart';
import 'package:regform/db/database_provider.dart';
import 'package:regform/events/add_customer.dart';
import 'package:regform/events/update_customer.dart';
import 'package:regform/model/customer.dart';
import 'package:regform/widgets/birthday_widget.dart';
import 'package:regform/widgets/custom_text_form_field.dart';
import 'package:regform/widgets/label.dart';
import 'package:uuid/uuid.dart';

class CustomerForm extends StatefulWidget {
  final Customer customer;
  final int customerIndex;
  final String idUser;

  CustomerForm({
    this.customer,
    this.customerIndex,
    this.idUser,
  });

  @override
  State<StatefulWidget> createState() {
    return CustomerFormState();
  }
}

class CustomerFormState extends State<CustomerForm> {
  final Customer customer = Customer();
  DateTime _doB;
  String _firstName, _lastName, _passportNo, _email, _imei;

  static var email = "mahmoud@gmail.com";
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildImage() => GestureDetector(
        child: buildAvatar(),
        onTap: () async {
          final image =
              await ImagePicker().getImage(source: ImageSource.camera);

          if (image == null) return;

          final directory = await getApplicationDocumentsDirectory();
          final id = '_${widget.idUser}_${Uuid().v4()}';
          final imageFile = File('${directory.path}/${id}_avatar.png');
          final newImage = await File(image.path).copy(imageFile.path);

          setState(() => customer.customerPhoto = newImage.toString());
        },
      );

  Widget buildAvatar() {
    final double size = 64;

    return CircleAvatar(
      radius: size,
      backgroundColor: Theme.of(context).unselectedWidgetColor,
      child: Icon(Icons.add, color: Colors.white, size: size),
    );
  }

  Widget _buildIMEI() {
    return CustomTextFormField(
      tffInitialValue: _imei.toString(),
      tffInputDecoration: InputDecoration(labelText: 'IMEI'),
      tffTextStyle: TextStyle(fontSize: 28),
      tffValidator: (String value) {
        if (value.isEmpty) {
          return 'IMEI is Required';
        }

        return null;
      },
      tffOnSaved: (String value) {
        _imei = value;
      },
    );
  }

  Widget _buildFirstName() {
    return CustomTextFormField(
      tffInitialValue: _firstName,
      tffInputDecoration: InputDecoration(labelText: 'First Name'),
      tffMaxLength: 15,
      tffTextStyle: TextStyle(fontSize: 28),
      tffValidator: (String value) {
        if (value.isEmpty) {
          return 'First Name is Required';
        }

        return null;
      },
      tffOnSaved: (String value) {
        _firstName = value;
      },
    );
  }

  Widget _buildLastName() {
    return CustomTextFormField(
      tffInitialValue: _lastName,
      tffInputDecoration: InputDecoration(labelText: 'Last Name'),
      tffMaxLength: 15,
      tffTextStyle: TextStyle(fontSize: 28),
      tffValidator: (String value) {
        if (value.isEmpty) {
          return 'Last Name is Required';
        }

        return null;
      },
      tffOnSaved: (String value) {
        _lastName = value;
      },
    );
  }

  Widget buildBirthday() => BirthdayWidget(
      birthday: customer.dateOfBirth,
      onChangedBirthday: (dateOfBirth) => setState(
            () => customer.dateOfBirth = dateOfBirth,
          ));

  Widget _buildPassportNo() {
    return CustomTextFormField(
      tffInitialValue: _passportNo,
      tffInputDecoration: InputDecoration(labelText: 'Passport number'),
      tffTextStyle: TextStyle(fontSize: 28),
      tffValidator: (String value) {
        if (value.isEmpty) {
          return 'Passport number is Required';
        }

        return null;
      },
      tffOnSaved: (String value) {
        _passportNo = value;
      },
    );
  }

  Widget _buildEmail() {
    return CustomTextFormField(
      tffInitialValue: _email,
      tffInputDecoration: InputDecoration(labelText: 'Email'),
      tffTextStyle: TextStyle(fontSize: 28),
      tffValidator: (input) => input = emailValid ? null : "Check your email",
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _firstName = widget.customer.firstName;
      _lastName = widget.customer.lastName;
      _passportNo = widget.customer.passportNo;
      _doB = widget.customer.dateOfBirth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Form")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildImage(),
                _buildIMEI(),
                _buildFirstName(),
                _buildLastName(),
                // _buildDOB(),
                Label(
                  text: 'Date Of Birth',
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
                SizedBox(height: 20),
                buildBirthday(),
                _buildPassportNo(),
                _buildEmail(),
                SizedBox(height: 20),
                widget.customer == null
                    ? ElevatedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          _formKey.currentState.save();

                          Customer customer = Customer(
                            firstName: _firstName,
                            lastName: _lastName,
                            dateOfBirth: _doB,
                            passportNo: _passportNo,
                          );

                          DatabaseProvider.db.insert(customer).then(
                                (storedCustomer) =>
                                    BlocProvider.of<CustomerBloc>(context).add(
                                  AddCustomer(storedCustomer),
                                ),
                              );

                          Navigator.pop(context);
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text(
                              "Update",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              if (!_formKey.currentState.validate()) {
                                print("form");
                                return;
                              }

                              _formKey.currentState.save();

                              Customer customer = Customer(
                                firstName: _firstName,
                                lastName: _lastName,
                                dateOfBirth: _doB,
                                passportNo: _passportNo,
                              );

                              DatabaseProvider.db.update(widget.customer).then(
                                    (storedCustomer) =>
                                        BlocProvider.of<CustomerBloc>(context)
                                            .add(
                                      UpdateCustomer(
                                          widget.customerIndex, customer),
                                    ),
                                  );

                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton(
                            child: Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
