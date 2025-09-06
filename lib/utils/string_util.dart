
import 'package:intl/intl.dart'; // 导入intl包


class StringUtil {
  /*邮箱校验*/
  static bool isValidEmail(String email) {
    // 正则表达式模式，用于匹配电子邮件地址
    // 该模式可以匹配大多数常见的电子邮件地址格式，但并非所有
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  /*当前时间字符串*/
  static String currentTimeString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }

  /*solo当前时间字符串*/
  static String currentSoloTimeString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm:ss').format(now);
    return formattedDate;
  }
  /* KMH 转换为 MPH */
  static String kmhTransferMph(int speed) {
    var kmh = (0.621371 * speed).toInt().toString();
    return "${kmh}Mp/h";
  }

  static String dateToString(DateTime date) {
    String formattedDate = DateFormat('yyyy/MM/dd').format(date);
    return formattedDate;
  }

  /*时间字符串转换为日期*/
  static DateTime stringToDate(String timeString) {
    print('timeString=${timeString}');
    if (timeString.contains('/')) {
      timeString = timeString.replaceAll('/', '-');
    }
    DateTime dateTime = DateTime.parse(timeString);
    return dateTime;
  }

  static String stringToEnglishDate(String timeString) {
    var formatter = DateFormat('MMMd,y');
    String formadDate = formatter.format(stringToDate(timeString));
    return formadDate;
  }

  /*记录两个时间点的时间差*/
  static int differenceInSeconds(DateTime? startTime, DateTime? endTime) {
    if (startTime == null || endTime == null) {
      return 0;
    }
    final Duration duration = endTime.difference(startTime);
    return duration.inMilliseconds.ceil(); // 计算秒数并向上取整
  }

  /*数据分析页面自定义时间展示*/
  static String serviceStringMyStatuDateString(String timeString) {
    try {
      DateTime dateTime = stringToDate(timeString);
      String formattedDate = DateFormat('MMM. dd').format(dateTime);
      return formattedDate;
    } catch (error) {
      return '-';
    }
  }

}
