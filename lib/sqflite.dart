import 'package:flutter/material.dart';
import 'utils/database_helper.dart';
import 'package:depolama_yontemeri_sqflite/model/model.dart';

class SqfliteView extends StatefulWidget {
  SqfliteView({Key key}) : super(key: key);

  @override
  _SqfliteViewState createState() => _SqfliteViewState();
}

class _SqfliteViewState extends State<SqfliteView> {
  bool aktifmi = false;
  List<Ogrenci>
      tumogrencilistesi; // veritabanı işlemlerini bir liste üzerinden ekleme çıkarma ile yönetiyoruz.
  DatabaseHelper
      _databaseHelper; // database için singlethon olarak oluşturduğumuz yapıyı tanımlıyoruz.
  var formkey = GlobalKey<
      FormState>(); // oluşturulan formu kontrol etmek için key tanımlıyoruz
  var _controller =
      TextEditingController(); // text'teki verileri kontol etmek için controller oluşturuyoruz.
  var scaffoldkey = GlobalKey<
      ScaffoldState>(); // snackbar göstermek için snackbar oluşturuyoruz.
  int tiklananOgrenciIDsi;
  int tiklananogrenciIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // uygulamamız ilk çalışmaya başladığında  ilk olarak oluşturulacak işlemler initState blogu içinde yer alıyor.

