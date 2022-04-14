import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_absensi/source/keluar.dart';
import 'package:flutter_absensi/source/masuk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerTerminal = TextEditingController();
  TextEditingController controllerWaktu = TextEditingController();
  var list = [];
  int status = 0;
  void submit() async {
    if (formKey.currentState!.validate()) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('terminal', controllerTerminal.text);
      pref.setString('status', status.toString());
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Masuk()));
      // if (status == 0) {
      // } else {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => Keluar()));
      // }
    }
  }

  var time;
  void selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        var result = "${newTime.hour}:${newTime.minute}";
        time = result;
        controllerWaktu.text = result;
      });
    }
    print(time);
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
                        decoration: const InputDecoration(
                            hintText: 'Masukan Nomor Terminal'),
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
                          controller: controllerWaktu,
                          decoration:
                              const InputDecoration(hintText: 'Masukan Jam'),
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
                // submit();
                list.add({
                  "terminal": controllerTerminal.text,
                  "status": status,
                });
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('setting', jsonEncode(list));
              },
              child: Text('SUBMIT'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                // submit();
                // print(list);
                SharedPreferences pref = await SharedPreferences.getInstance();
                var a = pref.getString('setting');
                 var json = jsonDecode(a.toString());
                print(json[0]);
              },
              child: Text('SUBMIT'),
            ),
          )
        ],
      ),
    );
  }
}
