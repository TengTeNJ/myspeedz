import 'package:my_speedz/models/battle_speed_model.dart';
import 'package:my_speedz/models/solo_speed_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/constants.dart';

class DataBaseHelper{
  static final DataBaseHelper _instance = DataBaseHelper._internal();

  factory DataBaseHelper() {
    return _instance;
  }

  DataBaseHelper._internal();
  Database? _database;
  // Database? _videoDatabase;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), kDataBaseTableName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db,int version) async{
    await db.execute('''
       CREATE TABLE ${kDataBaseTableName} (
          id INTERGER PRIMARYKEY,
          speedData TEXT,
          name TEXT,
          time TEXT
       )
     ''');

    await db.execute('''
       CREATE TABLE ${kDataBaseBattleListTableName} (
          id INTERGER PRIMARYKEY,
          redSpeedData TEXT,
          greenSpeedData TEXT,
          redName TEXT,
          greenName TEXT,
          time TEXT
       )
     ''');
  }

  Future<int> insertData(String table,SoloSpeedModel data) async {
    Database db = await database;
    return await db.insert(table, data.toJson());
  }

  Future<List<SoloSpeedModel>> getData(String table) async {
    Database db = await database;
    final _datas  = await db.rawQuery('SELECT * FROM ${table}');
    List<SoloSpeedModel> array = [];
    _datas.asMap().forEach((index,element){
      SoloSpeedModel model = SoloSpeedModel.modelFromJson(element);
      array.add(model);
    });
    return array;
  }

  Future<int> insertBattleData(String table,BattleSpeedModel data) async {
    Database db = await database;
    return await db.insert(table, data.toJson());
  }

  Future<List<BattleSpeedModel>> getBattleData(String table) async {
    Database db = await database;
    final _datas  = await db.rawQuery('SELECT * FROM ${table}');
    List<BattleSpeedModel> array = [];
    _datas.asMap().forEach((index,element){
      BattleSpeedModel model = BattleSpeedModel.modelFromJson(element);
      array.add(model);
    });
    return array;
  }


}