import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      body: Stack(
        children: [
          // Bagian atas berwarna hijau tua
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF3C887E),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(127, 0, 0, 0),
                  blurRadius: 20.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),

          // Bagian bawah berwarna putih
          Container(
            margin: const EdgeInsets.only(top: 250),
            height: MediaQuery.of(context).size.height - 250,
            width: double.infinity,
            color: Colors.white,
          ),

          // Teks Profile dengan posisi yang dapat diatur
          Positioned(
            top:
                45, // Atur posisi top untuk menempatkan teks di atas foto profil
            left: MediaQuery.of(context).size.width / 2 -
                55, // Menghitung posisi tengah
            child: const Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Ikon Kembali di sebelah kiri
          Positioned(
            top: 45,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back(); // Kembali ke halaman sebelumnya
              },
            ),
          ),
          // Ikon Logout di sebelah kanan
          Positioned(
            top: 45,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // Tampilkan dialog konfirmasi logout
                Get.defaultDialog(
                  title: 'Logout Confirmation',
                  middleText: 'Are you sure you want to log out?',
                  confirm: TextButton(
                    onPressed: () {
                      controller.logout(); // Panggil metode logout jika ya
                      Get.back(); // Tutup dialog
                    },
                    child: const Text('Yes'),
                  ),
                  cancel: TextButton(
                    onPressed: () {
                      Get.back(); // Tutup dialog jika tidak
                    },
                    child: const Text('No'),
                  ),
                );
              },
            ),
          ),
          // Foto profil dengan ikon
          Positioned(
            top:
                100, // Atur posisi top untuk menempatkan foto profil di bawah teks
            left: MediaQuery.of(context).size.width / 2 - 80,
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    child: Wrap(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Gallery'),
                          onTap: () {
                            controller.pickImageFromGallery();
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera'),
                          onTap: () {
                            controller.pickImageFromCamera();
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                          onTap: () async {
                            await controller.deleteProfileImage();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Obx(
                () => Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(127, 0, 0, 0),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: controller.profileImage.value != null
                            ? FileImage(controller.profileImage.value!)
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                      ),
                      // Hanya tampilkan ikon person jika tidak ada gambar profil
                      if (controller.profileImage.value == null) ...[
                        const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bagian username
          Positioned(
            top: 270,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit Username'),
                      content: TextFormField(
                        controller: controller.usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan username baru',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back(); // Tutup dialog jika dibatalkan
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.saveProfile();
                            Get.back(); // Tutup dialog
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                },
                child: Obx(() {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3C887E), // Warna latar belakang
                      borderRadius:
                          BorderRadius.circular(20), // Sudut melengkung
                    ),
                    child: Text(
                      controller.username.value.isNotEmpty
                          ? controller.username.value
                          : 'Username',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Warna teks
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            top: 370,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Riwayat Kesehatan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C887E),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 150,
                  height: 4, //ketebalan garis
                  color: const Color(0xFF3C887E),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}
