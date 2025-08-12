import 'package:fluttertoast/fluttertoast.dart';
import 'package:mindrealm/utils/app_colors.dart';

// import 'package:get/get.dart';
// import 'package:challenging/Constants/common_colors.dart';

showToast(String message, {bool err = false}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: !err ? AppColors.secondary : AppColors.error,
      textColor: AppColors.white,
      fontSize: 16.0);
}
