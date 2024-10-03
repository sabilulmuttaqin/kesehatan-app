import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Logo Truss
          const SizedBox(height: 150), // Jarak dari atas ke logo
          const FlutterLogo(
            size: 120, // Sesuaikan ukuran logo Truss di sini
          ),
          const SizedBox(height: 30),
          // Teks
          const Text(
            'Lelah dengan\npenyakit anda?',
            textAlign: TextAlign.center, // Rata tengah
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Solusi dari penyakit anda ada bersama kami.\nSilahkan daftar sekarang',
            textAlign: TextAlign.center, // Rata tengah
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const Spacer(), // Memisahkan konten dan tombol
          // Tombol Get Started dan Not have an account?
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tombol Get Started
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman login
                  Get.toNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                      double.infinity, 50), // Membuat tombol memanjang
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  backgroundColor:  Color(0xFF3C887E), // Warna hijau army
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Tombol Not have an account?
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman registrasi
                  Get.toNamed('/register');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                      double.infinity, 50), // Membuat tombol memanjang
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  backgroundColor: Colors.grey, // Warna abu-abu
                ),
                child: const Text(
                  'Not have an account?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Ruang tambahan di bawah tombol
        ],
      ),
    );
  }
}
