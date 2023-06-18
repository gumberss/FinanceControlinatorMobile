import 'package:fluttertoast/fluttertoast.dart';

import '../expenses/components/DefaultToast.dart';

//todo: move the code from expenses/components/DefaultToast to here and make this the default toast
class DefaultToaster {
  static void toastError(FToast toaster,
      {String message =
          "Oh no! I think something goes wrong.\nTry again in a few minutes"}) {
    toaster.showToast(
      child: DefaultToast.Error(message),
      gravity: ToastGravity.TOP_RIGHT,
      toastDuration: const Duration(seconds: 3),
    );
  }

  static void toastSuccess(FToast toaster, {String message = "Done!"}) {
    toaster.showToast(
      child: DefaultToast.Success(message),
      gravity: ToastGravity.TOP_RIGHT,
      toastDuration: const Duration(seconds: 3),
    );
  }
}
