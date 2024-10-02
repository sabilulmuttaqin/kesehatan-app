import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../../home/views/home_view.dart';

const users = {
  'test@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null; // Berhasil login
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null; // Bisa ditambahkan validasi signup sesuai kebutuhan
    });
  }

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null; // Berhasil memulihkan password
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Mengubah background menjadi putih
      body: FlutterLogin(
        logo: const AssetImage('assets/images/ecorp-lightblue.png'), // Pastikan asset ini benar
        onLogin: _authUser,
        onSignup: _signupUser,
        onRecoverPassword: _recoverPassword,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeView(),
            ),
          );
        },
        theme: LoginTheme(
          primaryColor: Colors.blue, // Warna utama
          accentColor: Colors.blueAccent, // Warna aksen
          buttonTheme: LoginButtonTheme(
            backgroundColor: Colors.white, // Mengubah warna tombol menjadi putih
            elevation: 0, // Menghilangkan bayangan tombol
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Mengatur bentuk tombol
            ),
          ),
          inputTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFFE0E0E0), // Warna abu-abu untuk input
            border: OutlineInputBorder(
              borderSide: BorderSide.none, // Menghilangkan border
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 20), // Padding dalam input
          ),
        ),
      ),
    );
  }
}
