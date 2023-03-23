import 'dart:convert';



import 'package:cached_network_image/cached_network_image.dart';
import 'package:divisioniosfinal/model/search/search_data.dart';
import 'package:divisioniosfinal/page/product/product_list_controller.dart';
import 'package:easy_localization/easy_localization.dart';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:loading_progress/loading_progress.dart';

import '../../api/api_call.dart';
import '../../connectivity/connectivity_checker.dart';
import '../../model/cart_model/cart_model_item.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../check_out/cart_controller.dart';
import '../check_out/check_out_page.dart';
import '../detail/detail_page.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';

class ProductListPage extends StatefulWidget {
  String slag;
  String type;
   ProductListPage({Key? key,required this.slag,required this.type}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>  {
  final controller=Get.put(ProductListController());
  final accountcontroller=Get.put(AccountController());
  final internetController=Get.put(ConnectivityCheckerController());
  int toggle=0;
  var tap;
  bool isTap=false;
  bool toolTip=false;
  int initial_count = 1;
  double height=120;
  double width=100;
  bool itemClickable=true;
  bool loading=false;
  final cartController=Get.put(CartController());
  final playerIdController=TextEditingController();
  var playerName="";
  bool buyNowEnabled=false;
  bool enabled=true;
  bool descriptionEnabled=true;
  var role="";
  String symbol="";
  @override
  void initState() {

    super.initState();
    print(widget.slag);
    internetController.startMonitoring();
    controller.getData(true, widget.slag);
    getRole();
  }
  getRole()async{
    role=await getStringPrefs(ROLE);
    symbol=await getStringPrefs(SYMBOL);
    if(symbol.isEmpty){
      symbol="₪";
    }
    setState((){});
  }
  @override
  void dispose(){
    super.dispose();
    Get.delete<ProductListController>();
  }
  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body:  Stack(
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
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(

                        icon: SvgPicture.asset("assets/images/arrow_back.svg"),
                        splashRadius: 20,
                        onPressed: (){
                          Navigator.of(context).pop();
                        },),
                      Text("productList",style: productPageTitleTextStyle,).tr(),
                      SizedBox(height: 20,width: 50,)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Expanded(child: RefreshIndicator(
                  onRefresh: ()async{
                    controller.getData(false, widget.slag);
                  },
                  child: Obx((){
                    if(controller.loading.value==true){

                      return Center(
                        child: SpinKitCircle(
                          size: 140,
                          color: Color(0xFF8FC7FF),
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
                            controller.getData(true,widget.slag);
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
                            controller.getData(true,widget.slag);
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
                            controller.getData(true,widget.slag);
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
                            controller.getData(true,widget.slag);
                          },
                          status: 1,
                        ),
                      );
                    }else  if(controller.timeoutError.value==true){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'timeout',
                          description: 'pleaseTryAgain',
                          buttonText: "retry",
                          onPressed: () {
                            controller.getData(true,widget.slag);
                          },
                          status: 1,
                        ),
                      );
                    }
                   else  if(controller.loading.value==false&&controller.categoryList.isEmpty){
                     return Center(
                       child: EmptyFailureNoInternetView(
                         image: 'assets/lottie/empty_lottie.json',
                         title: 'noData',
                         description: 'noDataFound',
                         buttonText: "retry",
                         onPressed: () {
                           controller.getData(true,widget.slag);
                         },
                         status: 1,
                       ),
                     );
                   }
                   else{
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.categoryList.length,
                          itemBuilder: (context,index){

                            return GestureDetector(


                                onTap: itemClickable==true?(){
                                  playerName="";
                                  toolTip=false;
                                  playerIdController.text="";
                                  setState((){
                                    height=130;
                                    width=110;
                                    buyNowEnabled=false;
                                    isTap=true;
                                    if(isTap==true){
                                      tap=index;
                                    }
                                    //else{
                                    //   tap=null;
                                    // }

                                  });
                                }:null,
                                child: tap==index?Container(
                                  margin: EdgeInsets.only(left: 15,right: 14,bottom: (index==controller.categoryList.length-1)?30:10),
                                  padding: const EdgeInsets.only(left: 5,top: 11,bottom: 11,right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF77CEDA).withOpacity(0.2)
                                        )
                                      ]
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            child: CachedNetworkImage(
                                              imageUrl: "$imageBaseUrl/${controller.categoryList[index].image}",
                                              height: height,
                                              width: width,
                                              fit: BoxFit.fill,

                                              imageBuilder: (context, imageProvider) =>
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,),
                                                    ),
                                                  ),
                                              placeholder: (context, url) => Center(
                                                child: Container(
                                                  width: height,
                                                  height: width,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Color(0xFFE8E8E8)
                                                  ),
                                                  child: Icon(Icons.image,size: 60,),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.image,size: 100,),
                                            ),),
                                          const SizedBox(width: 12,),
                                          Expanded(child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(children: [
                                                      Text("marketPrice",style:productListPageTitleStyle,).tr(),
                                                      SizedBox(width: 5,),
                                                      Text("${controller.categoryList[index].customerPrice} $symbol",style:productListPriceStyle,),
                                                    ],),
                                                    // child: Text.rich(TextSpan(
                                                    //   locale: context.locale,
                                                    //   text: "marketPrice",
                                                    //   style:productListPageTitleStyle,
                                                    //   children: [
                                                    //     TextSpan(
                                                    //       text: "${controller.categoryList[index].customerPrice} $symbol",
                                                    //       style: productListPriceStyle,
                                                    //       locale: context.locale
                                                    //     )
                                                    //   ]
                                                    // )),
                                                  ),
                                                  role!='general'?GestureDetector(
                                                    onTap: (){
                                                      if(accountcontroller.token.isEmpty){
                                                        return;
                                                      }
                                                      setState((){
                                                        toolTip=!toolTip;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color: Color(0xFF262324)
                                                      ),
                                                      child: Center(child: Text(symbol.isNotEmpty?symbol:"₪",style: TextStyle(color: Colors.white),)),
                                                    ),
                                                  ):const SizedBox()
                                                ],
                                              ),
                                              SizedBox(height: 2,),
                                              controller.categoryList[index].category!.type=="top-up"||
                                                  controller.categoryList[index].category!.type=="top-up-jawaker"||
                                                  controller.categoryList[index].category!.type=="top-up-no-api"?SizedBox(
                                                height: 40,
                                                width: MediaQuery.of(context).size.width*0.35,
                                                child: TextFormField(
                                                  style: TextStyle(fontSize: 14,height: 1.5),
                                                  controller: playerIdController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: context.locale.toString().contains("en")?"Player ID":"رقم اللاعب",
                                                      hintStyle: productListPageHintStyle,
                                                      contentPadding: EdgeInsets.all(5),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: BorderSide(color: Color(0xFFDCDCDC))
                                                      )
                                                  ),
                                                ),
                                              ):SizedBox(height: 40,),
                                              Text(" $playerName",style: TextStyle(fontSize: 14),),
                                              SizedBox(height: 6,),
                                              Row(
                                                children: [
                                                  controller.categoryList[index].category!.type=="top-up"||
                                                      controller.categoryList[index].category!.type=="top-up-jawaker"?Expanded(flex: 3,child: SizedBox(
                                                    height:30,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Color(0xFFBC985C),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5)
                                                            )
                                                        ),
                                                        onPressed: enabled?()async{
                                                          setState((){

                                                            loading=true;
                                                            enabled=false;
                                                          });
                                                          if(playerIdController.text.isEmpty){
                                                            setState((){
                                                              loading=false;
                                                              enabled=true;
                                                            });
                                                            showToast("pleaseEnterPlayerId").tr();
                                                            return;
                                                          }
                                                          setState((){
                                                            itemClickable=false;
                                                            descriptionEnabled=false;
                                                          });
                                                          var response;
                                                          if(controller.categoryList[index].category!.type=="top-up-jawaker"){
                                                            response=await sendPlayerIdAndGetNameForJawker(playerIdController.text);
                                                          }else{
                                                            response=await sendPlayerIdAndGetName(playerIdController.text);
                                                          }
                                                          setState((){
                                                            itemClickable=true;
                                                            descriptionEnabled=true;
                                                            loading=false;
                                                            enabled=true;
                                                          });
                                                          if(response.statusCode==200){

                                                            var data=jsonDecode(response.body);
                                                            var name=data['palyer_name'];
                                                            print(name);
                                                            if(name=="Not found"){

                                                              buyNowEnabled=false;
                                                              playerName=name;
                                                              setState((){});
                                                              return;
                                                            }
                                                            if(name=="Player number not valid"){
                                                              buyNowEnabled=false;
                                                              playerName=name;
                                                              setState((){});
                                                              return;
                                                            }
                                                            else{
                                                              playerName=name;
                                                              buyNowEnabled=true;
                                                            }
                                                            setState((){});


                                                          }else{
                                                            showToast("failed").tr();
                                                          }





                                                        }:null,
                                                        child: controller.categoryList[index].category!.type=="top-up-jawaker"?Text("Jawaker",style:  productListButtonTextStyle,overflow: TextOverflow.ellipsis,maxLines: 1,):SvgPicture.asset("assets/images/pbgbtn.svg")
                                                    ),
                                                  ),):SizedBox(),
                                                  SizedBox(width: 5,),
                                                  Expanded(flex: 3,child: SizedBox(
                                                    height:30,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Color(0xFF15375A),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5)
                                                          )
                                                      ),
                                                      onPressed: buyNowEnabled||
                                                          controller.categoryList[index].category!.type=='code'||
                                                          controller.categoryList[index].category!.type=='physical'||
                                                          controller.categoryList[index].category!.type=='top-up-no-api'?() async{
                                                        if(accountcontroller.token.isEmpty){
                                                          guestDialog(context, "youMustHaveToLoginFirstToBuy").tr();
                                                          return;
                                                        }
                                                        if(controller.categoryList[index].category!.type=='top-up-no-api'&&playerIdController.text.isEmpty){
                                                          showToast("pleaseEnterPlayerId").tr();
                                                          return;
                                                        }
                                                        setState((){
                                                          //loading=true;
                                                          enabled=false;
                                                          descriptionEnabled=false;
                                                        });
                                                        LoadingProgress.start(context);
                                                        var response=await sendAddCart(controller.categoryList[index].id.toString(), "1",playerIdController.text);
                                                        itemClickable=true;
                                                        buyNowEnabled=true;
                                                        descriptionEnabled=true;
                                                        enabled=true;
                                                        setState((){

                                                        });

                                                        LoadingProgress.stop(context);
                                                        if(response.statusCode==200){
                                                          var data=jsonDecode(response.body);
                                                          var message=data['message'];
                                                          showToast(message);
                                                          Navigator.of(context).push(PageTransition(child: CheekOutPage(playerId: playerIdController.text, playerName: playerName,), type: PageTransitionType.fade));
                                                        }else{
                                                          var data=jsonDecode(response.body);
                                                          print(response.body);
                                                          var message=data['error'];
                                                          showToast(message);
                                                        }
                                                      }:null,
                                                      child: Text("buyNow",style: productListButtonTextStyle,overflow: TextOverflow.ellipsis,maxLines: 1,).tr(),
                                                    ),
                                                  ),),
                                                  SizedBox(width: 5,),
                                                  Expanded(flex: 4,child: SizedBox(
                                                    height:30,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Color(0xFF262324),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5)
                                                          )
                                                      ),
                                                      onPressed: descriptionEnabled? (){
                                                        Navigator.of(context).push(PageTransition(child: DetailPage(categoryList: controller.categoryList[index],), type: PageTransitionType.fade));
                                                      }:null,
                                                      child: Text("description",style: productListButtonTextStyle,overflow: TextOverflow.ellipsis,maxLines: 1,).tr(),
                                                    ),
                                                  ),),
                                                ],
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                      toolTip? context.locale.toString().contains("en")?Positioned(
                                        top: 30,
                                        right: 0,
                                          child: SizedBox(
                                          child: Column(

                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,

                                            children: [
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding:EdgeInsets.only(right: 10),
                                                  child: RotatedBox(
                                                    quarterTurns: 0,
                                                    child: ClipPath(
                                                      clipper: ArrowClip(),
                                                      child: Container(
                                                        height: 10,
                                                        width: 12,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF262324),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF262324),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                padding: const EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                                child: Center(
                                                  child: Text(
                                                    "salesPriceGettooltippricecontrollercategorylistindexSymbol",
                                                    style: productListToolTiptStyle,
                                                  ).tr( namedArgs: {
                                                    "price":getTooltipPrice(controller.categoryList[index]).toString(),
                                                    "symbol":symbol,
                                                  }
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ):
                                      Positioned(
                                        top: 30,
                                        left: 10,
                                        child: SizedBox(
                                          child: Column(

                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,

                                            children: [
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding:EdgeInsets.only(right: 10),
                                                  child: RotatedBox(
                                                    quarterTurns: 0,
                                                    child: ClipPath(
                                                      clipper: ArrowClip(),
                                                      child: Container(
                                                        height: 10,
                                                        width: 12,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF262324),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF262324),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                padding: const EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),

                                                child: Center(
                                                  child: Text(
                                                    "salesPriceGettooltippricecontrollercategorylistindexSymbol",
                                                    style: productListToolTiptStyle,
                                                  ).tr( namedArgs: {
                                                    "price":getTooltipPrice(controller.categoryList[index]).toString(),
                                                    "symbol":symbol,
                                                  }
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ):SizedBox()
                                    ],
                                  ),
                                ):Container(
                                  margin: EdgeInsets.only(left: 20,right: 20,bottom: (index==controller.categoryList.length-1)?30:10),
                                  padding: EdgeInsets.only(left: 11,top: 11,bottom: 11,right: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF77CEDA).withOpacity(0.2)
                                        )
                                      ]
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(


                                        child: CachedNetworkImage(
                                          imageUrl: "$imageBaseUrl/${controller.categoryList[index].image}",
                                          height: 120,
                                          width: 100,
                                          fit: BoxFit.fill,

                                          imageBuilder: (context, imageProvider) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,),
                                                ),
                                              ),
                                          placeholder: (context, url) => Center(
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Color(0xFFE8E8E8)
                                              ),
                                              child: Icon(Icons.image,size: 60,),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.image,size: 100,),
                                        ),),
                                      SizedBox(width: 12,),
                                      Expanded(child: Column(

                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Text(controller.categoryList[index].title!,style: productListTitleTextStyle,),
                                          SizedBox(height: 13,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${controller.categoryList[index].customerPrice!} $symbol",style: productListPriceTextStyle,),
                                              controller.categoryList[index].outOfStock==true?Container(

                                                decoration: BoxDecoration(
                                                    color:Color(0xFFDA0200),

                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Text("outOfStock",style: productListOutTextStyle,).tr(),
                                                padding: EdgeInsets.all(5),

                                              ):SizedBox(),
                                            ],
                                          )

                                        ],
                                      ))
                                    ],
                                  ),
                                )
                            );
                          }
                      );
                    }
                  }),
                )),


              ],
            ),
            Positioned(
                right: 20,
                top: MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width*0.45,
                child:  role!='general'?BalanceWidget(controller: accountcontroller,):SizedBox()
            ),
            loading?Center(
              child: widget.type=="top-up-jawaker"?Image.asset("assets/images/jawaker.gif"):Image.asset("assets/images/loader.gif"),
            ):SizedBox()
          ],
        )
      ),

    );
  }

  getTooltipPrice(SearchL categoryList) {
    return (double.parse(categoryList.wholesalerPrice??"0.0")-categoryList.specialDiscount.toDouble());

  }
}
class ArrowClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
