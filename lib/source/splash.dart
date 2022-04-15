import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi/source/keluar.dart';
import 'package:flutter_absensi/source/login.dart';
import 'package:flutter_absensi/source/masuk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var status = pref.getString('status');
    // if (status == '0') {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Masuk()));
    // } else if (status == '1') {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Keluar()));
    // } else if (status == null) {
    // }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Center(child: CupertinoActivityIndicator()),
          Text('Loading', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
