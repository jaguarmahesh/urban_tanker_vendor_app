/// Urban Tanker Vendor App - Environment Configuration
/// Place this file at: lib/config/env_config.dart

class EnvironmentConfig {
  /// App Configuration
  static const String appName = 'Urban Tanker Vendor';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';
  static const String appEnv = 'development'; // development, staging, production

  /// API Configuration
  static const String apiBaseUrl = 'http://localhost:5000/api/v1';
  static const int apiTimeout = 30000; // milliseconds
  static const bool apiRetryEnabled = true;
  static const int apiRetryAttempts = 3;

  /// Firebase Configuration
  static const Map<String, dynamic> firebaseConfig = {
    'apiKey': 'AIza...your-firebase-api-key',
    'authDomain': 'urban-tanker-prod.firebaseapp.com',
    'projectId': 'urban-tanker-prod',
    'storageBucket': 'urban-tanker-prod.appspot.com',
    'messagingSenderId': '123456789',
    'appId': '1:123456789:android:xyz789...',
    'databaseURL': 'https://urban-tanker-prod.firebaseio.com',
    'measurementId': 'G-VENDOR123',
  };

  /// Firebase Features
  static const bool firebaseAnalyticsEnabled = true;
  static const bool firebaseMessagingEnabled = true;
  static const bool firebaseAuthEnabled = true;
  static const bool firebaseStorageEnabled = true;

  /// Google Analytics Configuration
  static const Map<String, dynamic> analyticsConfig = {
    'enabled': true,
    'debugMode': false,
    'measurementId': 'G-VENDOR123',
  };

  /// WebSocket Configuration
  static const Map<String, dynamic> websocketConfig = {
    'enabled': true,
    'url': 'http://localhost:5000',
    'reconnectionDelay': Duration(milliseconds: 1000),
    'reconnectionMaxDelay': Duration(milliseconds: 5000),
    'reconnectionMaxAttempts': 10,
    'transports': ['websocket', 'polling'],
  };

  // Socket.IO Namespaces
  static const String socketNamespaceOrders = '/orders';
  static const String socketNamespaceNotifications = '/notifications';
  static const String socketNamespaceTracking = '/tracking';
  static const String socketNamespaceFleet = '/fleet';

  /// Database Configuration (Local - SQLite/Hive)
  static const Map<String, dynamic> databaseConfig = {
    'useLocalDatabase': true,
    'localDatabaseName': 'urban_tanker_vendor.db',
    'databaseVersion': 1,
    'enableEncryption': true,
  };

  /// Maps Configuration
  static const Map<String, dynamic> mapConfig = {
    'googleMapsApiKey': 'your-google-maps-api-key',
    'defaultZoom': 12.0,
    'centerLat': 40.7128,
    'centerLng': -74.0060,
    'enabled': true,
    'showTraffic': true,
    'showDriverLocations': true,
  };

  /// Authentication Configuration
  static const Map<String, dynamic> authConfig = {
    'enabled': true,
    'googleAuthEnabled': true,
    'emailAuthEnabled': true,
    'phoneAuthEnabled': true,
    'sessionTimeout': Duration(minutes: 60),
    'multiFactorAuthEnabled': false,
  };

  /// Order Management Configuration
  static const Map<String, dynamic> orderConfig = {
    'autoRefreshEnabled': true,
    'autoRefreshInterval': Duration(seconds: 5),
    'notificationsEnabled': true,
    'soundEnabled': true,
    'vibrationEnabled': true,
    'showEstimatedTime': true,
    'gpsTrackingEnabled': true,
    'autoAssignDriver': false,
    'autoAcceptOrders': false,
  };

  /// Inventory Management Configuration
  static const Map<String, dynamic> inventoryConfig = {
    'autoRefreshEnabled': true,
    'autoRefreshInterval': Duration(seconds: 30),
    'lowStockNotifications': true,
    'barcodeScanning': true,
    'imageUpload': true,
    'batchOperations': true,
  };

  /// Fleet Management Configuration
  static const Map<String, dynamic> fleetConfig = {
    'gpsTrackingEnabled': true,
    'realTimeLocationUpdate': true,
    'refreshInterval': Duration(seconds: 5),
    'showAllDrivers': true,
    'driverCommunication': true,
    'routeOptimization': true,
    'fuelTracking': true,
    'maintenanceTracking': true,
  };

  /// Earnings & Payments Configuration
  static const Map<String, dynamic> earningsConfig = {
    'displayEnabled': true,
    'exportEnabled': true,
    'withdrawalEnabled': true,
    'minWithdrawalAmount': 100.0,
    'maxWithdrawalAmount': 10000.0,
    'weeklySettlement': true,
    'settlementDay': 'Friday',
    'paymentMethodManagement': true,
  };

