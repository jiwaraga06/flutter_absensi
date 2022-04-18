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
  bool loadingList = false;
  int status = 0;
  void submit() async {
    if (formKey.currentState!.validate()) {
      list.add({
        "terminal": controllerTerminal.text,
        "waktuAwal": controllerWaktuAwal.text,
        "waktuAkhir": controllerWaktuAkhir.text,
        "jamAwal": int.parse(controllerWaktuAwal.text.toString().split(':')[0]),
        "menitAwal": int.parse(controllerWaktuAwal.text.toString().split(':')[1]),
        "jamAkhir": int.parse(controllerWaktuAkhir.text.toString().split(':')[0]),
        "menitAkhir": int.parse(controllerWaktuAkhir.text.toString().split(':')[1]),
        "status": status,
      });
      print(list);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('terminal', controllerTerminal.text);
      pref.setString('status', status.toString());
      pref.setString('setting', jsonEncode(list));
      // pref.setString('session', 'login');
      controllerTerminal.clear();
      controllerWaktuAwal.clear();
      controllerWaktuAkhir.clear();
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

  void getSetting() async {
    setState(() {
      loadingList = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var setting = pref.getString('setting');
    var json = jsonDecode(setting.toString());
    // print(setting);
    if (setting != null) {
      setState(() {
        list = json;
        loadingList = false;
      });
    } else {
      setState(() {
        loadingList = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Absensi'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          list.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                      child: Text(
                    'Event Kosong',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  )),
                )
              : Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = list[index];
                        return Row(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  list.removeAt(index);
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  pref.setString('setting', jsonEncode(list));
                                  getSetting();
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red[800],
                                  size: 35,
                                )),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: data['status'] == 0 ? Colors.green[600] : Colors.red[700],
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 3.0,
                                        spreadRadius: 3.0,
                                        offset: const Offset(1, 3),
                                      ),
                                    ]),
                                child: Column(
                                  children: [
                                    data['status'] == 0
                                        ? const Text(
                                            'MASUK',
                                            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600),
                                          )
                                        : const Text(
                                            'KELUAR',
                                            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600),
                                          ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Start : ${data['waktuAwal']}',
                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                            ),
                                            const SizedBox(height: 12.0),
                                            Text(
                                              'End   : ${data['waktuAkhir']}',
                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'Terminal',
                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                            ),
                                            const SizedBox(height: 12.0),
                                            Text(
                                              data['terminal'],
                                              style: TextStyle(color: Colors.white, fontSize: 23),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
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
                      TextFormField(
                        onTap: () {
                          selectTime();
                        },
                        readOnly: true,
                        controller: controllerWaktuAwal,
                        decoration: const InputDecoration(hintText: 'Masukan Jam Awal'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kolom ini tidak boleh kosong";
                          }
                        },
                      ),
                      TextFormField(
                        onTap: () {
                          selectTimeAkhir();
                        },
                        readOnly: true,
                        controller: controllerWaktuAkhir,
                        decoration: const InputDecoration(hintText: 'Masukan Jam Akhir'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kolom ini tidak boleh kosong";
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                          onPressed: () async {
                            submit();
                            getSetting();
                          },
                          child: Text('TAMBAHKAN'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (list.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Alert'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Text('Event Harus Di isi')],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'),
                                      )
                                    ],
                                  );
                                },
                              );
                            } else {
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              pref.setString('session', 'login');
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Masuk()));
                            }
                          },
                          child: Text('MASUK'),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
