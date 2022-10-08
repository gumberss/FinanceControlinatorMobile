import 'package:finance_controlinator_mobile/components/BusinessException.dart';
import 'package:geolocator/geolocator.dart';
import 'Result.dart';

class Locator {
  Future<Result<Position, BusinessException>> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Result.fromError(BusinessException("[[SERVICE_NOT_ENABLED]]"));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Result.fromError(BusinessException("[[DENIED]]"));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Result.fromError(BusinessException("[[DENIED_FOREVER]]"));
    }

    return Result(await Geolocator.getCurrentPosition());
  }
}
