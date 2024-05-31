import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (status.isPermanentlyDenied){
    await openAppSettings();
    return status;
  }
  else if (!status.isGranted) {
    PermissionStatus permissionStatus = await Permission.camera.request();
    return permissionStatus;
  }
  else {
    return PermissionStatus.granted;
  }
}