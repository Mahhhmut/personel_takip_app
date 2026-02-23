import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart'; // Giriş başarılıysa yönlendirilecek ekran

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personel Girişi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "E-posta"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Şifre"),
              obscureText: true, // Şifreyi gizli yapar
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    if (email.isNotEmpty && password.isNotEmpty) {
                    var result = await AuthService().login(email, password);

                    if (result != null) {
                        // Giriş başarılı!
                        String token = result['token'];
                        String name = result['user']['full_name'];
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Hoş geldin, $name!")),
                        );

                        //ana sayfaya yönlendirme
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(userName: name)),
                        );
                        
                        // Burada ana sayfaya yönlendirme yapacağız (Sıradaki adım)
                    } else {
                        // Giriş başarısız!
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("E-posta veya şifre hatalı!")),
                        );
                    }
                    }
                },
                child: const Text("Giriş Yap"),
                ),
          ],
        ),
      ),
    );
  }
}