import 'dart:convert';

import 'package:flutter_absensi/Api/api.dart';
import 'package:http/http.dart' as http;

class Network {
  Future getInfoId(id) async {
    try {
      var url = Uri.parse(Api.infoId(id));
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token()}'},
      );
      return response;
    } catch (e) {
      print('Error info id $e');
    }
  }

  Future getLastId(id) async {
    try {
      var url = Uri.parse(Api.lastId(id));
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${Api.token()}'},
      );
      return response;
    } catch (e) {
      print('Error last id $e');
    }
  }

  Future absen(kartu, terminal ) async {
    try {
      var url = Uri.parse(Api.absen(kartu, terminal));
      var response = await http.post(
        url,
        headers: {'Authorization': 'Bearer ${Api.token()}'},
        // body: {
        //   "kartu_id" :kartu.toString(),
        //   "terminaz": terminal.toString(),
        //   "statuz": "1",
        // }
      );
      return response;
    } catch (e) {
      print('Error absen id $e');
    }
  }
  Future absenKeluar(kartu, terminal ) async {
    try {
      var url = Uri.parse(Api.absenKeluar(kartu, terminal));
      var response = await http.post(
        url,
        headers: {'Authorization': 'Bearer ${Api.token()}'},
        // body: {
        //   "kartu_id" :kartu.toString(),
        //   "terminaz": terminal.toString(),
        //   "statuz": "1",
        // }
      );
      return response;
    } catch (e) {
      print('Error absen id $e');
    }
  }
}
