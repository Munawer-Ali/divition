

import 'package:easy_localization/easy_localization.dart';

import 'package:divisioniosfinal/page/widget/rounded_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class EmptyFailureNoInternetView extends StatelessWidget {
  EmptyFailureNoInternetView(

      {required this.image,
      required this.title,
      required this.description,
      required this.buttonText,
        required this.status,
      required this.onPressed});

  final String title, description, buttonText, image;
  int status;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                image,
                height: 100,
                width: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title.tr(),
               style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                description.tr(),
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 8,
              ),
              status==1?RoundedElevatedButton(
                width: 200,
                onPressed: onPressed,
                childText: buttonText.tr(),
              ):Container()
            ],
          ),
        ),
      ),
    );
  }
}
