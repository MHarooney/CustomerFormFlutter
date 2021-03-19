import 'package:path/path.dart';
import 'package:regform/model/customer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String DATABASE_NAME = "customerFormDB.db";
  static const String TABLE_CUSTOMERS = "customers";
  static const String COLUMN_ID = "id";
  static const String COLUMN_IMEI = "imei";
  static const String COLUMN_FIRST_NAME = "firstName";
  static const String COLUMN_LAST_NAME = "lastName";
  static const String COLUMN_DOB = "dateOfBirth";
  static const String COLUMN_PASSPORT_NO = "passport";
  static const String COLUMN_EMAIL = "email";
  static const String COLUMN_CUSTOMER_PHOTO = "customerPhoto";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, '$DATABASE_NAME'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating customers table");

        await database.execute(
          "CREATE TABLE $TABLE_CUSTOMERS ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_IMEI INTEGER,"
          "$COLUMN_FIRST_NAME TEXT,"
          "$COLUMN_LAST_NAME TEXT,"
          "$COLUMN_DOB BLOB,"
          "$COLUMN_PASSPORT_NO TEXT,"
          "$COLUMN_EMAIL TEXT,"
          "$COLUMN_CUSTOMER_PHOTO TEXT"
          ")",
        );
      },
    );
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;

    var customers = await db.query(TABLE_CUSTOMERS, columns: [
      COLUMN_ID,
      COLUMN_IMEI,
      COLUMN_FIRST_NAME,
      COLUMN_LAST_NAME,
      COLUMN_DOB,
      COLUMN_PASSPORT_NO,
      COLUMN_EMAIL,
      COLUMN_CUSTOMER_PHOTO,
    ]);

    List<Customer> customerList = [];

    customers.forEach((currentCustomer) {
      Customer customer = Customer.fromMap(currentCustomer);

      customerList.add(customer);
    });

    return customerList;
  }

  Future<List<Customer>> getAllCustomers2() async {
    final dbClient = await database;
    List<Map> maps = await dbClient.query(TABLE_CUSTOMERS);

    return maps.isNotEmpty
        ? maps.map((customer) => Customer.fromMap(customer)).toList()
        : [];
  }

  Future<Customer> getCustomer(int id) async {
    final dbClient = await database;
    List<Map> maps = await dbClient.query(
      TABLE_CUSTOMERS,
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return Customer.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Customer> insert(Customer customer) async {
    final db = await database;
    customer.id = await db.insert(TABLE_CUSTOMERS, customer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return customer;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_CUSTOMERS,
      where: "$COLUMN_ID = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Customer customer) async {
    final db = await database;

    return await db.update(
      TABLE_CUSTOMERS,
      customer.toMap(),
      where: "$COLUMN_ID = ?",
      whereArgs: [customer.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
