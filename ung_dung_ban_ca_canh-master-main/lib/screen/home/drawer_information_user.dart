import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';

class DrawerInformationUser extends StatelessWidget {
  DrawerInformationUser({super.key});
  final LoginController loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    bool isLogined = loginController.isLoginSuccess.value;
    return isLogined
        ? DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 112, 57, 57),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar (Ảnh đại diện người dùng)
                CircleAvatar(
                  radius: 30,
                  backgroundImage: const NetworkImage(
                      'https://as2.ftcdn.net/v2/jpg/03/49/49/79/1000_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.jpg'), // Thay bằng URL ảnh đại diện thực tế
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 16),
                // Thông tin người dùng (Tên và username)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "#${loginController.usernameAbc.value}", // Tên người đăng nhập (Thay thế bằng dữ liệu thực tế)
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      loginController
                          .emailUser.value, // Tên người dùng (Username)
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 112, 57, 57),
            ),
            child: Center(
              child: Text(
                'Vui lòng đăng nhập',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          );
  }
}
