import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/constant.dart';
import '../account/account_controller.dart';

class BalanceWidget extends StatefulWidget {
  var controller;
  BalanceWidget({Key? key,required this.controller}) : super(key: key);

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> with SingleTickerProviderStateMixin {
  int toggle=0;
  AnimationController? _con;
  String symbole="";
  @override
  void initState() {
    _con = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
    getSymbole();
  }
  getSymbole()async{
    symbole=await getStringPrefs(SYMBOL);
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width*0.8,
      color: Colors.transparent,
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 40,
        width: (toggle==0)?40:MediaQuery.of(context).size.width*0.8,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: -10.0,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Stack(
          children: [
          context.locale.toString().contains("en")? AnimatedPositioned(
              duration: Duration(milliseconds: 375),
              top: 0,
              bottom: 0,
              right: 0,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xffF2F3F7),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: AnimatedBuilder(
                    builder: (context, widget) {
                      return Transform.rotate(
                        angle: _con!.value * 2.0 * pi,
                        child: widget,
                      );
                    },
                    animation: _con!,
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 20,
                      onPressed: (){
                        setState(
                              () {
                            if (toggle == 0) {
                              toggle = 1;
                              _con!.forward();
                            } else {
                              toggle = 0;
                              _con!.reverse();
                            }
                          },
                        );
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.network(widget.controller.profileImage.value,fit: BoxFit.fill,errorBuilder: (a,b,c){
                            return CircleAvatar(backgroundImage: AssetImage("assets/images/img6.png"));
                          },height: 40,width: 40,),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ):
          AnimatedPositioned(
            duration: Duration(milliseconds: 375),
            top: 0,
            bottom: 0,
            left: 0,
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: (toggle == 0) ? 0.0 : 1.0,
              duration: Duration(milliseconds: 200),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(0xffF2F3F7),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: AnimatedBuilder(
                  builder: (context, widget) {
                    return Transform.rotate(
                      angle: _con!.value * 2.0 * pi,
                      child: widget,
                    );
                  },
                  animation: _con!,
                  child: IconButton(
                    iconSize: 20,
                    splashRadius: 20,
                    onPressed: (){
                      setState(
                            () {
                          if (toggle == 0) {
                            toggle = 1;
                            _con!.forward();
                          } else {
                            toggle = 0;
                            _con!.reverse();
                          }
                        },
                      );
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(widget.controller.profileImage.value,fit: BoxFit.fill,errorBuilder: (a,b,c){
                          return CircleAvatar(backgroundImage: AssetImage("assets/images/img6.png"));
                        },height: 40,width: 40,),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
            context.locale.toString().contains("en")?  AnimatedPositioned(
              duration: Duration(milliseconds: 375),
              left: (toggle == 0) ? 20.0 : 50.0,
              curve: Curves.easeOut,
              top: 12,
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.58,
                    child: Obx(()=>Text(widget.controller.wallet.value,style: TextStyle(fontSize: 13),))
                ),
              ),
            ):
            AnimatedPositioned(
              duration: Duration(milliseconds: 375),
              right: (toggle == 0) ? 20.0 : 50.0,
              curve: Curves.easeOut,
              top: 12,
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.58,
                    child: Obx(()=>Text(widget.controller.wallet.value,style: TextStyle(fontSize: 13),))
                ),
              ),
            ),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              child: IconButton(
                iconSize: 20,
                splashRadius: 20.0,
                padding: EdgeInsets.zero,
                icon: Text(symbole.isNotEmpty?symbole:"₪",style: TextStyle(fontSize: 18,color: Colors.black),),
                onPressed: () {
                  setState(
                        () {
                      if (toggle == 0) {
                        toggle = 1;
                        _con!.forward();
                      } else {
                        toggle = 0;
                        _con!.reverse();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
