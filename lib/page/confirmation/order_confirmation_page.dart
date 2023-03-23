import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_call.dart';
import '../../api/pdf_api.dart';
import '../../api/pdf_invoice_api.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../model/codes/code.dart';
import '../../model/order/place_order_data.dart';
import '../../utils/constant.dart';
import 'package:http/http.dart' as http;

import '../account/account_controller.dart';
import '../wallet/wallet_controller.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';
import 'order_controller.dart';

class ConfirmationPage extends StatefulWidget {
  final PlaceData placeData;
  final String playerId;
  final String playerName;
  final String from;
  const ConfirmationPage({Key? key, required this.placeData,required this.playerId,required this.playerName,required this.from}) : super(key: key);

  @override
  State<ConfirmationPage> createState() => _CheekOutPageState();
}

class _CheekOutPageState extends State<ConfirmationPage> {
  int toggle = 0;
  AnimationController? _con;
  String symbol = "";
  String role = "";
  final accountController = Get.put(AccountController());
  var codeList=<Codes>[];
  @override
  void initState() {
    super.initState();
    getSymbol();


  }

  getSymbol() async {
    symbol = await getStringPrefs(SYMBOL);
    role = await getStringPrefs(ROLE);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(widget.from=="cart"){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }else{
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }

        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light),
        child: Scaffold(
          backgroundColor: backgroundColor,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: SvgPicture.asset("assets/images/arrow_back.svg"),
                          splashRadius: 20,
                          iconSize: 30,
                          onPressed: () {
                            if(widget.from=="cart"){
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }else{
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        Text(
                          "orderConfirmation",
                          style: productPageTitleTextStyle,
                        ).tr(),
                        SizedBox(
                          height: 20,
                          width: 50,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Expanded(
                        child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                            child: Text(
                          "thankYouFornyourOrder",
                          textAlign: TextAlign.center,
                          style: confirmPageHeadingTextStyle,
                        ).tr()),
                        SizedBox(
                          height: 66,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "store",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              widget.placeData.user!.store == null
                                  ? "divisionStore"
                                  : widget.placeData.user!.store!,
                              style: cartPageContactTextStyle,
                            ).tr()
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "orderNumber",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              widget.placeData.no!,
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "orderDate",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              "${orderTime(widget.placeData.createdAt!)}",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Type:",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              "${widget.placeData.paymentType}",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "phoneNumber",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              widget.placeData.phone == ""||widget.placeData.phone==null
                                  ? "Phone not available"
                                  : "0${widget.placeData.phone}",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),

                        Visibility(
                            visible: widget.playerId.isNotEmpty,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 28,
                            ),
                            Divider(
                              thickness: 1,
                              color: Color(0xFFB2BAFF),
                            ),
                            SizedBox(
                              height: 21,
                            ),
                            Text(
                              "playerInfo",
                              style: cartPageHeadingTextStyle,
                            ).tr(),
                            SizedBox(
                              height: 11,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("playerId",style: detailPageHeadingTextStyle,).tr(),
                                Text("${widget.playerId}",style: cartPageContactTextStyle,)
                              ],
                            ),
                            widget.playerName.isNotEmpty?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("playerName",style: detailPageHeadingTextStyle,).tr(),
                                Text("${widget.playerName}",style: cartPageContactTextStyle,)
                              ],
                            ):SizedBox()

                          ],
                        )),
                        Visibility(
                          visible:widget.placeData.codes == null?false:true ,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 28,
                            ),
                            Divider(
                              thickness: 1,
                              color: Color(0xFFB2BAFF),
                            ),
                            SizedBox(
                              height: 21,
                            ),
                            Text(
                              "yourCode",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            widget.placeData.codes==null?SizedBox():Column(
                                children: widget.placeData.codes!
                                    .map((e) => ListTile(
                                  title: Text(
                                    e.no!,
                                    style: cartPageContactTextStyle,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  trailing: Icon(Icons.copy),
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: e.no));
                                  },
                                ))
                                    .toList()),
                          ],
                        )),
                        SizedBox(
                          height: 22,
                        ),
                        Divider(
                          thickness: 1,
                          color: Color(0xFFB2BAFF),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          "orderSummery",
                          style: cartPageHeadingTextStyle,
                        ).tr(),
                        SizedBox(
                          height: 11,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "title",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              "${widget.placeData.product!.title}",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "qty",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              "${widget.placeData.qty}",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "price",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              "${widget.placeData.product!.customerPrice!} $symbol",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          thickness: 1,
                          color: Color(0xFFB2BAFF),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "subtotal",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              "${countJustTotal(widget.placeData)} $symbol",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "discount",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              widget.placeData.coupon != null
                                  ? "${(countJustDiscount(widget.placeData))} $symbol"
                                  : "0.0 $symbol",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ),
                        role=="general"?SizedBox(
                          height: 3,
                        ):SizedBox(),
                        role=="general"?Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "deliveryCharge",
                              style: detailPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              "${(widget.placeData.deliveryCharge!)}.0 $symbol",
                              style: cartPageContactTextStyle,
                            )
                          ],
                        ):SizedBox(),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "total",
                              style: cartPageHeadingTextStyle,
                            ).tr(),
                            Text(
                              "${countJustFinalTotal(widget.placeData)} $symbol",
                              style: cartPageHeadingTextStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF15375A),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              var status = await Permission.storage.status;
                              if (!status.isGranted) {
                                await Permission.storage.request();
                              }
                              LoadingProgress.start(context);
                              try {
                                getProfileData().then((value) async {
                                  await saveString(COUNTRY,
                                      value.data!.country!.name ?? "country");
                                  await saveString(
                                      CITY, value.data!.city!.name ?? "city");
                                });

                                final pdfFile = await PdfInvoiceApi.generate(
                                    widget.placeData.createdAt!,
                                    widget.placeData.product!.title!,
                                    widget.placeData.product!.customerPrice!,
                                    widget.placeData.phone??"",
                                    countJustTotal(widget.placeData).toString(),
                                    widget.placeData.codes ?? codeList,
                                    widget.placeData.coupon != null
                                        ? "${countJustDiscount(widget.placeData)}"
                                        : "0.0",
                                    "${countJustFinalTotal(widget.placeData)}",
                                    widget.placeData.qty!,
                                    widget.placeData.user!.store ??
                                        "Division Store",
                                  widget.placeData.deliveryCharge!
                                );
                                LoadingProgress.stop(context);
                                await PdfApi.openFile(pdfFile,context);
                              }catch(e){
                                showToast(e.toString());
                                LoadingProgress.stop(context);
                              }
                            },
                            child: Text(
                              "print",
                              style: detailPageButtonTextStyle,
                            ).tr(),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    ))
                  ],
                ),
              ),
              Positioned(
                  right: 20,
                  top: MediaQuery.of(context).padding.top,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: role != 'general'
                      ? BalanceWidget(
                          controller: accountController,
                        )
                      : SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
