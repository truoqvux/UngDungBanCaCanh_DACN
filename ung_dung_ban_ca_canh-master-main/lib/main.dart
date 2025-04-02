import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/system_controler.dart';
import 'utils/routes/app_routes.dart';
import 'utils/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemController controller = Get.put(SystemController());
    controller.initControllerApp() ;  
      return GetMaterialApp(
         debugShowCheckedModeBanner: false,
          initialRoute:Routes.home,
          getPages: AppPages.pages,
          title: 'Ban Ca Canh',
           theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 158, 42, 42)),
            useMaterial3: false,
          ),
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
      ) ;  
  }
}