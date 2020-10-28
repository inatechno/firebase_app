import 'dart:convert';

import 'package:firebase_app/model/auth_model.dart';
import 'package:firebase_app/model/model_history.dart';
import 'package:firebase_app/model/model_insertbooking.dart';
import 'package:http/http.dart' as http;

class Network {
  static String _host = "udakita.com";

  Future<ModelAuth> registerUser(
    String email,
    String password,
    String nama,
    String phone,
  ) async {
    final url = Uri.http(_host, "servernotif/api/daftar");
    final response = await http.post(url, body: {
      "email": email,
      "password": password,
      "nama": nama,
      "phone": phone,
    });

    if (response.statusCode == 200) {
      ModelAuth modelResponse = ModelAuth.fromJson(jsonDecode(response.body));
      return modelResponse;
    } else {
      return null;
    }
  }

  Future<ModelAuth> loginUser(
    String email,
    String password,
    String device,
  ) async {
    final url = Uri.http(_host, "servernotif/api/login");
    final response = await http.post(url, body: {
      "f_email": email,
      "f_password": password,
      "device": device,
    });

    if (response.statusCode == 200) {
      ModelAuth modelResponse = ModelAuth.fromJson(jsonDecode(response.body));
      return modelResponse;
    } else {
      return null;
    }
  }

  Future<ModelAuth> insertFcm(String iduser, String token) async {
    final url = Uri.http(_host, "servernotif/api/registerGcm");
    final response = await http.post(url, body: {
      "f_idUser": iduser,
      "f_gcm": token,
    });

    if (response.statusCode == 200) {
      ModelAuth modelResponse = ModelAuth.fromJson(jsonDecode(response.body));
      return modelResponse;
    } else {
      return null;
    }
  }
  Future<ModelInsertBooking> insertBooking(iduser, latawal, longawal, jemput,
      latakhir, longakhir, antar, catatan, jarak, token, device) async {
    final uri = Uri.http(_host, "servernotif/api/insert_booking");
    final response = await http.post(uri, body: {
      "f_idUser": iduser,
      "f_latAwal": latawal,
      "f_lngAwal": longawal,
      "f_awal": jemput,
      "f_latAkhir": latakhir,
      "f_lngAkhir": longakhir,
      "f_akhir": antar,
      "f_catatan": catatan,
      "f_jarak": jarak,
      "f_token": token,
      "f_device": device
    });
    if (response.statusCode == 200) {
      ModelInsertBooking responseAuth =
          ModelInsertBooking.fromJson(jsonDecode(response.body));
      return responseAuth;
    } else {
      return null;
    }
  }
}
