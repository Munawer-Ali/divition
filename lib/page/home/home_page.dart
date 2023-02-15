import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../connectivity/connectivity_checker.dart';
import '../../package/grid/responsive_grid.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../utils/constant.dart';
import '../account/account_controller.dart';
import '../product/product_list_page.dart';
import '../search/search_page.dart';
import '../widget/balance_widget.dart';
import '../widget/empty_failure_no_internet_view.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int toggle=0;
  final controller=Get.put(HomeController());
  final accountController=Get.put(AccountController());
  final internetController=Get.put(ConnectivityCheckerController());
  String role="";
  @override
  void initState() {
    internetController.startMonitoring();
    controller.getData(true);

    super.initState();
    getRole();
  }
  getRole()async{
    role=await getStringPrefs(ROLE);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF15375A).withOpacity(1),
                  Color(0xFF8FC7FF).withOpacity(1)
                ],
                stops: [0.0, 1.0],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Stack(
            children: [
              Positioned(
                child: Row(

                  children: [
                    SizedBox(width: 30,),
                    Column(

                      children: [
                        SizedBox(height: 20,),
                        Text("DIVISION",style: homeTitleTextStyle,),
                        Text("Digital Virtual Station",style: homeDescriptionTextStyle,)
                      ],
                    ),
                    Expanded(child: Image.asset("assets/images/fighter.png",width: MediaQuery.of(context).size.width*0.5,)),
                  ],
                ),
                bottom: 0,
                left: 0,
                right: 0,

              ),
              Positioned(
                  right: 20,
                  top: MediaQuery.of(context).padding.top,
                  width: MediaQuery.of(context).size.width*0.45,
                  child:  role!='general'?BalanceWidget(controller: accountController,):SizedBox()
              ),
            ],
          ),
        ),
        SizedBox(height: 21,),
        GestureDetector(
          onTap: (){
            Navigator.of(context,rootNavigator: true).push(PageTransition(child: SearchPage(), type: PageTransitionType.fade));
          },
          child: Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal:30 ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFE1ECEF),
              border: Border.all(color: Color(0xFFD9D9D9),width: 0.5)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Row(
                children: [
                  SvgPicture.asset("assets/images/search.svg"),
                  SizedBox(width: 3,),
                  Text("Search",style: TextStyle(fontSize: 13),)
                ],
              ),
            ),


          ),
        ),
        SizedBox(height: 20,),
        Expanded(
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
                  title: 'Internet Error',
                  description: 'Internet not found',
                  buttonText: "Retry",
                  onPressed: () {
                    controller.getData(true);
                  },
                  status: 1,
                ),
              );
            } else if (controller.internetError.value == true) {
              return Center(
                child: EmptyFailureNoInternetView(
                  image: 'assets/lottie/no_internet_lottie.json',
                  title: 'Internet Error',
                  description: 'Internet not found',
                  buttonText: "Retry",
                  onPressed: () {
                    controller.getData(true,);
                  },
                  status: 1,
                ),
              );
            } else if (controller.serverError.value == true) {
              return Center(
                child: EmptyFailureNoInternetView(
                  image: 'assets/lottie/failure_lottie.json',
                  title: 'Server error'.tr,
                  description: 'Please try again later',
                  buttonText: "Retry",
                  onPressed: () {
                    controller.getData(true);
                  },
                  status: 1,
                ),
              );
            } else if (controller.somethingWrong.value == true) {
              return Center(
                child: EmptyFailureNoInternetView(
                  image: 'assets/lottie/failure_lottie.json',
                  title: 'Something went wrong',
                  description: 'Please try again later',
                  buttonText: "Retry",
                  onPressed: () {
                    controller.getData(true,);
                  },
                  status: 1,
                ),
              );
            }else  if(controller.timeoutError.value==true){
              return Center(
                child: EmptyFailureNoInternetView(
                  image: 'assets/lottie/failure_lottie.json',
                  title: 'Timeout',
                  description: 'Please try again',
                  buttonText: "Retry",
                  onPressed: () {
                    controller.getData(true);
                  },
                  status: 1,
                ),
              );
            }
            else{
              return RefreshIndicator(
                onRefresh: ()async{
                  controller.getData(false);
                },
                child: StaggeredGridView.countBuilder(
                    crossAxisCount: 12,
                    padding: EdgeInsets.only(left: 20,right: 20,bottom: 30),
                    itemCount: controller.list.length,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){

                          Navigator.of(context).push(PageTransition(type: PageTransitionType.fade, child: ProductListPage(slag: '${controller.list[index].slug}', type: '${controller.list[index].type}',)));



                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF77CEDA).withOpacity(0.2),
                                    offset: Offset(0,0),
                                    blurRadius: 20
                                )
                              ]
                          ),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: "$imageBaseUrl/${controller.list[index].image}",
                                height: MediaQuery.of(context).size.width*0.2,
                                width: MediaQuery.of(context).size.width*0.2,
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
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Color(0xFFE8E8E8)
                                    ),
                                    child: Icon(Icons.image,size: 60,),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.image,size: 60,),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index){
                      return StaggeredTile.fit(4);
                    }
                ),
              );
            }
          }),
        ),

      ],
    );
  }


}


