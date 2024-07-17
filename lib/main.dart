import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Database initialization
  String dbPath = await getDatabasesPath();
  String path = join(dbPath, 'encrypted_db.db');

  // Key encryption
  String originalKey = 'my_secret_key';
  // Simplified encryption
  String encryptedKey = base64Encode(utf8.encode(originalKey));

  // Decryption
  String decryptedKey = utf8.decode(base64Decode(encryptedKey));

  // Open encrypted database
  Database database = await openDatabase(
    path,
    password: decryptedKey,
    onCreate: (db, version) async {
      await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)');
      await db.insert('Test', {'value': 'CTF{welcome_to_War_Game_By_Jeo}'});
    },
    //If you update the database ya ABDO you should update this version to number 2 and so on
    version: 1,
  );

  // Retrieve the value to check
  List<Map<String, dynamic>> result = await database.query('Test');
  print(result);

  runApp(MyApp(result: result));
}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> result;

  MyApp({required this.result});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Encrypted Database Example'),
        ),
        body: Center(
          child: Text(result.isNotEmpty ? result[0]['value'] : 'No data found'),
        ),
      ),
    );
  }
}
