import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/home/data/models/saved_trip_model.dart';
import 'dart:ui';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flights.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_trips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        airlineName TEXT,
        airlineLogoText TEXT,
        airlineLogoColor INTEGER,
        departureTime TEXT,
        arrivalTime TEXT,
        departureCode TEXT,
        departureCity TEXT,
        arrivalCode TEXT,
        arrivalCity TEXT,
        duration TEXT,
        logoUrl TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> saveTrip(SavedTripModel trip) async {
    final db = await instance.database;
    
    final existing = await db.query(
      'saved_trips',
      where: 'airlineName = ? AND departureTime = ? AND departureCode = ?',
      whereArgs: [trip.airlineName, trip.departureTime, trip.departureCode],
    );

    if (existing.isNotEmpty) {
      return -1;
    }

    return await db.insert('saved_trips', {
      'airlineName': trip.airlineName,
      'airlineLogoText': trip.airlineLogoText,
      'airlineLogoColor': trip.airlineLogoColor.value,
      'departureTime': trip.departureTime,
      'arrivalTime': trip.arrivalTime,
      'departureCode': trip.departureCode,
      'departureCity': trip.departureCity,
      'arrivalCode': trip.arrivalCode,
      'arrivalCity': trip.arrivalCity,
      'duration': trip.duration,
      'logoUrl': trip.logoUrl,
      'date': trip.date,
    });
  }

  Future<List<SavedTripModel>> getSavedTrips({int? limit, int? offset}) async {
    final db = await instance.database;
    final result = await db.query(
      'saved_trips',
      orderBy: 'id DESC',
      limit: limit,
      offset: offset,
    );

    return result.map((map) => SavedTripModel(
      id: map['id'] as int?,
      airlineName: map['airlineName'] as String,
      airlineLogoText: map['airlineLogoText'] as String,
      airlineLogoColor: Color(map['airlineLogoColor'] as int),
      departureTime: map['departureTime'] as String,
      arrivalTime: map['arrivalTime'] as String,
      departureCode: map['departureCode'] as String,
      departureCity: map['departureCity'] as String,
      arrivalCode: map['arrivalCode'] as String,
      arrivalCity: map['arrivalCity'] as String,
      duration: map['duration'] as String,
      logoUrl: map['logoUrl'] as String?,
      date: map['date'] as String,
    )).toList();
  }

  Future<int> deleteTrip(int id) async {
    final db = await instance.database;
    return await db.delete(
      'saved_trips',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getSavedTripsCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM saved_trips');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
