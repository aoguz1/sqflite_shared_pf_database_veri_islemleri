class Ogrenci {
   int _id;
  String _isim;
  int _aktif;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get isim => _isim;

  int get aktif => _aktif;

  set aktif(int value) {
    _aktif = value;
  }

  set isim(String value) {
    _isim = value;
  }

  Ogrenci(this._isim, this._aktif);
  Ogrenci.withID(this._id, this._isim, this._aktif);

  
  Map<String, dynamic> dbyeYazmakicinMapeDonustur() {
    Map map = Map<String, dynamic>();

    map["id"] = id;
    map["ad"] = isim;
    map["aktif"] = aktif;

    return map;
  }

  Ogrenci.dbdenOkudugunObjeyeDonustur(Map<String, dynamic> map) {
    _id = map["id"];
    _isim = map["ad"];
    _aktif = map["aktif"];
  }


  @override
  String toString() {
    // TODO: implement toString
    return "Öğrenci : id $_id  isim : $_isim aktif : $_aktif";
    
  }
}
