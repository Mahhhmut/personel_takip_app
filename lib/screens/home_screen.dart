import 'package:flutter/material.dart';
import 'login_screen.dart'; // Giriş ekranına geri dönmek için
import 'package:shared_preferences/shared_preferences.dart';
import 'qr_scanner_screen.dart'; // QR kod tarayıcı ekranı
import '../services/auth_service.dart'; // Kullanıcı bilgisi için
import '../services/attendance_service.dart'; // Mesai kaydı için

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personel Paneli"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hoş geldin, $userName!", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () async{
                // 1 Kamerayı aç ve QR kodu bekle
                final String? scannedCode = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerScreen()),
                );

                // 2. Eğer QR doğruysa 
                if (scannedCode == 'MESAI_GIRIS') {
  final prefs = await SharedPreferences.getInstance();
  final int? userId = prefs.getInt('user_id');

  if (userId != null) {
    bool success = await AttendanceService().checkIn(userId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mesai Başarıyla Başlatıldı!"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sunucu hatası! Kayıt yapılamadı.")),
      );
    }
  }
}

              },
              icon: const Icon(Icons.login),
              label: const Text("Mesaiye Başla"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () { /* Backend'e 'Çıkış Yaptı' bilgisi gidecek */ },
              icon: const Icon(Icons.logout),
              label: const Text("Mesaiyi Bitir"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
