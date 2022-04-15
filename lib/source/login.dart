import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_absensi/source/keluar.dart';
import 'package:flutter_absensi/source/masuk.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_range/time_range.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerTerminal = TextEditingController();
  TextEditingController controllerWaktuAwal = TextEditingController();
  TextEditingController controllerWaktuAkhir = TextEditingController();
  var list = [];
  var data = [];
  int status = 0;
  void submit() async {
    if (formKey.currentState!.validate()) {
      list.add({
        "terminal": controllerTerminal.text,
        "waktuAwal": controllerWaktuAwal.text,
        "waktuAkhir": controllerWaktuAkhir.text,
        "status": status,
      });
      print(list);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('terminal', controllerTerminal.text);
      pref.setString('status', status.toString());
      pref.setString('setting', jsonEncode(list));
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Masuk()));
      // if (status == 0) {
      // } else {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => Keluar()));
      // }
    }
  }

  var timeAwal;
  void selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        timeAwal = newTime.toString().split('(')[1].substring(0, 5);
        controllerWaktuAwal.text = timeAwal;
      });
    }
    print(timeAwal);
  }

  var timeAkhir;
  void selectTimeAkhir() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        timeAkhir = newTime.toString().split('(')[1].substring(0, 5);
        controllerWaktuAkhir.text = timeAkhir;
      });
    }
    print(timeAkhir);
  }

  var a = [
    {
      "waktu": "10:00",
      "waktuL": "10:10",
    },
    {
      "waktu": "11:00",
      "waktuL": "11:10",
    },
  ];
  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    final time = TimeOfDay.now();
    TimeOfDay time1 = TimeOfDay(hour: 09, minute: 10);
    TimeOfDay time2 = TimeOfDay(hour: 01, minute: 20);
    a.forEach((element) { 
      var b= element['waktu'] == "10:00";
      print(b);
      print(element);
    });
    // print(a.singleWhere((value) => value['waktu'] == "11:00"));
    // if (time.hour.clamp(14, 15) == time.hour && time.minute.clamp(00, 01) == time.minute) {
    //   print('jam');
    // } else {
    //   print('bukan');
    // }
    // final startTime = DateTime.now();
    // final endTime = DateTime(2018, 6, 23, 16, 00);
    // final currentTime = DateTime.now();

    // if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
    //   print('ada');
    // } else {
    //   print('ga');
    // }
    // print(time.toString().split('(')[1].substring(0, 5));
    // print(time);
    // print(format.format(date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Absensi'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controllerTerminal,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Masukan Nomor Terminal'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kolom ini tidak boleh kosong";
                          }
                        },
                      ),
                      InkWell(
                        onTap: () {
                          selectTime();
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: controllerWaktuAwal,
                          decoration: const InputDecoration(hintText: 'Masukan Jam Awal'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Kolom ini tidak boleh kosong";
                            }
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          selectTimeAkhir();
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: controllerWaktuAkhir,
                          decoration: const InputDecoration(hintText: 'Masukan Jam Akhir'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Kolom ini tidak boleh kosong";
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = 0;
                        });
                      },
                    ),
                    const Text('Masuk'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = 1;
                        });
                      },
                    ),
                    const Text('Keluar'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                submit();
              },
              child: Text('SUBMIT'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                // submit();
                // print(controllerWaktuAkhir.text.toString().split(':')[1]);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Masuk()));
                // print(list);
                // SharedPreferences pref = await SharedPreferences.getInstance();
                // var a = pref.getString('setting');
                // var json = jsonDecode(a.toString());
                // data = json;
                // var result = data.takeWhile((value) => value['waktu'] == "08:40");
                // // print();
                // result.forEach((element) {
                //   print(element);
                // });
                // // print(json);
                // print("data $data");
              },
              child: Text('SUBMIT'),
            ),
          )
        ],
      ),
    );
  }
}
