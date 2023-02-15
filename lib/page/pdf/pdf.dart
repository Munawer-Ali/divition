import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';



class PDFScreen extends StatefulWidget {
  final String? path;
  final String? name;

 const PDFScreen({Key? key,required this.path,required this.name}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  int? totalPage=0;
  String errorMessage = '';


  @override
  void initState() {
    super.initState();

    super.initState();
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.grey.shade300,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        },icon: Icon(Icons.arrow_back,color: Colors.black,),),
        title: Text(
          "${widget.name}",style: TextStyle(color: Colors.black),
        ),

      ),
      body:  Stack(
                children: <Widget>[
                  PDFView(
                    filePath: widget.path,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: false,
                    pageFling: true,
                    pageSnap: true,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation: false,
                    onRender: (_pages) {
                      setState(() {
                        pages = _pages;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      setState(() {
                        errorMessage = '$page: ${error.toString()}';
                      });
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                    },
                    onLinkHandler: (String? uri) {
                    },
                    onPageChanged: (int? page, int? total) async {

                    },
                  ),
                  errorMessage.isEmpty
                      ? !isReady
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : Container()
                      : Center(
                    child: Text(errorMessage),
                  )
                ],
      )
    );









  }


}