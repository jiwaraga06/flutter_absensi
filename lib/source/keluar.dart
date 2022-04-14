import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_absensi/Api/network.dart';
import 'package:flutter_absensi/source/login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class Keluar extends StatefulWidget {
  final Network? network;
  const Keluar({Key? key, this.network}) : super(key: key);

  @override
  State<Keluar> createState() => _KeluarState();
}

class _KeluarState extends State<Keluar> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  var data = {};

  void keluar(id) async {
    print('keluar');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var terminal = pref.getString('terminal');
    Network().getInfoId(id).then((value) async {
      var json = jsonDecode(value.body);
      print(json);
      if (json is List) {
        Network().absenKeluar(id, terminal).then((value) async {
          var json = jsonDecode(value.body);
          print("JSON ABSEN MASUK: $json");
          if (json['status'] == 200) {
            Network().getLastId(id).then((value) async {
              var jsonLast = jsonDecode(value.body);
              print(jsonLast);
              if (jsonLast is List) {
                setState(() {
                  data = jsonLast[0];
                  Timer(Duration(seconds: 3), () {
                    data.clear();
                  });
                  controller.clear();
                });
              } else {
                setState(() {
                  data = jsonLast;
                  Timer(Duration(seconds: 3), () {
                    data.clear();
                  });
                  controller.clear();
                });
              }
              print("Data: $data");
            });
          } else {
            gagalAbsen(json['status'].toString());
          }
        });
      } else {
        setState(() {
          data = json;
          Timer(Duration(seconds: 3), () {
            data.clear();
          });
          controller.clear();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // masuk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text("KELUAR", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            onPressed: () {
              alert();
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.red[700],
              borderRadius: BorderRadius.circular(12.0),
            ),
            height: 400,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.red[700]),
                  cursorColor: Colors.red[700],
                  decoration: InputDecoration(
                    fillColor: Colors.red[700],
                    border: InputBorder.none,
                  ),
                  onChanged: (value) async {
                    if (value.length >= 9) {
                      await Future.delayed(Duration(milliseconds: 650));
                      keluar(value);
                    }
                  },
                ),
                data.isNotEmpty
                    ? Column(
                        children: [
                          Text(
                            data['barcode'].toString() == 'null' ? '' : data['barcode'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          Text(
                            data['FullName'].toString() == 'null' ? '' : data['FullName'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          Text(
                            data['Tanggal'].toString() == 'null' ? '' : data['Tanggal'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          Text(
                            data['waktu'].toString() == 'null' ? '' : data['waktu'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          Text(
                            data['status'].toString() == 'null' ? '' : data['status'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DigitalClock(
              is24HourTimeFormat: true,
              areaDecoration: const BoxDecoration(color: Colors.transparent),
              hourMinuteDigitTextStyle: const TextStyle(color: Colors.white, fontSize: 50),
              hourMinuteDigitDecoration: const BoxDecoration(color: Colors.transparent),
              secondDigitDecoration: const BoxDecoration(color: Colors.transparent),
              secondDigitTextStyle: const TextStyle(color: Colors.white, fontSize: 50),
            ),
          ),
        ],
      ),
    );
  }

  void alert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Setup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controllerUsername,
                decoration: InputDecoration(hintText: "Masukan Username"),
              ),
              TextFormField(
                obscureText: true,
                controller: controllerPassword,
                decoration: InputDecoration(hintText: "Masukan Password"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tutup')),
            TextButton(
                onPressed: () {
                  setup();
                },
                child: Text('Masuk')),
          ],
        );
      },
    );
  }

  void gagalAbsen(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text(message.toString())],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tutup')),
          ],
        );
      },
    );
  }

  void setup() async {
    if (controllerUsername.text != 'admin' && controllerPassword.text != 'admin') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [Text('Username atau Password salah !')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Tutup')),
            ],
          );
        },
      );
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.clear();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Login()), (route) => false);
    }
  }
}
