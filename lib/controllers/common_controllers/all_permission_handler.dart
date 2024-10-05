import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:universal_html/html.dart' as html;
import '../../../config.dart';
import '../../models/position_item.dart';
import '../../utils/type_list.dart';

class PermissionHandlerController extends GetxController {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';
  final GeolocatorPlatform geoLocatorPlatform = GeolocatorPlatform.instance;
  final List<PositionItem> _positionItems = <PositionItem>[];


  //location
  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await geoLocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      updatePositionList(
        PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );
      return false;
    }

    permission = await geoLocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geoLocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        updatePositionList(
          PositionItemType.log,
          _kPermissionDeniedMessage,
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      updatePositionList(
        PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );
      return false;
    }
    updatePositionList(
      PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  //update position
  void updatePositionList(PositionItemType type, String displayValue) {
    _positionItems.add(PositionItem(type, displayValue));
    update();
  }

  //location permission check and request
  static Future<bool> checkAndRequestPermission(Permission permission) {
    Completer<bool> completer = Completer<bool>();
    log("permission :$permission");
    permission.request().then((status) {
      if (status != PermissionStatus.granted) {
        permission.request().then((status) {
          bool granted = status == PermissionStatus.granted;
          completer.complete(granted);
        });
      } else {
        completer.complete(true);
      }
    });
    return completer.future;
  }

//get contact permission
  Future<PermissionStatus> getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    debugPrint("getContactPermission : $permission");
    if (permission == PermissionStatus.denied || permission == PermissionStatus.restricted) {
      PermissionStatus permissionStatus = await Permission.contacts.request();

      return permissionStatus;
    } else {
      debugPrint("getContactPermission 22: $permission");
      return permission;
    }
  }

  //handle invalid permission
  handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text(appFonts.accessDenied.tr));
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
      SnackBar(content: Text(appFonts.contactDataNotAvailable.tr));
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    }
  }

  // get location
  Future<Position?> getCurrentPosition() async {

    final hasPermission = await handlePermission();
    if (!hasPermission) {
      await Geolocator.requestPermission();

      getCurrentPosition();
    } else {
      final position = await geoLocatorPlatform.getCurrentPosition();
      updatePositionList(
        PositionItemType.position,
        position.toString(),
      );
      return position;
    }
    return null;
  }

  Future<bool> permissionGranted() async {

    PermissionStatus permissionStatus =
    await getContactPermission();
    log("permissionStatus 22: $permissionStatus");
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }



//get camera permission
  static getCameraPermission(context) async {
    final permission =
    await html.window.navigator.permissions?.query({'name': 'microphone'});
    log("permission : ${permission!.state}");

    try{
      if (permission.state == 'prompt' || permission.state == "denied") {
        WidgetsFlutterBinding.ensureInitialized();
        dynamic value =
        await html.window.navigator.getUserMedia(audio: true, video: true);
        log("AUDIO : $value");
      }

      final perm =
      await html.window.navigator.permissions!.query({"name": "camera"});
      await availableCameras().onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          backgroundColor: appCtrl.appTheme.redColor,
        ));
        return [];
      });
      if((perm.state != "denied" || perm.state != "prompt")&& (permission.state != "denied" || permission.state != "prompt")){
        return true;
      }else{
        return false;
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: appCtrl.appTheme.redColor,
      ));
      return false;
    }

  }

  // get microphone permission
  static Future<PermissionStatus> getMicrophonePermission() async {
    if (await Permission.microphone.request().isGranted) {
      return PermissionStatus.granted;
    } else {
      return PermissionStatus.denied;
    }
  }


  Future<bool> getCameraMicrophonePermissions(context) async {
    bool av = await getCameraPermission(context);
    log("fhghggh:$av");
    return  av;
  }

  static void _handleInvalidPermissions(
      PermissionStatus cameraPermissionStatus,
      PermissionStatus microphonePermissionStatus,
      ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

}
