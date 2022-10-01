import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'InOut'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String zalogujWyloguj = 'Zaloguj';
  String zalogowano = 'Zalogowano';
  String wylogowano = 'Wylogowano';
  late bool czyZalogowany;
  //late Future<bool> _czyZalogowany;
  String czyZalogowanyKey = 'czyZalogowany';
  MaterialColor background = Colors.green;
  final numerZalogowania = '*451#';
  final numerWylogowania = '*452#';
  final numerStatus = '*454#';

  @override
  void initState() {
    _loadStatus();
    // czyZalogowany = _prefs.then((SharedPreferences prefs) {
    //   return prefs.getBool(czyZalogowanyKey) ?? 0;
    // });
    //print(czyZalogowany);
    super.initState();
  }

  Future<void> _loadStatus() async {
    SharedPreferences prefs = await _prefs;
    //print('PREFS: ${prefs.getBool(czyZalogowanyKey)}');
    czyZalogowany = (prefs.getBool(czyZalogowanyKey) ?? false);
    //print('czy zalogowany: $czyZalogowany');
    setState(() {
      if (czyZalogowany == true) {
        background = Colors.red;
        zalogujWyloguj = 'Wyloguj';
      } else {
        background = Colors.green;
        zalogujWyloguj = 'Zaloguj';
      }
    });

    //prefs.setBool(czyZalogowanyKey, czyZalogowany);
    //print(czyZalogowany);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: 350, height: 150),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  primary: background,
                  onPrimary: Colors.black,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  SnackBar snackBar = SnackBar(
                      //duration: const Duration(milliseconds: 100),
                      content:
                          czyZalogowany ? Text(wylogowano) : Text(zalogowano));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    _zadzwon();
                    // if (czyZalogowany == false) {
                    //   background = Colors.red;
                    //   zalogujWyloguj = 'Wyloguj';
                    //   _zadzwon(numerZalogowania);
                    //   // await FlutterPhoneDirectCaller.callNumber(
                    //   //     numerZalogowania);
                    //   czyZalogowany = true;
                    // } else {
                    //   background = Colors.green;
                    //   zalogujWyloguj = 'Zaloguj';
                    //   _zadzwon(numerWylogowania);
                    //   // await FlutterPhoneDirectCaller.callNumber(
                    //   //     numerWylogowania);
                    //   czyZalogowany = false;
                    // }
                  });
                },
                child: Text(zalogujWyloguj),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 40,
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 100, height: 50),
                  child: ElevatedButton(
                    onPressed: () async {
                      _status(numerStatus);
                      //await FlutterPhoneDirectCaller.callNumber(numerStatus);

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Wysłano zapytanie o status'),
                      ));
                    },
                    child: const Text('Status'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _zadzwon() async {
    //await FlutterPhoneDirectCaller.callNumber(numer);
    SharedPreferences prefs = await _prefs;
    setState(() {
      if (czyZalogowany == false) {
        try {
          FlutterPhoneDirectCaller.callNumber(numerZalogowania);
          prefs.setBool(czyZalogowanyKey, true);
          czyZalogowany = (prefs.getBool(czyZalogowanyKey) ?? true);
          background = Colors.red;
          zalogujWyloguj = 'Wyloguj';
          //print(numerZalogowania);
        } catch (e) {
          //prin
        }
      } else {
        FlutterPhoneDirectCaller.callNumber(numerWylogowania);
        prefs.setBool(czyZalogowanyKey, false);
        czyZalogowany = (prefs.getBool(czyZalogowanyKey) ?? false);
        background = Colors.green;
        zalogujWyloguj = 'Zaloguj';
        //print(numerWylogowania);
      }
    });
    //print('Preferences - ${prefs.getBool(czyZalogowanyKey)}');
    //print('$czyZalogowany :');
  }

  _status(String numer) async {
    await FlutterPhoneDirectCaller.callNumber(numer);
    //print('Status: $numer');
  }
}
