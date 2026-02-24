import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceService {
  final String baseUrl = "http://192.168.1.8:3000"; // Senin güncel IP'n

  Future<bool> checkIn(int userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/attendance/check-in"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Check-in hatası: $e");
      return false;
    }
  }

  Future<bool> checkOut(int userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/attendance/check-out"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
