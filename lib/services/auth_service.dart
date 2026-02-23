import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  
  final String baseUrl = "http://192.168.1.8:3000"; 

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("user_id", data['user']['id']);
        await prefs.setString("token", data['token']);

        return data;
      } else {
        print("Hata: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Bağlantı Hatası: $e");
      return null;
    }
  }
}