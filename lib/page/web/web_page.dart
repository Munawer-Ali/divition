import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:loading_progress/loading_progress.dart';
import '../../api/api_call.dart';
import '../../model/order/place_order_data.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../confirmation/order_confirmation_page.dart';


class WebPage extends StatefulWidget {
  final PlaceData placeData;
  final String playerId;
  final String playerName;
  const WebPage({Key? key, required this.placeData,required this.playerName,required this.playerId}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        useOnLoadResource: true,
        javaScriptCanOpenWindowsAutomatically: true,
        javaScriptEnabled: true
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        supportMultipleWindows: true,
        safeBrowsingEnabled: false
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  double progress = 0;
  @override
  void initState() {
    super.initState();
    print(widget.placeData.no!);
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 1.5,
              leading: IconButton(
                onPressed: (){
                  _onWill(context);
                },
                icon: Icon(Icons.arrow_back,color: Colors.black,),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text("Payment",style: TextStyle(color: Colors.black),)

          ),
          body: Builder(builder: (BuildContext context) {
            return Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(url: Uri.parse("https://divisionco.com/api/temp-orders/${widget.placeData.no!}/bop-payment")),
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url)async {

                  },
                  androidOnPermissionRequest: (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;
                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    if(url.toString().contains("https://divisionco.com/api/temp-orders/${widget.placeData.no!}/show")){
                      LoadingProgress.start(context);
                      var response=await getPaymentData(widget.placeData.no!);
                      LoadingProgress.stop(context);
                      print(response.statusCode);
                      if(response.statusCode==200){
                        var map=jsonDecode(response.body);
                        PlaceOrderData placeData=PlaceOrderData.fromJson(map);
                        Navigator.of(context).push(PageTransition(child: ConfirmationPage(placeData: placeData.data!, playerName: widget.playerName, playerId: widget.playerId, from: 'web',), type: PageTransitionType.fade));
                      }else{
                        showToast("Failed!");
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  onLoadError: (controller, url, code, message) {
                    webViewController?.loadUrl(urlRequest: URLRequest(url: url));
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {

                    });
                  },
                  onReceivedServerTrustAuthRequest: (controller, challenge) async {
                    print(challenge);
                    return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            );
          }),


        ),
        );
  }
  _onWill(BuildContext context) {
    return showDialog(
      context: context,
      builder: (cont) {
        return AlertDialog(
          title:  const Text("Alert!"),
          content:  const Text('Are you sure want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {

                Navigator.of(cont).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } ,
              child: Text('Yes',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,color: Colors.black),),
            ),
            TextButton(
              onPressed: () => Navigator.of(cont).pop(),
              child: Text('No',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,color: Colors.green),),
            ),
          ],
        );
      },
    );
  }


}
