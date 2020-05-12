import 'package:depolama_yontemeri_sqflite/shared_prefences.dart';
import 'package:depolama_yontemeri_sqflite/sqflite.dart';
import 'package:depolama_yontemeri_sqflite/yerel_dosya_pathProvider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SharedPreferencesView(),
                    ),
                  );
                },
                child: Text("Shared Preferences"),
                color: Colors.orange,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PathProviderView(),
                    ),
                  );
                },
                child: Text("Yerel Dosya - Path Provider"),
                color: Colors.deepPurple.shade200,
              ),


                RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SqfliteView(),
                    ),
                  );
                },
                child: Text("SQFLite"),
                color: Colors.red.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