    tumogrencilistesi =
        List<Ogrenci>(); // tanımladığımız değişkene listemizi atıyoruz
    _databaseHelper =
        DatabaseHelper(); // tanımladımız değişkene databaseHelper yapısını atıyoruz.
    _databaseHelper.tumOgrenciler().then(
      // liste üzerinden düzenleme yapmamız için database üzerindeki verileri listeye ekliyoruz.
      (maplistesitumogrenci) {
        for (var okunanogrenciMap in maplistesitumogrenci) {
          // database yapısı üzerinde mapler ile saklanan değerleri geziyoruz
          tumogrencilistesi.add(Ogrenci.dbdenOkudugunObjeyeDonustur(
              okunanogrenciMap)); // tanımladığımız değerleri listeye ekliyoruz.
        }
      },
    ).catchError(
      (err) {
        print("Bir hata oluştu hata kodu : $err");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("SQFlite"),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
              key:
                  formkey, //form işlemlerini kontrol edilmesi  için tanımladığımız yapı
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (kontroltext) {
                        // textformfield widgetine girilen karakterin uzunluğunun 3'den büyük olması durumunda yapılacak şeyleri gösteriyoruz.
                        if (kontroltext.length < 3) {
                          return "Lütfen 3'den fazla karakter giriniz";
                        } else
                          return null;
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: "Öğrenci adını giriniz",
                      ),
                    ),
                  ),
                  SwitchListTile(
                      title: Text("Aktif"),
                      value: aktifmi,
                      onChanged: (aktifdeger) {
                        setState(() {
                          aktifmi = aktifdeger;
                        });
                      }),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                    color: Colors.green,
                    child: Text("Kaydet"),
                    onPressed: () {
                      if (formkey.currentState.validate()) {
                        // eğer form validate olmuşsa (yani girilen text 3'den büyükse) parantez içlerindeki işlemler yapılır.
                        _ogrenciEkle(
                            /* oluşturduğumuz ogrenci ekle methodudan hangi verilerin gönderileceğini yazıyoruz. 
                        Kaydet sırasnda Ogrenci nesnesi üzeridnen işlemler yaptığımız için Ogrenci nesnesindeki consructorlardaki girilmesi gereken değerlere göre fonksiyonumuza değerleri gönderdik. */
                            Ogrenci(_controller.text, aktifmi == true ? 1 : 0));
                      }
                    }),
                RaisedButton(
                  color: Colors.yellow.shade700,
                  child: Text("Güncelle"),
                  onPressed: tiklananOgrenciIDsi ==
                          null // hiçbir  öğrenciye tıklanılmamışsa button aktif olmuyor.
                      ? null
                      : () {
                          print("tıklanan ogrenci id null degil");
                          if (formkey.currentState.validate()) { 
                            // kaydet methodu içindeki verilen değerlere göre işlemlerimiz yapılır.
                            _ogrenciGuncelle(  /*  oluşturuğumuzuz ogrenciGüncelle methoduna hangi verilerin gönderileceğini yazıyoruz. 
                            Burada güncelleme işlemi olduğu için seçilen öğrencinin id'si bizim için gerekli olduğundan Ogrenci.withID olan isimlendirilmiş consructoru kullandık. */
                              Ogrenci.withID(tiklananOgrenciIDsi,
                                  _controller.text, aktifmi == true ? 1 : 0),
                            );
                          }
                        },
                ),
                RaisedButton(
                    color: Colors.red,
                    child: Text("Tümünü Sil"),
                    onPressed: () {
                      _tumogrenciSil(); //oluşturduğumuz öğrencilerin tümünü veri tabanından siler. Burada her hangi bir bilgi göndermeyeceğimiz için Ogrenci nesnesini kullanmadık.
                    }),
              ],
            ),
            Expanded(
              child: ListView.builder(
                // verilerin listelendiği bölüm
                itemCount: tumogrencilistesi.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: tumogrencilistesi[index].aktif ==
                            1 // aktiflik değerine göre renk değişimini oluşturdum.
                        ? Colors.green.shade300
                        : Colors.red.shade300,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _controller.text = tumogrencilistesi[index].isim;
                          aktifmi = tumogrencilistesi[index].aktif == 1
                              ? true
                              : false;
                          tiklananogrenciIndex = index;
                          tiklananOgrenciIDsi = tumogrencilistesi[index].id;
                        });
                      },
                      title: Text(tumogrencilistesi[index].isim),
                      subtitle: Text(tumogrencilistesi[index].id.toString()),
                      trailing: GestureDetector(
                          onTap: () {   /* burada listTile içindeden çöp ikonuna basıldığında sadece bir öğrenci silineceği için silinecek öğrencinin idsi ve 
                          listtile içinde bulunan index numarasını oluşturacağımız fonksiyona parametre olarak gönderiyoruz.  */
                          
                            ogrenciSil(tumogrencilistesi[index].id, index);
                          },
                          child: Icon(Icons.delete)),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _ogrenciEkle(Ogrenci ogrenci) async {
    var eklenenogrenciID = await _databaseHelper.ogrenciEkle(ogrenci);
    ogrenci.id = eklenenogrenciID;

    if (eklenenogrenciID > 0) {
      setState(() {
        tumogrencilistesi.insert(0, ogrenci);
      });
    }
  }

  void _tumogrenciSil() async {
    var silinenOgrenciSayisi = await _databaseHelper.tumogrencileriSil();
    /* databaseye giderek databaseHelper sınıfında tanımladığımız tumogrencileriSil methodunu çalıştırır.
     Bu method da içinde bulundurduğu yapıya göre silme işlmeni gerçekleştirir. */
    if (silinenOgrenciSayisi >= 0) {
      // silinenOgrenciSayisi veritabanından kaç adet öğrenci silindiğini gösterir. Eğer 0'dan fazla ise snackbarda bu durumu kullanıcıya gösteriyoruz.
      scaffoldkey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text("$silinenOgrenciSayisi kayıt silindi"),
        ),
      );
      setState(() {
        tumogrencilistesi.clear();
        _controller.text = "";
      });
    }
    tiklananOgrenciIDsi = null;
  }

  void ogrenciSil(int dbdenSilecekID, int listviewIndex) async {
    var sonuc = await _databaseHelper.ogrenciSil(dbdenSilecekID); 
     /* silinenecek öğrenciyi idsini kullanark databaseHelperda oluşturduğumuz ogrenciSil methoduna göndeririz
     ve bize geriye silinen öğrenci adedini döndürür. */
    if (sonuc == 1) {
      scaffoldkey.currentState.showSnackBar(    
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Kayıt Silindi"),
        ),
      );

      setState(() {
        tumogrencilistesi.removeAt(listviewIndex); // sildiğimiz öğreniyi liste üzerinden de silmemize yararyacak kod
      });
    } else {
      scaffoldkey.currentState.showSnackBar(
        SnackBar(
          content: Text("Hata Çıktı"),
        ),
      );
    }
    tiklananOgrenciIDsi = null;
  }

  void _ogrenciGuncelle(Ogrenci ogrenci) async {
    var sonuc = await _databaseHelper.ogrenciGuncelle(ogrenci); // güncelleyeceğimiz kod bloğu

    if (sonuc == 1) {
      scaffoldkey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Kayıt Güncellendi"),
        ),
      );
    }

    setState(
      () {
        tumogrencilistesi[tiklananogrenciIndex] = ogrenci;
      },
    );
  }
}
