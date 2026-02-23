import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Bu dosyayı şimdi oluşturacağız

void main() {
  runApp(const PersonelTakipApp());
}

class PersonelTakipApp extends StatelessWidget {
  const PersonelTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personel Takip Sistemi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Uygulama giriş ekranıyla açılacak
    );
  }
}