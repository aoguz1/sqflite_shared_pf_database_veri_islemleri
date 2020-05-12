import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesView extends StatefulWidget {
  const SharedPreferencesView({Key key}) : super(key: key);

  @override
  _SharedPreferencesViewState createState() => _SharedPreferencesViewState();
}

class _SharedPreferencesViewState extends State<SharedPreferencesView> {
  bool cinsiyet;
  var formKey = GlobalKey<
      FormState>(); // form içindeki verileri kaydetmek vb işlemler yapmak için  oluştr
  String isim;
  int id;
  SharedPreferences mysharedpreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((sharedpf) {
      //sharedPreferences çalıştırdığımız yer. Oluşturduğumuz değere Sharedprefrences içindeki değeri atmış oluyoruz.
      mysharedpreferences = sharedpf;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (saveName) {
                    isim = saveName;
                  },
                  decoration: InputDecoration(
                    labelText: "İsminizi giriniz",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (idSave) {
                    id = int.parse(
                        idSave); // burda kayedettiğimiz değeri oluşturduğumuz değişkene atıyoruz.
                  },
                  decoration: InputDecoration(
                      labelText: "İd Giriniz",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              RadioListTile(
                title: Text("Kadın"),
                value: false,
                groupValue: cinsiyet,
                onChanged: (secildi) {
                  setState(() {
                    cinsiyet = secildi;
                  });
                },
              ),
              RadioListTile(
                title: Text("Erkek"),
                value: true,
                groupValue: cinsiyet,
                onChanged: ((radio) {
                  setState(
                    () {
                      cinsiyet =
                          radio; // burda kayedettiğimiz değeri oluşturduğumuz değişkene atıyoruz.
                    },
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.green,
                    child: Text('Ekle'),
                    onPressed: ekle,
                  ),
                  RaisedButton(
                    onPressed: goster,
                    child: Text("Göster"),
                    color: Colors.amber,
                  ),
                  RaisedButton(
                    onPressed: sil,
                    child: Text("Sil"),
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goster() {
    // sharedPreferences'de getDEĞİŞKEN_TİPİ ile değişkeni okuyoruz.
    debugPrint(
        "Okunan İsim : " + mysharedpreferences.getString("MyName") ?? "NULL");
    debugPrint("Okunan İD : " + mysharedpreferences.getInt("MyId").toString() ??
        "NULL");
    debugPrint("Okunan Cinsiyet : " +
            mysharedpreferences.getBool("MyGender").toString() ??
        "NULL");
  }

  void sil() {
    // remove ile değişkeni siliyoruz.
    mysharedpreferences.remove("MyName");
    mysharedpreferences.remove("MyId");
    mysharedpreferences.remove("MyGender");
  }

  void ekle() async {
    // ekleme işlemi uzun sürebilir bu yüzden ekleme işlemi yaparken async ve await kullanıyoruz
    formKey.currentState
        .save(); // oluşturduğumuz key değerini kullanarak textformfield widgetleri içindeki değerleri kayıt ediyor.

    // set_DEĞİŞKEN_TİPİ ile ekleme yapılıyor.Ekleme işleminde map methodu gibi bir yapı kullanılıyor : ("key" : value )

    await mysharedpreferences.setString("MyName", isim);
    await mysharedpreferences.setInt("MyId", id);
    await mysharedpreferences.setBool("MyGender", cinsiyet);
  }
}