  /// Notifications Configuration
  static const Map<String, dynamic> notificationsConfig = {
    'enabled': true,
    'ordersNotifications': true,
    'inventoryNotifications': true,
    'fleetNotifications': true,
    'paymentNotifications': true,
    'systemNotifications': true,
    'soundEnabled': true,
    'vibrationEnabled': true,
    'badgeEnabled': true,
    'quietHoursEnabled': true,
    'quietHoursStart': '22:00',
    'quietHoursEnd': '08:00',
  };

  /// Analytics & Reporting Configuration
  static const Map<String, dynamic> analyticsReportConfig = {
    'enabled': true,
    'realTimeAnalytics': true,
    'performanceMetrics': true,
    'earningsReports': true,
    'orderReports': true,
    'exportEnabled': true,
    'scheduledReports': true,
  };

  /// KPI Tracking Configuration
  static const Map<String, dynamic> kpiConfig = {
    'acceptanceRate': true,
    'completionRate': true,
    'averageRating': true,
    'totalEarnings': true,
    'activeOrders': true,
    'deliveryTime': true,
    'customerSatisfaction': true,
  };

  /// Storage Configuration
  static const Map<String, dynamic> storageConfig = {
    'useCloudStorage': false, // Use Firebase Storage
    'useLocalStorage': true,   // Use device storage
    'maxLocalCacheSize': 104857600, // 100MB
    'localCachePath': 'urban_tanker_vendor_cache',
  };

  /// Communication Configuration
  static const Map<String, dynamic> communicationConfig = {
    'chatEnabled': true,
    'supportChatEnabled': true,
    'driverCommunication': true,
    'customerCommunication': true,
    'platformCommunication': true,
  };

  /// Feature Toggles
  static const Map<String, bool> features = {
    'orderManagement': true,
    'inventoryManagement': true,
    'fleetManagement': true,
    'earningsTracking': true,
    'analytics': true,
    'reportGeneration': true,
    'liveChat': true,
    'driverTracking': true,
    'gpsTracking': true,
    'routeOptimization': false,
    'fuelTracking': true,
    'maintenanceTracking': true,
    'referralProgram': false,
  };

  /// App Behavior Configuration
  static const Map<String, dynamic> appConfig = {
    'useSystemLocale': true,
    'supportedLanguages': ['en', 'es', 'fr'],
    'defaultLanguage': 'en',
    'darkModeEnabled': true,
    'biometricAuthEnabled': true,
    'crashReportingEnabled': true,
    'analyticsEnabled': true,
  };

  /// UI Configuration
  static const Map<String, dynamic> uiConfig = {
    'animationsEnabled': true,
    'imageCompressionEnabled': true,
    'lowDataMode': false,
    'themeColor': 0xFF2563EB, // Blue
    'accentColor': 0xFF1E40AF, // Dark Blue
  };

  /// Logging Configuration
  static const Map<String, dynamic> loggingConfig = {
    'enabled': true,
    'logLevel': 'debug', // debug, info, warn, error
    'logToFile': true,
    'logFilePath': 'urban_tanker_vendor_logs',
    'logRetention': 30, // days
  };

  /// Security Configuration
  static const Map<String, dynamic> securityConfig = {
    'useSSLPinning': true,
    'certificatePath': 'assets/certificates/urbantanker.pem',
    'dataEncryptionEnabled': true,
    'biometricAuthEnabled': true,
    'autoLogoutEnabled': true,
    'autoLogoutDuration': Duration(minutes: 30),
  };

  /// Performance Configuration
  static const Map<String, dynamic> performanceConfig = {
    'enableCaching': true,
    'enableImageCaching': true,
    'enableHttpCaching': true,
    'preloadImagesEnabled': true,
    'lazyLoadingEnabled': true,
  };

  /// Data Sync Configuration
  static const Map<String, dynamic> syncConfig = {
    'autoSyncEnabled': true,
    'syncInterval': Duration(seconds: 30),
    'offlineSyncEnabled': true,
    'syncOnConnect': true,
  };

  // Helper method to get environment-specific config
  static String getEnvironmentDescription() {
    switch (appEnv) {
      case 'development':
        return 'Development Environment';
      case 'staging':
        return 'Staging Environment';
      case 'production':
        return 'Production Environment';
      default:
        return 'Unknown Environment';
    }
  }

  // Helper method to check if in development mode
  static bool isDebugMode() => appEnv == 'development';

  // Helper method to check if in production mode
  static bool isProductionMode() => appEnv == 'production';

  // Helper method to get API base URL with version
  static String getApiUrl(String endpoint) {
    return '$apiBaseUrl$endpoint';
  }

  // Helper method to build WebSocket connection string
  static String getWebSocketUrl() {
    return websocketConfig['url'];
  }
}
