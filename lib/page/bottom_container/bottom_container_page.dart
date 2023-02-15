

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/api_call.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../account/account_settings_page.dart';
import '../confirmation/order_controller.dart';
import '../home/home_controller.dart';
import '../home/home_page.dart';
import '../menu/menu_page.dart';
import '../notification/notification_controller.dart';
import '../notification/notification_page.dart';
import '../orders/my_orders_page.dart';
import '../orders/order_controller.dart';
import '../orders/order_controller1.dart';
import '../wallet/wallet_controller.dart';
class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
class BottomContainerPage extends StatefulWidget {
  int index = 0;
  String predefinePage = "page1";
   BottomContainerPage({Key? key,required this.index,required this.predefinePage}) : super(key: key);

  @override
  State<BottomContainerPage> createState() => _BottomContainerPageState();
}

class _BottomContainerPageState extends State<BottomContainerPage> {
  String _currentPage = "page1";
  int selected_index = 0;
  bool fist=true;
  final accountController=Get.put(AccountController());
  final walletController=Get.put(WalletController());
  final notiController=Get.put(NotificationController());
  final orderController=Get.put(OrderController());
  final orderController1=Get.put(OrderController1());
  final orderDetailController=Get.put(OrderDetailController());

  List<String> pageKeys = ["page1", "page2", "page3", "page4","page5"];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "page1": GlobalKey<NavigatorState>(),
    "page2": GlobalKey<NavigatorState>(),
    "page3": GlobalKey<NavigatorState>(),
    "page4": GlobalKey<NavigatorState>(),
    "page5": GlobalKey<NavigatorState>(),
  };
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'division',
      'Division App',
      description: "Hi This is description",
      importance: Importance.high,
      playSound: true
  );
  DateTime pre_backpress = DateTime.now();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();
  String? selectedNotificationPayload;
  var pageStack=[];
  final homeController=Get.put(HomeController());
  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        pageStack.add(_currentPage);
        selected_index = index;
      });
    }
  }


  String device_token="";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initFirebase() async {

    device_token = (await _firebaseMessaging.getToken())!;
    print(device_token);
    await saveString(DEVICETOKEN, device_token);
    await updateDeviceToken();


  }
  @override
  void initState(){
    super.initState();
    initFirebase();

    if(Platform.isAndroid){
      setNotificationPlagin();
    }else{
      initialize();
      _requestPermissions();
      _configureDidReceiveLocalNotificationSubject();
      _configureSelectNotificationSubject();
    }
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async{

      if(message!=null){

        if(Platform.isAndroid){
          final NotificationDetails notificationDetails=NotificationDetails(android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.high,
              icon: "@mipmap/ic_launcher"
          )
          );
          notiController.getData(false);
          String msg=Bidi.stripHtmlIfNeeded(message.data['message']);
          await flutterLocalNotificationsPlugin.show(1,"New notification from Division", msg, notificationDetails,payload: "");
        }else{
          notiController.getData(false);
          String msg=Bidi.stripHtmlIfNeeded(message.data['message']);
          _showNotification(1, "New notification from Division", "$msg", "");
        }


      }

    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.data);
      if(message.data['object']=="notification"){
        String msg=Bidi.stripHtmlIfNeeded(message.data['message']);
        notiController.getData(false);
         if(Platform.isAndroid){
           final NotificationDetails notificationDetails=NotificationDetails(android: AndroidNotificationDetails(
               channel.id,
               channel.name,
               importance: Importance.high,
               icon: "@mipmap/ic_launcher"
           )
           );
           await flutterLocalNotificationsPlugin.show(1,"New notification from Division", msg, notificationDetails,payload: "");
         }else{
           _showNotification(1, "New notification from Division", "$msg", "");
         }
         return;


      }
      if(message.data['object']=="order"){
        orderController.getData(false, "", "");
        orderController1.getData(false, "", "");
        walletController.getData(false);
        accountController.getData(false);
        return;
      }
      if(message.data['object']=="category"){
        homeController.getData(false);
      }
      else{
      walletController.getData(false);
      accountController.getData(false);
      }

    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        setState(() {
          selected_index = 2;
          _currentPage = "page3";
        });
      }
    });
  }


  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  void setNotificationPlagin()async{
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true
    );
  }
  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }
  void _configureSelectNotificationSubject() async{
    selectNotificationSubject.stream.listen((String? payload) async {
      if (payload != null) {

      }
    });
  }
  Future<void> _showNotification(int id,String title,String body,String payload) async {

    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = const NotificationDetails(iOS: iOSPlatformChannelSpecifics,);
    await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload
    );
  }
  void initialize() async{

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });
    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          selectedNotificationPayload = payload;
          selectNotificationSubject.add(payload);
        });



  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "page1") {
            _selectTab("page1", 0);
            return false;
          } else {
            if (cantExit) {
              showToast("Press Back button again to Exit");
              return false;
            } else {
              return true;
            }
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),
        child: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: false,
          body: Stack(children: <Widget>[
            _buildOffstageNavigator("page1"),
            _buildOffstageNavigator("page2"),
            _buildOffstageNavigator("page3"),
            _buildOffstageNavigator("page4"),
            _buildOffstageNavigator("page5"),
          ]),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton:FloatingActionButton(
              backgroundColor: Color(0xFF15375A),
              onPressed: (){
                selected_index=4;
                _selectTab(pageKeys[selected_index], selected_index);
                fist=false;
                setState((){});

                //   if(fist==true){
                //     selected_index=4;
                //     _selectTab(pageKeys[selected_index], selected_index);
                //     fist=false;
                //     setState((){});
                //   }else{
                //     fist=true;
                //     var lastPage=pageStack[pageStack.length-2];
                //     var ind=pageKeys.indexWhere((element) => element==lastPage);
                //     _selectTab(lastPage, ind);
                //     setState((){});
                //
                // }
              },
              child: SvgPicture.asset("assets/images/menu.svg"),
            ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8,
            clipBehavior: Clip.antiAlias,
            color: Color(0xFF15375A),
            child: SizedBox(

              // decoration: BoxDecoration(
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.06),
              //       offset: Offset(0,-5),
              //       blurRadius: 20
              //     )
              //   ],
              //   color: Colors.white
              // ),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            selected_index=0;
                            fist=true;
                            _selectTab(pageKeys[selected_index], selected_index);
                          });
                        },
                        icon: SvgPicture.asset("assets/images/home.svg",color: selected_index==0?Colors.white:Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            selected_index=1;
                            fist=true;
                            _selectTab(pageKeys[selected_index], selected_index);
                          });
                        },
                        icon: SvgPicture.asset("assets/images/order.svg",color: selected_index==1?Colors.white:Colors.white.withOpacity(0.5),),
                      ),
                    ),
                  ),
                  Expanded(child: Text("")),
                  Expanded(
                    child: Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            selected_index=2;
                            fist=true;
                            _selectTab(pageKeys[selected_index], selected_index);
                          });
                        },
                        icon: SvgPicture.asset("assets/images/notification.svg",color: selected_index==2?Colors.white:Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selected_index=3;
                            _selectTab(pageKeys[selected_index], selected_index);
                          });
                        },
                        splashRadius: 20,
                        icon: SvgPicture.asset("assets/images/account.svg",color: selected_index==3?Colors.white:Colors.white.withOpacity(0.5),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }

  void setNotificationPage() {
    setState((){
      selected_index = widget.index;
      _currentPage = widget.predefinePage;
    });
  }
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});

  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  late Widget child;

  @override
  Widget build(BuildContext context) {
    if (tabItem == "page1")
      child = HomePage();
    else if (tabItem == "page2")
      child = MyOrderPage();
    else if (tabItem == "page3")
      child = NotificationPage();
    else if (tabItem == "page4")
      child = AccountSettingsPage(home: false);
    else if (tabItem == "page5")
      child = MenuPage();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
