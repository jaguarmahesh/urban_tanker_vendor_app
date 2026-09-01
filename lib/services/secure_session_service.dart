import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSessionService {
  static final SecureSessionService instance = SecureSessionService._internal();
  SecureSessionService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _keySessionToken = 'ut_secure_session_token_v1';
  static const String _keyUserSession = 'ut_secure_user_payload_v1';
  static const String _keyActiveTenant = 'ut_secure_active_tenant_v1';
  static const String _keyRememberedEmail = 'ut_secure_remembered_email';
  static const String _keyRememberedClient = 'ut_secure_remembered_client';
  static const String _keyBiometricEnabled = 'ut_biometric_login_enabled';
  static const String _keyLastGpsLocation = 'ut_last_gps_location';

  Future<void> saveEncryptedSession({
    required String token,
    required Map<String, dynamic> userPayload,
    required String tenantId,
    required String clientCode,
  }) async {
    try {
      await _storage.write(key: _keySessionToken, value: token);
      await _storage.write(
        key: _keyUserSession,
        value: jsonEncode(userPayload),
      );
      await _storage.write(key: _keyActiveTenant, value: tenantId);
      if (userPayload['email'] != null) {
        await _storage.write(
          key: _keyRememberedEmail,
          value: userPayload['email'] as String,
        );
      }
      await _storage.write(key: _keyRememberedClient, value: clientCode);
    } catch (e) {
      print('Error saving encrypted session: $e');
    }
  }

  Future<Map<String, dynamic>?> readEncryptedSession() async {
    try {
      final token = await _storage.read(key: _keySessionToken);
      final rawUser = await _storage.read(key: _keyUserSession);
      final tenantId = await _storage.read(key: _keyActiveTenant);

      if (token == null || rawUser == null) {
        return null;
      }

      final userData = jsonDecode(rawUser) as Map<String, dynamic>;
      return {
        'token': token,
        'user': userData,
        'tenantId': tenantId ?? 'balaji',
      };
    } catch (e) {
      print('Error reading encrypted session: $e');
      return null;
    }
  }

  Future<String?> getRememberedEmail() async {
    return await _storage.read(key: _keyRememberedEmail);
  }

  Future<String?> getRememberedClient() async {
    return await _storage.read(key: _keyRememberedClient);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _keyBiometricEnabled,
      value: enabled ? 'true' : 'false',
    );
  }

  Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: _keyBiometricEnabled);
    return val == 'true';
  }

  Future<void> saveLastGpsLocation(double lat, double lng) async {
    await _storage.write(
      key: _keyLastGpsLocation,
      value: jsonEncode({'lat': lat, 'lng': lng, 'time': DateTime.now().toIso8601String()}),
    );
  }

  Future<Map<String, dynamic>?> getLastGpsLocation() async {
    final raw = await _storage.read(key: _keyLastGpsLocation);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    try {
      await _storage.delete(key: _keySessionToken);
      await _storage.delete(key: _keyUserSession);
      await _storage.delete(key: _keyActiveTenant);
    } catch (e) {
      print('Error clearing session: $e');
    }
  }
}
