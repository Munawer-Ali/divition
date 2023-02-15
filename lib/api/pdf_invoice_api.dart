import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:divisioniosfinal/api/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../model/codes/code.dart';
import '../model/order/order_detail_data.dart';
import '../utils/constant.dart';

class PdfInvoiceApi {
  static Future<File> generate(String time, String pName, String price,
      String phone, String total,List<Codes> code,String discount,String subtotal,String quantity,String storeName,String deliveryCharge) async {
    final pdf = Document();
    String symbol = await getStringPrefs(CURENCYNAME);
    String country = await getStringPrefs(COUNTRY);
    String city = await getStringPrefs(CITY);
    String address = "$country, $city";
    String role=await getStringPrefs(ROLE);
    final ByteData bytes =
        await rootBundle.load('assets/images/logo_black.png');
    final ByteData font =
    await rootBundle.load('assets/fonts/fake_receipt.ttf');
    final ByteData cfont =
    await rootBundle.load('assets/fonts/hydrogen.ttf');
    final ByteData hfont =
    await rootBundle.load('assets/fonts/DIN Next LT Arabic Light.ttf');
    final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat(500, 1000, marginAll: 100),
      build: (context) => [
        buildHeader(byteList, address, time, pName, price, phone, symbol, total,code,font,cfont,discount,subtotal,quantity,storeName,deliveryCharge,role,hfont),

      ],
    ));
    var datetime=DateTime.now();
    var name=role=="general"?"Customers${datetime.day}${datetime.month}${datetime.year}.pdf":"Customers${datetime.day}${datetime.month}${datetime.year}.pdf";
    //var name=role=="general"?"Customers${datetime.day}${datetime.month}${datetime.year}.pdf":"Wholesalers${datetime.day}${datetime.month}${datetime.year}.pdf";
    return PdfApi.saveDocument(
        name: name, pdf: pdf);
  }

  static Widget buildHeader(Uint8List byteList, String address, String time,
      String pName, String price, String phone, String symbol, String total,List<Codes> code,ByteData font,ByteData cfont,String discount,String suntotal,String quantity,
      String storeName,String deliveryCharge,String role,ByteData gfont) {
    
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Center(child: Image(MemoryImage(byteList), height: 100, width: 250)),
      SizedBox(height: 10),
      Center(
        child: Text("CASH RECEIPT", style: TextStyle(fontSize: 30,font: Font.ttf(font),color: PdfColor.fromHex("#262324"))),
      ),
      SizedBox(height: 10),
      Center(
        child: Text("Address: $address", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Store Name: ", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
          Text(storeName, style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
        ]
      ),

      SizedBox(height: 5),

      Row(
        children: [
          for (int i = 0; i < 35; i++)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: PdfColor.fromHex("#989898"),
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
        ],
      ),
      SizedBox(height: 5),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Date:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))), Text("${orderTime(time)}", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324")))]),
      SizedBox(height: 5),
      Row(
        children: [
          for (int i = 0; i < 35; i++)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: PdfColor.fromHex("#989898"),
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
        ],
      ),
      SizedBox(height: 5),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Title:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))), Text("$pName", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324")))]),
      SizedBox(height: 5),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Price:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))), Text("$quantity X $price $symbol", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324")))]),
      SizedBox(height: 5),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Phone Number:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))), Text("0$phone", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324")))]),

      code.isNotEmpty?SizedBox(height: 5):SizedBox(),

      code.isNotEmpty?Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text("Your Codes:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
          Text("")
        ]
      ):SizedBox(),
      code.isNotEmpty?Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:List.generate(code.length, (index) => Text(code[index].no!, style: TextStyle(fontSize: 16,color: PdfColor.fromHex("#262324"))))
      ):SizedBox(),


      SizedBox(height: 5),


      Row(
        children: [
          for (int i = 0; i < 35; i++)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: PdfColor.fromHex("#989898"),
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
        ],
      ),
      SizedBox(height: 10),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Subtotal:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))), Row(
              children: [
                Text("$total", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
                SizedBox(width: 5),
                Text("$symbol", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
              ]
          )]),
      SizedBox(height: 10),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Discount:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))), Row(
              children: [
                Text("$discount", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
                SizedBox(width: 5),
                Text("$symbol", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
              ]
          )]),
      role=="general"?SizedBox(height: 10):SizedBox(),
      role=="general"?Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Delivery Charge:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))), Row(
              children: [
                Text("$deliveryCharge.0", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
                SizedBox(width: 5),
                Text("$symbol", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
              ]
          )]):SizedBox(),
      SizedBox(height: 10),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Total:", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))), Row(
            children: [
              Text("$suntotal", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
              SizedBox(width: 5),
              Text("$symbol", style: TextStyle(fontSize: 16,font: Font.ttf(cfont),color: PdfColor.fromHex("#262324"))),
            ]
          )]),
      SizedBox(height: 15),
      Center(child: Text("THANK YOU!", style: TextStyle(fontSize: 30,font: Font.ttf(font),color: PdfColor.fromHex("#262324"))))
    ]);
  }

}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

