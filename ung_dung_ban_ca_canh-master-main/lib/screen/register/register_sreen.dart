import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/register_controller.dart';
import 'package:ung_dung_ban_ca_canh/screen/login/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find<RegisterController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            if(controller.isPostedRegister.value)
            {
              Get.back();
            }
            return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                onChanged: (value) {
                  controller.email.value = value;
                },
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: usernameController,
                 onChanged: (value) {
                  controller.username.value = value;
                },
                decoration: const InputDecoration(labelText: 'Tai khoan'),
              ),
              TextField(
                controller: passwordController,
                 onChanged: (value) {
                  controller.password.value = value;
                },
                decoration: const InputDecoration(labelText: 'Mat khau'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Xử lý logic đăng ký
                  // print('Registered with: ${emailController.text}');
                  removeFocus(context);
                  controller.handleLoginProcees() ;
                },
                child: const Text('Dang ky'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ); 
          }          
        ),
      ),
    );
  }
}
