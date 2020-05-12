import 'dart:async';
import 'dart:io';
import 'package:depolama_yontemeri_sqflite/model/model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String _ogrenciTablo = "ogrenci";
  String _columnID = "id";
  String _isim = "ad";
  String _aktif = "aktif";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();

      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      print("DB nulldi oluşturulacak");
      _database = await initializeDatabase();
      return _database;
    } else {
      print("DB null değil var olan database kullanılacak");
      return _database;
    }
  }

  Future initializeDatabase() async {
    Directory klasor =
        await getApplicationDocumentsDirectory(); // c:oguz/document gibi bir adres verir
    String path = join(klasor.path,
        "ogrenci.db"); // join  ile verilen adresi oluşturucağımız dosya adi ile birleştiriyoruz.
    print("DB yolu oluşturuldu : $path");

    return openDatabase(path, version: 1, onCreate: createDB);
  }

  FutureOr<void> createDB(Database db, int version) async {
    print("create tablo metodu çalıştı tablo oluşturuluyor");
    await db.execute(
        "CREATE TABLE $_ogrenciTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_isim TEXT, $_aktif INTEGER )");
  }

  //veri tababına öğrenci ekleyecek fonksiyon
  Future<int> ogrenciEkle(Ogrenci ogrenci) async {
    var db = await _getDatabase(); // veri tabanını çalıştırıyoruz.
    var sonuc = await db.insert(
        // veri tabanına insert methodu ile veri ekliyor.
        _ogrenciTablo,
        ogrenci.dbyeYazmakicinMapeDonustur(),
        nullColumnHack:
            _columnID); //nulColumnhack eğer veri girilmemişse oraları null ile doldurup satırlarında işlem yapmasını sağlar.
    print("öğrenci dbye eklendi " + sonuc.toString());
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumOgrenciler() async {
    var db = await _getDatabase(); //
    var sonuc = await db.query(_ogrenciTablo, orderBy: '$_columnID DESC');

    print(sonuc);
    return sonuc;
  }

  Future<int> ogrenciGuncelle(Ogrenci ogrenci) async {
    var db = await _getDatabase(); //  veri tabanını başlatıyoruz
    var sonuc = db.update(_ogrenciTablo, ogrenci.dbyeYazmakicinMapeDonustur(),
        where: '$_columnID = ?',// soru işaretinin oluduğu yere whereArgs'de tanımladğımız parametre giriyor.
        whereArgs: [
          ogrenci.id
        ]); // ilk olarak işlem yapacağımız tablo adını giriiyoruz daha sonra

    return sonuc;
  }

  Future<int> ogrenciSil(int id) async {
    var db = await _getDatabase();
    var sonuc =
        db.delete(_ogrenciTablo, where: '$_columnID = ?  ',// soru işaretinin oluduğu yere whereArgs'de tanımladğımız parametre giriyor.
         whereArgs: [id]);
    return sonuc;
  }

  tumogrencileriSil() async {
    var db = await _getDatabase();
    var sonuc = db.delete(_ogrenciTablo);
    return sonuc;
  }
}
