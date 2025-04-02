import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/login_controller.dart';

import '../../utils/routes/routes.dart';

class LoginScreen extends GetView<LoginController> {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // final controller  = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Tai khoan'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Mat khau'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value == true) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  removeFocus(context);
                  controller.handleLoginProcees(emailController.text.toString(),
                      passwordController.text.toString());
                },
                child: const Text('Đăng nhập'),
              );
            }),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.register);
              },
              child: const Text('Dang ky tai khoan moi'),
            ),
          ],
        ),
      ),
    );
  }
}

removeFocus(BuildContext context) {
  final FocusScopeNode currentScope = FocusScope.of(context);
  if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}
