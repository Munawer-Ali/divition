import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';

import '../page/orders/order_controller.dart';
import 'constant.dart';

createExcel1(var controller) async{
  String role=await getStringPrefs(ROLE);
  var excel = Excel.createExcel();
  CellStyle cellStyle = CellStyle(
      italic: false,
      fontSize: 12,
      horizontalAlign: HorizontalAlign.Right,
      textWrapping: TextWrapping.WrapText
  );
  final Sheet sheet = excel[excel.getDefaultSheet()!];

  var cel0=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
  cel0.value = "Category";
  cel0.cellStyle = cellStyle;

  var cel1=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
  cel1.value = "Product Name";
  cel1.cellStyle = cellStyle;

  var cel2=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
  cel2.value = "Created At";
  cel2.cellStyle = cellStyle;

  var cel3=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
  cel3.value = "Product Price";
  cel3.cellStyle = cellStyle;

  var cel4=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0));
  cel4.value = "Quantity";
  cel4.cellStyle = cellStyle;

  var cel5=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0));
  cel5.value = "Discount";
  cel5.cellStyle = cellStyle;


  var cel7=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0));
  cel7.value = "Total Cost";
  cel7.cellStyle = cellStyle;

  var cel8=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0));
  cel8.value = "Profit";
  cel8.cellStyle = cellStyle;

  var cel9=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0));
  cel9.value = "Status";
  cel9.cellStyle = cellStyle;

  var cel10=sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0));
  cel10.value = "Codes";
  cel10.cellStyle = cellStyle;


  for (var row = 1; row <= controller.order.length; row++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = controller.order[row-1].product!.category!.title;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = controller.order[row-1].product!.title;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = orderTime(controller.order[row-1].createdAt!);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = role=="general"?controller.order[row-1].product!.customerPrice:controller.order[row-1].product!.wholesalerPrice;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = controller.order[row-1].qty!;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = (countJustDiscountExport(controller.order[row-1].coupon!.discount??"0.00",
        controller.order[row-1].product!.customerPrice!,
        controller.order[row-1].product!.wholesalerPrice!,
        controller.order[row-1].qty!,role)+controller.order[row-1].categorizedDiscountInAmount!).toString();
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = (countJustFinalExport(
        controller.order[row-1].coupon!.discount??"0.00",
        controller.order[row-1].product!.customerPrice!,
        controller.order[row-1].product!.wholesalerPrice!,
        controller.order[row-1].qty!,role,controller.order[row-1].deliveryCarge!)-controller.order[row-1].categorizedDiscountInAmount!).toString();
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row)).value = controller.order[row-1].wholesaler_profit;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row)).value = controller.order[row-1].status;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row)).value = controller.order[row-1].codes!=null?controller.order[row-1].codes!.map((e) => e.no!).reduce((value, element) => value+","+element):"";

  }
  var datetime=DateTime.now();
  String outputFile = await getFilePath('Orders${datetime.day}${datetime.month}${datetime.year}.xlsx');

  List<int>? fileBytes = excel.save();
  if (fileBytes != null) {
    File(join(outputFile))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }

  await Future.delayed(Duration(milliseconds: 50));
  OpenFilex.open(outputFile).then((value)async {

    showToast(value.message+"");
  });
}

String getRandString(int len1) {
  final random = Random.secure();
  final len = random.nextInt(len1);
  final values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}