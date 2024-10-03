import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    // Simpan username
    if (usernameController.text.isNotEmpty) {
      username.value = usernameController.text;
      await prefs.setString('username', username.value);
    }
    // Simpan foto profil
    if (profileImage.value != null) {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = profileImage.value!.path.split('/').last;
        final savedImage = await profileImage.value!.copy('${appDir.path}/$fileName');
        await prefs.setString('profileImagePath', savedImage.path);
      } catch (e) {
        Get.snackbar('Error', 'Failed to save profile image: $e');
      }
    }
    Get.snackbar('Success', 'Profile saved successfully!');
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
}
