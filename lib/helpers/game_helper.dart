import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String idColumn = "idColumn";
String nameColumn = "nameColumn";
String genreColumn = "genreColumn";
String hoursColumn = "hoursColumn";
String imgColumn = "imgColumn";
String gameTable = "gameTable";

class GameHelper {
  static final GameHelper _instance = GameHelper.internal();
  factory GameHelper() => _instance;
  GameHelper.internal();
  Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async{
    final DatabasePath = await getDatabasesPath();
    final path = join(DatabasePath, "games.db");
    return await openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async {
      await db.execute("CREATE TABLE $gameTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $genreColumn TEXT, $hoursColumn TEXT, $imgColumn TEXT)");
    },
    );
  }

  Future<List> getAllGames() async{
    Database dbGame = await db;
    List listMap = await dbGame.rawQuery("SELECT * FROM $gameTable");
    List<Game> listGame = [];
    for(Map m in listMap){
      listGame.add(Game.fromMap(m));
    }
    return listGame;
  }

  Future<Game?> getGame(int id) async{
    Database dbGame = await db;
    List<Map> maps = await dbGame.query(gameTable, columns: [idColumn, nameColumn, genreColumn, hoursColumn, imgColumn], where: "$idColumn = ?", whereArgs: [id]);
    if(maps.isNotEmpty){
      return Game.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<Game> saveGame(Game game) async{
    Database dbGame = await db;
    game.id = (await dbGame.insert(gameTable, game.toMap())) as String;
    return game;
  }

  Future<int> updateGame(Game game) async{
    Database dbGame = await db;
    return await dbGame.update(gameTable, game.toMap(), where: "$idColumn = ?", whereArgs: [game.id]);
  }

  Future<int> deleteGame(Game game) async{
    Database dbGame = await db;
    return await dbGame.delete(gameTable, where: "$idColumn = ?", whereArgs: [game.id]);
  }

}

class Game{
  Game();

  late String id;
  late String name;
  late String genre;
  late String hours;
  late String img;

  Game.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    genre = map[genreColumn];
    hours = map[hoursColumn];
    img = map[imgColumn];
  }

  Map<String, Object?> toMap(){
    var map = <String, Object?>{
      nameColumn: name,
      genreColumn: genre,
      hoursColumn: hours,
      imgColumn: img
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString(){
    return "Game(id: $id, name: $name, genre: $genre, hours: $hours, img: $img)";
  }
}