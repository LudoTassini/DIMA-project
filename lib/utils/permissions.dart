import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestCameraPermission() async {
  PermissionStatus permissionStatus = await Permission.camera.status;
  if(permissionStatus.isGranted){
    return permissionStatus;
  }
  else{
    permissionStatus = await Permission.camera.request();
    if (permissionStatus.isPermanentlyDenied){
      await openAppSettings();
      return permissionStatus;
    }
    else{
      return permissionStatus;
    }
  }
}

Future<PermissionStatus> requestPhotoLibraryPermission() async {
  PermissionStatus permissionStatus = await Permission.photos.status;
  if(permissionStatus.isGranted){
    return permissionStatus;
  }
  else{
    permissionStatus = await Permission.photos.request();
    if (permissionStatus.isPermanentlyDenied){
      await openAppSettings();
      return permissionStatus;
    }
    else{
      return permissionStatus;
    }
  }
}