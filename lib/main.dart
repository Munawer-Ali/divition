import 'dart:io';

import 'package:divisioniosfinal/page/splash/splash_page.dart';
import 'package:divisioniosfinal/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();

  final path = Directory(await getApplicationPath());
  if(!await path.exists()){
    path.create();
  }
  SystemChrome.setPreferredOrientations(
  [
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
  ],
  ).then((val) {
  runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context,widget){
        ScreenUtil.init(context,designSize: Size(380, 800));
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
        },
      debugShowCheckedModeBanner: false,
      title: 'Division Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.0),
      ),
      home: SplashPage(),
    );
  }
}


