

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String baseUrl = 'https://panel.supplyline.network/api/';

showInToast({String? msg, Color? color, ToastGravity? toastGravity = ToastGravity.BOTTOM}){
  return Fluttertoast.showToast(
      msg: '${msg}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: toastGravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0
  );
}