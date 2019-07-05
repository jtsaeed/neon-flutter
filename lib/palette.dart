import 'package:flutter/material.dart';

Color primaryColor = Color(0xffFEAB00);
Color primaryLightColor = Color(0xffF6F5F0);
Color grayColor = Color(0xff8D8D92);
Color lightGrayColor = Color(0xffE5E5E5);

Color highPriorityColor = Color(0xff0067B3);
Color medPriorityColor = Color(0xff0093FE);
Color lowPriorityColor = Color(0xff4DB4FF);
Color noPriorityColor = Color(0xff999999);

Color getPriorityColor(String priority) {
  if (priority == 'No Priority') {
    return noPriorityColor;
  } else if (priority == 'Low Priority') {
    return lowPriorityColor;
  } else if (priority == 'Medium Priority') {
    return medPriorityColor;
  } else if (priority == 'High Priority') {
    return highPriorityColor;
  }
}