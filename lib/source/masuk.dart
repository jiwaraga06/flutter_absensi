import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absensi/Api/network.dart';
import 'package:flutter_absensi/source/login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class Masuk extends StatefulWidget {
  final Network? network;
  const Masuk({Key? key, this.network}) : super(key: key);

  @override
  State<Masuk> createState() => _MasukState();
}

class _MasukState extends State<Masuk> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  int isMasuk = 0;

  AudioPlayer player = AudioPlayer();
  late Uint8List audiobytes;

  var loading = true;
  // var setting = [];
  var list = {};
  var data = {};
  var array = [];

  void masuk(id) async {
    print('masuk');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var terminal = pref.getString('terminal');
    Network().getInfoId(id).then((value) async {
      var json = jsonDecode(value.body);
      print(json);
      if (json is List) {
        if (json[0]['statuz'] == 1) {
          Network().absen(id, terminal).then((value) async {
            var json = jsonDecode(value.body);
            print("JSON ABSEN MASUK: $json");
            if (json['status'] == 200) {
              Network().getLastId(id).then((value) async {
                var jsonLast = jsonDecode(value.body);
                print(jsonLast);
                if (jsonLast is List) {
                  Timer(Duration(seconds: 3), () {
                    setState(() {
                      data = jsonLast[0];
                      data.clear();
                      controller.clear();
                    });
                  });
                } else {
                  Timer(Duration(seconds: 3), () {
                    setState(() {
                      data = jsonLast;
                      data.clear();
                      controller.clear();
                    });
                  });
                }
                print("Data: $data");
              });
            } else {
              gagalAbsen(json['status'].toString());
            }
          });
        } else if (json[0]['statuz'] == 2) {
          play();
          alertPoli(json[0]['FullName']);
          await Future.delayed(Duration(seconds: 5));
          Navigator.pop(context);
          controller.clear();
        }
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

  void getSetting() async {
    DateTime date = DateTime.now();
    TimeOfDay time = TimeOfDay.now();
    var format = time.toString().split('(')[1].substring(0, 5);
    var jam = format.toString().split(':')[0];
    var menit = format.toString().split(':')[1];
    SharedPreferences pref = await SharedPreferences.getInstance();
    var settings = pref.getString('setting');
    var json = jsonDecode(settings.toString());
    setState(() {
      array = json;
    });
    print(format);
    print('JSON : $json');
    if (settings != null) {
      loading = false;
      // var result = json.singleWhere((value) => value['waktuAwal'] == format.toString());
      json.forEach((element) {
        var hasiljam1 = element['waktuAwal'].toString().split(':')[0];
        var hasilmenit1 = element['waktuAwal'].toString().split(':')[1] == 00 ? 00 : element['waktuAwal'].toString().split(':')[1];
        var hasiljam2 = element['waktuAkhir'].toString().split(':')[0];
        var hasilmenit2 = element['waktuAkhir'].toString().split(':')[1] == 00 ? 00 : element['waktuAkhir'].toString().split(':')[1];
        print("Element : $element");
        if (time.hour.clamp(int.parse(hasiljam1), int.parse(hasiljam2)) == time.hour &&
            time.hour.clamp(int.parse(hasilmenit1.toString()), int.parse(hasilmenit2.toString())) == time.minute) {
          setState(() {
            list = element;
          });
          print('ada');
        } else {
          print("Kosong menit");
          setState(() {
            list.clear();
          });
        }
      });

      // }
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // pref.setString("savesSetting", list.toString());
      print('LIST : $list');
      // });
    }
  }

  void getSaveSetting() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var settings = pref.getString('setting');
    var save = pref.getString("savesSetting");
    var json = jsonDecode(settings.toString());
  }

  @override
  void initState() {
    super.initState();
    // play();
    // masuk();
    Timer.periodic(Duration(seconds: 1), (timer) {
      getSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: list.isEmpty
            ? const Text("", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))
            : list['status'] == 0
                ? const Text("MASUK", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))
                : const Text("KELUAR", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600)),
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
          loading
              ? const SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : list.isEmpty
                  ? SizedBox(
                      height: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text('Sistem Offline', style: TextStyle(color: Colors.white, fontSize: 25))],
                      ))
                  : Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: list['status'] == 0 ? Colors.green : Colors.red[700],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      height: 400,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.green,
                            decoration: const InputDecoration(
                              fillColor: Colors.green,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) async {
                              if (value.length >= 9) {
                                await Future.delayed(Duration(milliseconds: 650));
                                masuk(controller.text);
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

  void play() async {
    ByteData bytes = await rootBundle.load("assets/Announce.mp3");
    audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await player.playBytes(audiobytes);
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

  void alertPoli(nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'STOP !',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.yellow),
              ),
              Divider(color: Colors.yellow, thickness: 5),
              Text(
                'KEPADA $nama',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600, color: Colors.yellow),
              ),
              Text(
                'MOHON HUBUNGI POLIKLINIK PERUSAHAAN ATAU SATPAM',
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
