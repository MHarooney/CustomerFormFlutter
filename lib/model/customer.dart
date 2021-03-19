import 'package:regform/db/database_provider.dart';

class Customer {
  int id;
  int imei;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String passportNo;
  String email;
  String customerPhoto;

  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.passportNo,
    this.email,
    this.customerPhoto,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_IMEI: imei,
      DatabaseProvider.COLUMN_FIRST_NAME: firstName,
      DatabaseProvider.COLUMN_LAST_NAME: lastName,
      DatabaseProvider.COLUMN_DOB: dateOfBirth,
      DatabaseProvider.COLUMN_PASSPORT_NO: passportNo,
      DatabaseProvider.COLUMN_EMAIL: lastName,
      DatabaseProvider.COLUMN_CUSTOMER_PHOTO: customerPhoto,
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Customer.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    imei = map[DatabaseProvider.COLUMN_IMEI];
    firstName = map[DatabaseProvider.COLUMN_FIRST_NAME];
    lastName = map[DatabaseProvider.COLUMN_LAST_NAME];
    dateOfBirth = map[DatabaseProvider.COLUMN_DOB];
    passportNo = map[DatabaseProvider.COLUMN_PASSPORT_NO];
    email = map[DatabaseProvider.COLUMN_EMAIL];
    customerPhoto = map[DatabaseProvider.COLUMN_CUSTOMER_PHOTO];
  }
}
