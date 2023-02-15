import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart';

import '../package/page_transition/enum.dart';
import '../package/page_transition/page_transition.dart';
import '../page/pdf/pdf.dart';
import '../utils/constant.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final file = File(await getFilePath(name));
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File pdfFile,BuildContext context) async {

    Navigator.of(context,rootNavigator: true).push(PageTransition(child: PDFScreen(name: pdfFile.path.split("/").last, path: pdfFile.path,), type: PageTransitionType.fade));
    // OpenFile.open(url).then((value) async{
    //   showToast(value.message+" Downloaded");
    // });
  }
}
