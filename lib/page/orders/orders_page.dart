import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../api/pdf_api.dart';
import '../../api/pdf_order_api.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../../utils/pdf_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../utils/pdf_helper1.dart';
import '../account/account_controller.dart';
import '../order_detail/order_details_page.dart';
import '../sign_in/sign_in_page.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';
import 'order_controller.dart';

class OrderPage extends StatefulWidget {

  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var list = ["allOrder", "Completed", "Canceled","Pending"];
  var dropDownValue = "allOrder";
  int toggle = 0;
  var tap;
  bool isTap = false;
  bool toolTip = false;
  final controller = Get.put(OrderController());
  final accountcontroller = Get.put(AccountController());
  final internetController = Get.put(ConnectivityCheckerController());
  var formattedDate="";
  var formattedDate1="";
  String date="";
  String status="";
  String role="";
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();
  @override
  void initState() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    formattedDate1 = formatter.format(now);
   // controller.loading.value=false;
    super.initState();
    internetController.startMonitoring();
    controller.getData(true,status,date);
    getRole();
  }
  getRole()async{
    role=await getStringPrefs(ROLE);
    setState((){});
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1971, 8),
        lastDate: DateTime(2050, 8));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var formatter = DateFormat('yyyy-MM-dd');
        formattedDate = formatter.format(selectedDate);

      });
    }
  }
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate1,
        firstDate: DateTime(1971, 8),
        lastDate: DateTime(2050, 8));
    if (picked != null && picked != selectedDate1) {
      setState(() {
        selectedDate1 = picked;
        var formatter = DateFormat('yyyy-MM-dd');
        formattedDate1 = formatter.format(selectedDate1);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: 123.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF15375A).withOpacity(1),
                    Color(0xFF77CEDA).withOpacity(0)
                  ],
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RefreshIndicator(
                  onRefresh: ()async{
                    controller.getData(false,status,date);
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         IconButton(
                            icon:
                                SvgPicture.asset("assets/images/arrow_back.svg"),
                            splashRadius: 20,
                            iconSize: 30,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Text(
                            "orders",
                            style: productPageTitleTextStyle,
                          ).tr(),
                          PopupMenuButton(
                              icon: Image.asset("assets/images/upload.png"),
                              itemBuilder: (context){
                                return [
                                  PopupMenuItem(
                                    value: 1,
                                    onTap: ()async{
                                      var status = await Permission.storage.status;
                                      if (!status.isGranted) {
                                        await Permission.storage.request();
                                      }
                                      final pdfFile = await PdfOrderApi.generate(
                                          controller.order
                                      );
                                      PdfApi.openFile(pdfFile,context);
                                    },
                                    // row has two child icon and text.
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/file.png",height: 20,width: 20,),
                                        SizedBox(
                                          // sized box with width 10
                                          width: 10,
                                        ),
                                        Text("exportPdf").tr()
                                      ],
                                    ),
                                  ),
                                  // popupmenu item 2
                                  PopupMenuItem(
                                    value: 2,
                                    onTap: ()async{
                                      var status = await Permission.storage.status;
                                      if (!status.isGranted) {
                                        await Permission.storage.request();
                                      }
                                      if(role=="general"){
                                        createExcel2(controller);
                                      }else{
                                        createExcel1(controller);
                                      }
                                    },
                                    // row has two child icon and text
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/excel.png",height: 20,width: 20,),
                                        SizedBox(
                                          // sized box with width 10
                                          width: 10,
                                        ),
                                        Text("exportExcel").tr()
                                      ],
                                    ),
                                  ),
                                ];
                              })
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          GestureDetector(
                            onTap: (){
                              _selectDate(context).then((value) {
                                dropDownValue = "allOrder";
                                setState((){});
                                date="from=$formattedDate&to=$formattedDate1";
                                controller.getData(true, "", date);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFAFAFF),
                                  border: Border.all(
                                      color: Color(0xFFD9D9D9), width: 0.5)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFFD8A3DD),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "$formattedDate",
                                    style: formFieldHintStyle4,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "to",
                            style: cartPageContactTextStyle,
                          ),
                          GestureDetector(
                            onTap: (){
                              _selectDate1(context).then((value) {
                                // if(formattedDate==formattedDate1){
                                //   showToast("Please select from date");
                                //   return;
                                // }
                                dropDownValue = "allOrder";
                                setState((){});
                                date="from=$formattedDate&to=$formattedDate1";
                                controller.getData(true, "", date);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFAFAFF),
                                  border: Border.all(
                                      color: Color(0xFFD9D9D9), width: 0.5)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFFD8A3DD),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "$formattedDate1",
                                    style: formFieldHintStyle4,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: DropdownButton(
                              underline: SizedBox(),
                              icon: SvgPicture.asset(
                                  "assets/images/arrow_down.svg"),
                              value: dropDownValue,
                              items: list
                                  .map((e) => DropdownMenuItem(
                                child: Text(e,style: TextStyle(color: Colors.black),).tr(),
                                value: e,
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {

                                  dropDownValue = value as String;
                                  if(dropDownValue=="allOrder"){
                                    date="";
                                    
                                    controller.getData(true, "", "");
                                  }else{
                                    controller.getData(true, dropDownValue.toLowerCase(), "");
                                  }


                                });

                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Obx(() {
                        if (controller.loading.value == true) {
                          return Center(
                            child: SpinKitCircle(
                              size: 140,
                              color: Color(0xFF8FC7FF),
                            ),
                          );
                        }else if(accountcontroller.token.value.isEmpty){
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/login.json',
                              title: 'alert',
                              description: 'pleaseLoginFirst',
                              buttonText: "login",
                              onPressed: () {
                                Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(PageTransition(child: SignInPage(), type: PageTransitionType.fade), (route) => false);
                              },
                              status: 1,
                            ),
                          );
                        }

                        else if (internetController.isOnline.value == false) {
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/no_internet_lottie.json',
                              title: 'internetError',
                              description: 'internetNotFound',
                              buttonText: "retry",
                              onPressed: () {
                                controller.getData(true,status,date);
                              },
                              status: 1,
                            ),
                          );
                        } else if (controller.internetError.value == true) {
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/no_internet_lottie.json',
                              title: 'internetError',
                              description: 'internetNotFound',
                              buttonText: "retry",
                              onPressed: () {
                                controller.getData(
                                    true,status,date
                                );
                              },
                              status: 1,
                            ),
                          );
                        } else if (controller.serverError.value == true) {
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/failure_lottie.json',
                              title: 'serverError',
                              description: 'pleaseTryAgainLater',
                              buttonText: "retry",
                              onPressed: () {
                                controller.getData(true,status,date);
                              },
                              status: 1,
                            ),
                          );
                        } else if (controller.somethingWrong.value == true) {
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/failure_lottie.json',
                              title: 'somethingWentWrong',
                              description: 'pleaseTryAgainLater',
                              buttonText: "retry",
                              onPressed: () {
                                controller.getData(
                                    true,status,date
                                );
                              },
                              status: 1,
                            ),
                          );
                        } else if (controller.timeoutError.value == true) {
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/failure_lottie.json',
                              title: 'timeout',
                              description: 'pleaseTryAgain',
                              buttonText: "retry",
                              onPressed: () {
                                controller.getData(true,status,date);
                              },
                              status: 1,
                            ),
                          );
                        } else if (controller.loading.value == false &&
                            controller.order.isEmpty) {
                          return Column(
                            children: [
                              Center(
                                child: EmptyFailureNoInternetView(
                                  image: 'assets/lottie/empty_lottie.json',
                                  title: 'noData',
                                  description: 'noDataFound',
                                  buttonText: "retry",
                                  onPressed: () {
                                    controller.getData(true,status,date);
                                  },
                                  status: 1,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: controller.order.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //color: Color(0xFFFAFAFF),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFFFAFAFF)
                                              .withOpacity(0.2),
                                          offset: Offset(0, 0),
                                          blurRadius: 20)
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "id",
                                          style: detailPageHeadingTextStyle1,
                                        ).tr(),
                                        Text(
                                          "${controller.order[index].no}",
                                          style: cartPageContactTextStyle,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "product",
                                          style: detailPageHeadingTextStyle1,
                                        ).tr(),
                                        Text(
                                          "${controller.order[index].product!.title}",
                                          style: cartPageContactTextStyle,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "status",
                                          style: detailPageHeadingTextStyle1,
                                        ).tr(),
                                        Text(
                                          "${controller.order[index].status!.toUpperCase()}",
                                          style: cartPageContactTextStyle,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "total",
                                          style: detailPageHeadingTextStyle1,
                                        ).tr(),
                                        // Text(
                                        //   "${countJustFinalTotal9(controller.order[index],role,controller.order[index].deliveryCarge!)} ${accountcontroller.symbol.value}",
                                        //   style: cartPageContactTextStyle,
                                        // )
                                        Text(
                                          "${controller.order[index].price} ${accountcontroller.symbol.value}",
                                          style: cartPageContactTextStyle,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "action",
                                          style: detailPageHeadingTextStyle1,
                                        ).tr(),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                padding:EdgeInsets.zero
                                            ),
                                            onPressed: (){
                                              Navigator.of(context).push(
                                                  PageTransition(
                                                      child: OrderDetailPage(
                                                        id: controller
                                                            .order[index].id
                                                            .toString(),
                                                      ),
                                                      type: PageTransitionType
                                                          .rightToLeft));
                                            }, child: Text("seeMore").tr())
                                      ],
                                    ),

                                  ],
                                ),
                              );
                            }, separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 10,);
                          },);
                        }
                      }),
                      SizedBox(height: 40,)
                    ],
                  ),
                )),
            Positioned(
                right: 70,
                top: MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width*0.45,
                child:  role!='general'?BalanceWidget(controller: accountcontroller,):SizedBox()
            ),
          ],
        ),
      ),
    );
  }

}

class Employee {
  String? category;
  String? productName;
  String? codes;
  String? createdAt;
  String? productPrice;
  String? quantity;
  String? totalPrice;
  String? discount;
  String? status;

  Employee(
      this.category,
      this.productName,
      this.codes,
      this.createdAt,
      this.productPrice,
      this.quantity,
      this.totalPrice,
      this.discount,
      this.status);
}
