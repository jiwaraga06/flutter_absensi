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
    var session = pref.getString('session');
    if (session != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Masuk()));
    } else {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
    }
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
