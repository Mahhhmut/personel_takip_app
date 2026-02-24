import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'qr_scanner_screen.dart';
import '../services/attendance_service.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  // Giriş ve Çıkış işlemlerini yöneten ortak fonksiyon
  Future<void> _handleQRAction(BuildContext context, bool isCheckIn) async {
    // 1. Kamerayı aç ve QR kodu bekle
    final String? scannedCode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    if (scannedCode == null) return; // Kullanıcı okutmadan çıktıysa

    // 2. QR Kod Kontrolü (Duvardaki kodla eşleşmeli)
    if (scannedCode == 'MESAI_GIRIS') {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('user_id');

      if (userId != null) {
        bool success;
        // isCheckIn true ise giriş, false ise çıkış servisini çağır
        if (isCheckIn) {
          success = await AttendanceService().checkIn(userId);
        } else {
          success = await AttendanceService().checkOut(userId);
        }

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isCheckIn ? "Mesai Başlatıldı!" : "Mesai Bitirildi!",
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Hata: Kayıt yapılamadı!"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Geçersiz QR Kod!"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personel Paneli"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hoş geldin, $userName!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),

            // MESİYE BAŞLA BUTONU
            ElevatedButton.icon(
              onPressed: () => _handleQRAction(context, true),
              icon: const Icon(Icons.login),
              label: const Text("Mesaiye Başla"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
            ),

            const SizedBox(height: 20),

            // MESAİYİ BİTİR BUTONU
            ElevatedButton.icon(
              onPressed: () => _handleQRAction(context, false),
              icon: const Icon(Icons.logout),
              label: const Text("Mesaiyi Bitir"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
