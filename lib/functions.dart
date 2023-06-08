import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String dateFormatter(DateTime dateTime) {
  var year = dateTime.year;
  var day = dateTime.day;
  var minute = dateTime.minute;
  var hour = dateTime.hour;
  var amorpm = dateTime.hour <= 11;
  var month = dateTime.month;

  return '$hour:$minute ${(amorpm ? 'am' : 'pm ')} $day/$month/$year';
}

moveToPage(Widget page, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      return page;
    },
  ));
}

back(BuildContext context) {
  Navigator.of(context).pop();
}
