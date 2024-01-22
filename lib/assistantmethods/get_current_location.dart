import 'package:foodpilot_app/global/global.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UserLocation {
  Future<void> getCurrentLocation() async {
    // Check and request location permission
    var status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      position = newPosition;
      placeMarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      Placemark pMark = placeMarks![0];
      completeAddress =
          '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
    } else {
      // Permission denied
      print('Permission denied to access location');
    }
  }
}
