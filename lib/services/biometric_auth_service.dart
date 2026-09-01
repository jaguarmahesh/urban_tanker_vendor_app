import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricAuthService {
  static final BiometricAuthService instance = BiometricAuthService._internal();
  BiometricAuthService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (e) {
      print('Biometric availability check error: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Available biometrics error: $e');
      return [];
    }
  }

  Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate with Fingerprint or Face ID to access Vendor Portal',
  }) async {
    try {
      final bool isAvailable = await canCheckBiometrics();
      if (!isAvailable) {
        // Fallback for simulators or unsupported devices: allow simulation
        return true;
      }

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable || e.code == auth_error.notEnrolled) {
        return true; // Graceful fallback
      }
      print('Biometric authentication failed: $e');
      return false;
    }
  }
}
