import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';

class ProfileController extends GetxController {
  var profileImage = Rx<File?>(null);
  var username = ''.obs;
  late TextEditingController usernameController;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    loadProfileData();
  }

  @override
  void onClose() {
    usernameController.dispose();
    super.onClose();
  }

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImage.value = File(image.path);
      await saveProfile(); // Simpan gambar setelah diambil
    } else {
      Get.snackbar('Error', 'Gagal mengambil gambar dari galeri.');
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      profileImage.value = File(image.path);
      await saveProfile(); // Simpan gambar setelah diambil
    } else {
      Get.snackbar('Error', 'Gagal mengambil gambar dari kamera.');
    }
  }

  // Fungsi untuk menyimpan profile
  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan username
    if (usernameController.text.isNotEmpty) {
      username.value = usernameController.text;
      await prefs.setString('username', username.value);

      // Tambahkan efek getar di sini
      if (await Vibration.hasVibrator() != null) {
        Vibration.vibrate(duration: 200); // Getar selama 200 ms
      }
    }

    // Simpan foto profil
    if (profileImage.value != null) {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = profileImage.value!.path.split('/').last;
        final savedImage =
            await profileImage.value!.copy('${appDir.path}/$fileName');
        await prefs.setString('profileImagePath', savedImage.path);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to save profile image: $e',
          duration:
              const Duration(seconds: 1), // Durasi notifikasi lebih pendek
        );
        return; // Keluar dari fungsi jika ada error
      }
    }
    Get.snackbar(
      'Success',
      'Profile saved successfully!',
      duration: const Duration(seconds: 1), // Durasi notifikasi lebih pendek
    );
  }

  Future<void> deleteProfileImage() async {
    profileImage.value = null; // Set gambar profil menjadi null
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('profileImagePath'); // Hapus path gambar dari SharedPreferences
    Get.snackbar('Success', 'Profile image deleted successfully!');
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    // Muat username
    String? savedUsername = prefs.getString('username');
    if (savedUsername != null) {
      username.value = savedUsername;
      usernameController.text = savedUsername;
    }
    // Muat foto profil
    String? profileImagePath = prefs.getString('profileImagePath');
    if (profileImagePath != null) {
      profileImage.value = File(profileImagePath);
    }
  }

  // Metode logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username'); // Hapus username dari SharedPreferences
    await prefs.remove(
        'profileImagePath'); // Hapus gambar profil dari SharedPreferences
    profileImage.value = null; // Set gambar profil menjadi null
    username.value = ''; // Reset username

    Get.offAllNamed('/login'); // Ganti dengan rute halaman login Anda
    Get.snackbar('Success', 'You have logged out successfully!');
  }
}
