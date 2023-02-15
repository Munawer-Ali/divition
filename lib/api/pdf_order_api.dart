import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:divisioniosfinal/api/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/order/order_data.dart';
import '../utils/constant.dart';

class PdfOrderApi {
  static Future<File> generate(RxList<Order> order) async {
    final pdf = Document();
    String role = await getStringPrefs(ROLE);


    final ByteData bytes = await rootBundle.load('assets/images/logo.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final headers1=[
      "Category",
      "Product Name",
      "Created At",
      "Product Price",
      "Quantity",
      "Discount",
      "Delivery Charge",
      "Total Cost",
      "Status",
      "Codes"
    ];
    final headers2=[
      "Category",
      "Product Name",
      "Created At",
      "Product Price",
      "Quantity",
      "Discount",
      "Total Cost",
      "Profit",
      "Status",
      "Codes"
    ];
    final data1=order.map((element) {
      return [
        "${element.product!.category!.title}",
        "${element.product!.title}",
        "${orderTime(element.createdAt!)}",
        role=="general"?element.product!.customerPrice:element.product!.wholesalerPrice,
        "${element.qty!}",
        "${countJustDiscountExport(element.coupon!.discount??"0.00",
            element.product!.customerPrice!,
            element.product!.wholesalerPrice!,
            element.qty!,role)}",
        "${element.deliveryCarge}",
        "${countJustFinalExport(
            element.coupon!.discount??"0.00",
            element.product!.customerPrice!,
            element.product!.wholesalerPrice!,
            element.qty!,role,element.deliveryCarge!)}",
        "${element.status}",
        "${element.codes!=null?element.codes!.map((e) => e.no!).reduce((value, element) => value+","+element):""}"

      ];

    }).toList();
    final data2=order.map((element) {
      return [
        "${element.product!.category!.title}",
        "${element.product!.title}",
        "${orderTime(element.createdAt!)}",
        role=="general"?element.product!.customerPrice:element.product!.wholesalerPrice,
        "${element.qty!}",
        "${countJustDiscountExport(element.coupon!.discount??"0.00",
            element.product!.customerPrice!,
            element.product!.wholesalerPrice!,//ff
            element.qty!,role)+element.categorizedDiscountInAmount}",
        "${countJustFinalExport(
            element.coupon!.discount??"0.00",
            element.product!.customerPrice!,
            element.product!.wholesalerPrice!,
            element.qty!,role,element.deliveryCarge!)-element.categorizedDiscountInAmount}",
        "${element.wholesaler_profit}",
        "${element.status}",
        "${element.codes!=null?element.codes!.map((e) => e.no!).reduce((value, element) => value+","+element):""}"

      ];

    }).toList();

    pdf.addPage(MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        Center(child: Image(MemoryImage(byteList), height: 100, width: 250)),
        SizedBox(height: 10),
        Center(child: Text("Order summery",style: TextStyle(fontSize: 20))),
        SizedBox(height: 20),
        Container(
            child: Table.fromTextArray(data: role=="general"?data1:data2,headers: role=="general"?headers1:headers2,
            headerStyle: TextStyle(fontWeight: FontWeight.bold),
            border: null,
            headerDecoration: BoxDecoration(
              color: PdfColors.grey300
            ),oddRowDecoration:BoxDecoration(
                    color: PdfColors.grey50
                ) )
        )
      ]));
    var datetime=DateTime.now();
    return PdfApi.saveDocument(
        name: 'Orders${datetime.day}${datetime.month}${datetime.year}.pdf', pdf: pdf);
  }




}


String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
