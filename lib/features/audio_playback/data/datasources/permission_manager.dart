import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  // Private constructor to prevent direct instantiation
  PermissionManager._();

  // Singleton instance
  static final PermissionManager _instance = PermissionManager._();

  // Public getter for the singleton instance
  static PermissionManager get instance => _instance;

  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }
}
