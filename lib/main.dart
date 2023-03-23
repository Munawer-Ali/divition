import 'dart:io';

import 'package:divisioniosfinal/page/splash/splash_page.dart';
import 'package:divisioniosfinal/utils/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  await EasyLocalization.ensureInitialized();
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
  runApp(EasyLocalization(
    supportedLocales: Config.languages,
    path: 'assets/translations',
    fallbackLocale: Locale(Config.defaultLanguage),
    child: MyApp(),
  ),);
  });
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    SavedLanguage();
  }

  Future<void> SavedLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String Language = preferences.getString("Language") == null ?"null":preferences.getString("Language").toString();
    print(Language);
    print("Languagechnage");
    if(Language.toString() == "null"){
      context.setLocale(Locale("ar"));
    }else{
      context.setLocale(Locale(Language));
    }
    Get.updateLocale(context.locale);

  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
        textTheme:  TextTheme(headline2: TextStyle(color: Colors.black)),
      ),
      home: SplashPage(),
    );
  }
}

class Config{
  static String defaultLanguage = "ar";
  static List<Locale> languages = [
    Locale('ar'),
    Locale('en'),
  ];
}
