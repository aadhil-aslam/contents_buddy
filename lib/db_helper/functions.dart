import 'package:contents_buddy/db_helper/db_connection.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class Functions {
  late DatabaseConnection _databaseConnection;
  Functions() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  //Insert new contacts
  insertContacts(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  //Read all contacts
  readAllContacts(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  //Search saved contacts
  searchContacts(table, contactName, contactNumber, extraNumber) async {
    print(contactName);
    var connection = await database;
    return await connection?.query(table, where: 'name=? OR number=? OR extranumber=?', whereArgs: [contactName, contactNumber, extraNumber]);
  }

  //Update contact details
  updateContacts(table, data) async{
    var connection = await database;
    return await connection?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  //Delete contact
  deleteContacts(table, contactId) async{
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$contactId");
  }
}
