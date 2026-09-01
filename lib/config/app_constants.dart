// App Information
const String appName = 'URBAN TANKER';
const String appSubtitle = 'Vendor Portal';
const String appVersion = '1.0.0';

// API Configuration
const String apiBaseUrl = 'http://localhost:3000/api';
const String webSocketUrl = 'ws://localhost:3000';

// Firebase Configuration
const String firebaseProjectId = 'urban-tanker-platform';
const String firebaseAppId = 'com.urbanservice.vendor';

// Feature Flags
const bool enableMockData = true;
const bool enableDebugLogging = true;

// Timeouts (in seconds)
const int connectionTimeout = 30;
const int receiveTimeout = 30;
const int webSocketHeartbeat = 30;

// Pagination
const int itemsPerPage = 20;
const int maxRetries = 3;

// Service Types
const Map<String, String> serviceTypes = {
  'water_ro': 'RO Water',
  'water_purified': 'Purified Water',
  'water_construction': 'Construction Water',
  'sewage': 'Sewage Tank',
  'maintenance': 'Tank Maintenance',
};

// Service Capacities
const Map<String, List<int>> serviceCapacities = {
  'water_ro': [1000, 2000, 5000, 10000, 15000],
  'water_purified': [1000, 2000, 5000, 10000],
  'water_construction': [5000, 10000, 15000, 20000],
  'sewage': [1000, 2000, 5000, 10000],
  'maintenance': [500, 1000, 2000],
};

// Order Statuses
enum OrderStatus {
  requested,
  accepted,
  onTheWay,
  unloading,
  completed,
  cancelled,
}

const Map<OrderStatus, String> orderStatusLabels = {
  OrderStatus.requested: 'Requested',
  OrderStatus.accepted: 'Accepted',
  OrderStatus.onTheWay: 'On the Way',
  OrderStatus.unloading: 'Unloading',
  OrderStatus.completed: 'Completed',
  OrderStatus.cancelled: 'Cancelled',
};

// Payment Methods
const List<String> paymentMethods = [
  'Cash',
  'UPI',
  'Card',
  'Bank Transfer',
];

// Validation Rules
const int minPhoneLength = 10;
const int maxPhoneLength = 15;
const int minPasswordLength = 6;
const int maxNameLength = 50;

// Notification Topics
const String notificationTopicVendors = 'vendors';
const String notificationTopicOrders = 'orders';
const String notificationTopicAlerts = 'alerts';

// Date Formats
const String dateFormatDisplay = 'dd MMM yyyy';
const String dateTimeFormatDisplay = 'dd MMM yyyy, hh:mm a';
const String timeFormatDisplay = 'hh:mm a';

// Location Constants
const double defaultLatitude = 13.0827;   // Chennai
const double defaultLongitude = 80.2707;  // Chennai
const double locationUpdateInterval = 10.0; // seconds
const double locationAccuracy = 100.0; // meters

// Analytics Events
const String analyticsEventAppOpen = 'app_open';
const String analyticsEventOrderAccepted = 'order_accepted';
const String analyticsEventOrderCompleted = 'order_completed';
const String analyticsEventPaymentProcessed = 'payment_processed';

// Error Messages
const Map<String, String> errorMessages = {
  'network_error': 'Network connection failed. Please try again.',
  'auth_error': 'Authentication failed. Please login again.',
  'invalid_input': 'Please enter valid information.',
  'server_error': 'Server error. Please try again later.',
  'timeout_error': 'Request timeout. Please check your connection.',
  'unknown_error': 'An unexpected error occurred.',
};
