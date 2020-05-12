import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PathProviderView extends StatefulWidget {
  PathProviderView({Key key}) : super(key: key);

  @override
  _PathProviderViewState createState() => _PathProviderViewState();
}

class _PathProviderViewState extends State<PathProviderView> {
  var mycontroller = TextEditingController();

// kodlarda genelde async ve await kullanıyoruz çünkü dosya oluşturma klasor yolu belirleme gibi şeyler uzun sürecek işlemler olabilir.

// olusturulacak dosya yolunu belirliyoruz.
  Future<String> get dosyaYolu async {
    var klasor =
        await getApplicationDocumentsDirectory(); // telefonun dosyalarının bulunduğu dizini bize verir.
    debugPrint("Klasor yolu : " + klasor.path);
    return klasor.path;
  }

// dosya olusturma ,, burada oluşturulan dosyanın yolunu kullanarak File() ile klasör yolumuzu vererek dosya oluşturuyoruz
  Future<File> get dosyaOlustur async {
    var klasoryolu = await dosyaYolu;
    return File(klasoryolu + "mydosyam.txt");
  }

// dosya oluşturulan dosyanın içindeki değeri okuma işlemi yapar
  Future<String> dosyayaOku() async {
    try {
      var olusturulanDosya = await dosyaOlustur;
      String okunanDosya = await olusturulanDosya
          .readAsString(); // oluşturulan dosya içindeki string degeri alıp string bir değişkene atar
      return okunanDosya;
    } catch (err) {
      debugPrint(
          "bir hata çıktı : $e"); // eğer bu işlemde bir hata çıkması durumunda catch bloğu içindeki yer yazdırılır.
    }
  }

  Future<File> dosyayaYaz(String yazilacakString) async {
    var mydosya =
        await dosyaOlustur; // dosya oluştur değerini bir değişkene aktatıp
    return mydosya.writeAsString(
        yazilacakString); // burdada verdiğimiz değeri dosyaya yazar.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Path Provider"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: mycontroller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Lütfen mesajınızı buraya giriniz..",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                color: Colors.amber,
                onPressed: _dosyayaYaz,
                child: Text("Dosyaya Yaz"),
              ),
              RaisedButton(
                color: Colors.orange,
                onPressed: _dosyadanOku,
                child: Text("Dosyadan Oku"),
              )
            ],
          )
        ],
      ),
    );
  }

  void _dosyayaYaz() {
    dosyayaYaz(mycontroller.text
        .toString()); // textfield içindeki değeri dosyaya yaz methoduna gönderdik.
  }

  void _dosyadanOku() {
    dosyayaOku().then((deger) => debugPrint(deger));
  }
}
