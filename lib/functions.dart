String dateFormatter(DateTime dateTime) {
  var year = dateTime.year;
  var day = dateTime.day;
  var minute = dateTime.minute;
  var hour = dateTime.hour;
  var amorpm = dateTime.hour <= 11;
  var month = dateTime.month;

  return '$hour:$minute ${(amorpm ? 'am' : 'pm ')} $day/$month/$year';
}
