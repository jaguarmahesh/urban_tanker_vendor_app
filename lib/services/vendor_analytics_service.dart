import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Analytics Service for Vendor App
/// Tracks vendor business metrics, order handling, and app engagement
class VendorAnalyticsService {
  static final VendorAnalyticsService _instance =
      VendorAnalyticsService._internal();

  late FirebaseAnalytics _analytics;

  factory VendorAnalyticsService() {
    return _instance;
  }

  VendorAnalyticsService._internal();

  /// Initialize Firebase Analytics
  Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;

    // Enable analytics collection
    await _analytics.setAnalyticsCollectionEnabled(true);

    debugPrint('Firebase Analytics initialized for Vendor App');
  }

  /// Set vendor ID for analytics tracking
  Future<void> setVendorId(String vendorId) async {
    try {
      await _analytics.setUserId(id: vendorId);
      debugPrint('Vendor ID set for analytics: $vendorId');
    } catch (e) {
      debugPrint('Error setting vendor ID: $e');
    }
  }

  /// Set vendor business properties
  Future<void> setVendorProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      debugPrint('Vendor property set: $name = $value');
    } catch (e) {
      debugPrint('Error setting vendor property: $e');
    }
  }

  /// Track app launch
  Future<void> trackAppLaunch() async {
    try {
      await _analytics.logAppOpen();
      debugPrint('Vendor app launch tracked');
    } catch (e) {
      debugPrint('Error tracking app launch: $e');
    }
  }

  /// Track vendor login
  Future<void> trackVendorLogin(String vendorId, String businessName) async {
    try {
      await _analytics.logLogin(loginMethod: 'email');
      await setVendorId(vendorId);
      await setVendorProperty('business_name', businessName);
      await logCustomEvent('vendor_login', parameters: {
        'vendor_id': vendorId,
        'business_name': businessName,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Vendor login tracked: $businessName');
    } catch (e) {
      debugPrint('Error tracking vendor login: $e');
    }
  }

  /// Track vendor logout
  Future<void> trackVendorLogout(String vendorId) async {
    try {
      await logCustomEvent('vendor_logout', parameters: {
        'vendor_id': vendorId,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Vendor logout tracked');
    } catch (e) {
      debugPrint('Error tracking vendor logout: $e');
    }
  }

  /// Track screen view
  Future<void> trackScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: 'VendorApp',
      );
      debugPrint('Screen view tracked: $screenName');
    } catch (e) {
      debugPrint('Error tracking screen view: $e');
    }
  }

  /// Track order acceptance
  Future<void> trackOrderAccepted({
    required String orderId,
    required String customerId,
    required String serviceType,
    required double amount,
    required String capacity,
  }) async {
    try {
      await logCustomEvent('order_accepted', parameters: {
        'order_id': orderId,
        'customer_id': customerId,
        'service_type': serviceType,
        'amount': amount,
        'capacity': capacity,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Order accepted tracked: $orderId');
    } catch (e) {
      debugPrint('Error tracking order acceptance: $e');
    }
  }

  /// Track order rejection
  Future<void> trackOrderRejected(
    String orderId,
    String reason,
  ) async {
    try {
      await logCustomEvent('order_rejected', parameters: {
        'order_id': orderId,
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Order rejected tracked: $orderId - $reason');
    } catch (e) {
      debugPrint('Error tracking order rejection: $e');
    }
  }

  /// Track order status update
  Future<void> trackOrderStatusUpdate(
    String orderId,
    String newStatus,
    String driverId,
  ) async {
    try {
      await logCustomEvent('vendor_order_status_updated', parameters: {
        'order_id': orderId,
        'new_status': newStatus,
        'driver_id': driverId,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Order status updated tracked: $orderId - $newStatus');
    } catch (e) {
      debugPrint('Error tracking order status update: $e');
    }
  }

  /// Track order completion
  Future<void> trackOrderCompleted(
    String orderId,
    double amount,
    int deliveryTime,
  ) async {
    try {
      await logCustomEvent('order_completed', parameters: {
        'order_id': orderId,
        'amount': amount,
        'delivery_time_minutes': deliveryTime,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Order completed tracked: $orderId');
    } catch (e) {
      debugPrint('Error tracking order completion: $e');
    }
  }

  /// Track inventory update
  Future<void> trackInventoryUpdate(
    String serviceType,
    int previousQuantity,
    int newQuantity,
    String action,
  ) async {
    try {
      await logCustomEvent('inventory_updated', parameters: {
        'service_type': serviceType,
        'previous_quantity': previousQuantity,
        'new_quantity': newQuantity,
        'action': action,
        'change': newQuantity - previousQuantity,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Inventory update tracked: $serviceType');
    } catch (e) {
      debugPrint('Error tracking inventory update: $e');
    }
  }

  /// Track driver added
  Future<void> trackDriverAdded(
    String driverId,
    String driverName,
  ) async {
    try {
      await logCustomEvent('driver_added', parameters: {
        'driver_id': driverId,
        'driver_name': driverName,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Driver added tracked: $driverName');
    } catch (e) {
      debugPrint('Error tracking driver addition: $e');
    }
  }

  /// Track driver status update
  Future<void> trackDriverStatusUpdate(
    String driverId,
    String previousStatus,
    String newStatus,
  ) async {
    try {
      await logCustomEvent('driver_status_updated', parameters: {
        'driver_id': driverId,
        'previous_status': previousStatus,
        'new_status': newStatus,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Driver status updated: $driverId - $newStatus');
    } catch (e) {
      debugPrint('Error tracking driver status update: $e');
    }
  }

  /// Track earnings milestone
  Future<void> trackEarningsMilestone(
    double totalEarnings,
    int ordersCompleted,
  ) async {
    try {
      await logCustomEvent('earnings_milestone', parameters: {
        'total_earnings': totalEarnings,
        'orders_completed': ordersCompleted,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Earnings milestone tracked: \$${totalEarnings.toStringAsFixed(2)}');
    } catch (e) {
      debugPrint('Error tracking earnings milestone: $e');
    }
  }

  /// Track dashboard view
  Future<void> trackDashboardView(Map<String, dynamic> metrics) async {
    try {
      await logCustomEvent('dashboard_viewed', parameters: {
        'pending_orders': metrics['pendingOrders'] ?? 0,
        'active_orders': metrics['activeOrders'] ?? 0,
        'total_earnings': metrics['totalEarnings'] ?? 0,
        'fleet_status': metrics['fleetStatus'] ?? 'unknown',
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Dashboard view tracked');
    } catch (e) {
      debugPrint('Error tracking dashboard view: $e');
    }
  }

  /// Track order acceptance rate
  Future<void> trackAcceptanceRateMetric(
    int acceptedCount,
    int rejectedCount,
  ) async {
    try {
      final total = acceptedCount + rejectedCount;
      final rate = total > 0 ? (acceptedCount / total) * 100 : 0;

      await logCustomEvent('acceptance_rate_tracked', parameters: {
        'accepted_count': acceptedCount,
        'rejected_count': rejectedCount,
        'total_offers': total,
        'acceptance_rate': rate.toStringAsFixed(2),
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Acceptance rate tracked: $rate%');
    } catch (e) {
      debugPrint('Error tracking acceptance rate: $e');
    }
  }

  /// Track settings change
  Future<void> trackSettingsChange(String settingName, String oldValue, String newValue) async {
    try {
      await logCustomEvent('settings_changed', parameters: {
        'setting_name': settingName,
        'old_value': oldValue,
        'new_value': newValue,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Settings change tracked: $settingName');
    } catch (e) {
      debugPrint('Error tracking settings change: $e');
    }
  }

  /// Track notification action
  Future<void> trackNotificationAction(
    String notificationType,
    String action,
  ) async {
    try {
      await logCustomEvent('notification_action', parameters: {
        'notification_type': notificationType,
        'action': action,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('Notification action tracked: $notificationType - $action');
    } catch (e) {
      debugPrint('Error tracking notification action: $e');
    }
  }

  /// Track app error
  Future<void> trackError(String errorCode, String errorMessage) async {
    try {
      await logCustomEvent('vendor_app_error', parameters: {
        'error_code': errorCode,
        'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('App error tracked: $errorCode - $errorMessage');
    } catch (e) {
      debugPrint('Error tracking error event: $e');
    }
  }

  /// Log custom event
  Future<void> logCustomEvent(
    String eventName, {
    Map<String, Object?>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      debugPrint('Custom event logged: $eventName');
    } catch (e) {
      debugPrint('Error logging custom event: $e');
    }
  }

  /// Get Analytics instance for direct access
  FirebaseAnalytics get analytics => _analytics;
}
