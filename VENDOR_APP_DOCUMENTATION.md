# Urban Tanker Vendor Mobile App - Complete Documentation

## Overview

The Urban Tanker Vendor Mobile App is a Flutter-based mobile application that enables water supply vendors to:
- Manage incoming service orders in real-time
- Track active deliveries and fleet status
- Manage water inventory across service types
- Monitor daily earnings and payments
- Manage drivers and vehicles
- Access comprehensive analytics

The app syncs all UI design and color schemes from the Admin Dashboard and Vendor Web Portal for consistent user experience across all platforms.

## Project Structure

```
urban_tanker_vendor_app/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── config/
│   │   ├── app_theme.dart                 # Unified design system (colors, fonts, spacing)
│   │   ├── app_constants.dart             # App-wide constants
│   │   └── firebase_config.dart           # Firebase initialization
│   ├── models/
│   │   └── vendor_models.dart             # Data models (VendorUser, Orders, etc.)
│   ├── providers/
│   │   └── vendor_app_state.dart          # Provider state management
│   ├── screens/
│   │   └── vendor_dashboard_screen.dart   # Main dashboard screen
│   ├── widgets/
│   │   └── vendor_widgets.dart            # Reusable UI components
│   └── services/                          # (To be added)
│       ├── api_service.dart
│       ├── firebase_service.dart
│       ├── websocket_service.dart
│       └── notification_service.dart
├── android/                               # Android native code
├── ios/                                   # iOS native code
├── pubspec.yaml                           # Dependencies
├── analysis_options.yaml                  # Linting rules
└── .gitignore                             # Git ignore rules
```

## Design System

All screens use the same design system as the Admin Dashboard and Vendor Web Portal:

### Color Palette
```
Primary:     #2563EB (Blue)
Secondary:   #7655D6 (Purple)
Success:     #159447 (Green)
Warning:     #D97706 (Orange)
Danger:      #D92D3B (Red)
Background:  #F5F7FB (Light blue-gray)
Surface:     #FFFFFF (White)
Text:        #20252B (Dark text)
TextMuted:   #6F7883 (Gray text)
Border:      #E4E8ED (Light border)
```

### Typography
- **Font Family**: Poppins (from Google Fonts)
- **Font Weights**: 400 (Normal), 500 (Medium), 600 (SemiBold), 700 (Bold), 800 (ExtraBold)
- **Font Sizes**: 10px (XS), 11px (SM), 13px (Base), 14px (MD), 16px (LG), 18px (XL), 25px (2XL), 28px (3XL)

### Spacing Scale
- `spacing1`: 4px (xs)
- `spacing2`: 8px (sm)
- `spacing3`: 12px (md)
- `spacing4`: 16px (lg)
- `spacing5`: 20px (xl)
- `spacing6`: 24px (2xl)
- `spacing7`: 28px (3xl)
- `spacing8`: 32px (4xl)

### Border Radius
- `radiusSm`: 6px
- `radiusMd`: 8px
- `radiusLg`: 10px
- `radiusFull`: 99px

## Key Features

### 1. Dashboard Screen
**Location**: `lib/screens/vendor_dashboard_screen.dart`

**Features**:
- Welcome section with vendor name
- KPI Metric Cards (4 columns):
  - Pending Requests (awaiting action)
  - Active Orders (in progress)
  - Today's Earnings (real-time)
  - Inventory Status (stock percentage)
- Pending Order Requests Section:
  - List of orders awaiting vendor response
  - Quick accept/reject buttons
  - Order details (customer, service type, amount)
- Earnings Display:
  - Today's total with trend indicator
  - Breakdown (completed, pending, commission)
  - Gradient card for visual emphasis
- Inventory Section:
  - Stock levels by service type
  - Utilization percentage bars
  - Low stock warnings
- Fleet Status:
  - Driver count by status (on trip, available, offline)
  - Driver list with ratings
  - Status indicators
- Alerts Section:
  - Low stock warnings
  - Pending order notifications
  - Color-coded alert items

### 2. State Management
**Location**: `lib/providers/vendor_app_state.dart`

Uses `Provider` package for state management:
- **Auth Methods**: loginVendor(), registerVendor(), logout(), updateProfile()
- **Order Methods**: acceptOrder(), updateOrderStatus(), _loadPendingOrders()
- **Inventory Methods**: updateInventory(), _loadInventory()
- **Driver Methods**: _loadDrivers()
- **Earnings Methods**: _loadEarnings()
- **Notification Methods**: _addNotification(), markNotificationsRead()
- **Utility Methods**: getTotalOrdersToday(), getPendingOrdersCount(), etc.

### 3. Data Models
**Location**: `lib/models/vendor_models.dart`

Key Models:
- **VendorUser**: Vendor business profile and credentials
- **VendorOrder**: Order details with status tracking
- **VendorInventory**: Stock management and utilization
- **VendorDriver**: Driver profile and status
- **VendorEarnings**: Revenue tracking and breakdown
- **InventoryTransaction**: Inventory activity log
- **EarningsBreakdown**: Service-wise earning breakdown

Each model includes:
- JSON serialization (fromJson/toJson)
- Type-safe properties
- Computed getters

### 4. Reusable Widgets
**Location**: `lib/widgets/vendor_widgets.dart`

Components:
- **VendorCard**: Base card component with shadow and border
- **MetricCard**: KPI metric display card
- **StatusBadge**: Status indicator with color coding
- **VendorTextField**: Custom text field with label and validation
- **VendorButton**: Primary button with loading state
- **VendorOutlineButton**: Secondary outline button
- **LoadingDialog**: Loading indicator dialog
- **ErrorDialog**: Error display dialog

## Dependencies

Core Dependencies:
```yaml
flutter:                    # Flutter framework
firebase_core:              # Firebase core services
firebase_auth:              # Authentication
cloud_firestore:            # Realtime database
firebase_messaging:         # Push notifications
firebase_storage:           # File storage
provider:                   # State management
http:                       # HTTP requests
web_socket_channel:         # WebSocket connections
geolocator:                 # Location services
permission_handler:         # Permission management
flutter_local_notifications:# Local notifications
shared_preferences:         # Local storage
flutter_secure_storage:     # Secure storage
google_fonts:               # Font integration
flutter_svg:                # SVG rendering
cached_network_image:       # Image caching
uuid:                       # ID generation
dio:                        # Advanced HTTP
connectivity_plus:          # Connectivity status
```

## Navigation Structure

Bottom Navigation with 5 screens:

```
Home (Dashboard)
├── KPI Cards
├── Pending Orders
├── Earnings Display
├── Inventory Status
├── Fleet Status
└── Alerts

Orders Management
├── Pending Orders
├── Active Orders (In Progress)
├── Completed Orders
└── Order Details

Inventory Management
├── Stock Levels by Service Type
├── Add/Update Inventory
├── Low Stock Alerts
└── Transaction History

Fleet Management
├── Driver List
├── Vehicle Status
├── Assignment Management
└── Tracking Map

Settings
├── Profile Management
├── Account Settings
├── Notification Preferences
└── Logout
```

## Setup & Installation

### Prerequisites
- Flutter 3.0+
- Dart 3.0+
- Android Studio / Xcode (for native builds)
- Firebase project account

### Step 1: Clone & Setup
```bash
cd urban_tanker_vendor_app
flutter pub get
```

### Step 2: Configure Firebase
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase for the project
flutterfire configure
```

### Step 3: Setup Poppins Font
Create `assets/fonts/` directory and add Poppins font files:
- Poppins-Regular.ttf (weight: 400)
- Poppins-Medium.ttf (weight: 500)
- Poppins-SemiBold.ttf (weight: 600)
- Poppins-Bold.ttf (weight: 700)
- Poppins-ExtraBold.ttf (weight: 800)

Download from: https://fonts.google.com/specimen/Poppins

### Step 4: Configure Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to track deliveries</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to your location to track deliveries</string>
```

### Step 5: Run the App
```bash
# Android
flutter run -t lib/main.dart

# iOS
flutter run -t lib/main.dart

# Release build
flutter build apk --release
flutter build ios --release
```

## API Integration

### Backend Endpoints

**Orders**:
- `POST /api/vendor/orders/accept` - Accept pending order
- `PATCH /api/vendor/orders/:id/status` - Update order status
- `GET /api/vendor/orders/pending` - Get pending orders
- `GET /api/vendor/orders/active` - Get active orders

**Inventory**:
- `GET /api/vendor/inventory` - Get current inventory
- `PATCH /api/vendor/inventory/:id` - Update inventory

**Drivers**:
- `GET /api/vendor/drivers` - Get driver list
- `PATCH /api/vendor/drivers/:id/status` - Update driver status

**Earnings**:
- `GET /api/vendor/earnings` - Get earnings summary
- `GET /api/vendor/earnings/breakdown` - Get service-wise breakdown

**User**:
- `POST /api/auth/login` - Vendor login
- `POST /api/auth/register` - Vendor registration
- `GET /api/vendor/profile` - Get vendor profile
- `PATCH /api/vendor/profile` - Update profile

### WebSocket Events

Real-time updates via WebSocket:
```javascript
// New order incoming
socket.on('order:new', (order) => {
  // Update pending orders
});

// Order status change
socket.on('order:status', (order) => {
  // Update active orders
});

// Driver location update
socket.on('driver:location', (location) => {
  // Update map
});

// Inventory update
socket.on('inventory:updated', (inventory) => {
  // Update inventory display
});
```

## Firebase Setup

### Firestore Collections Structure

```
vendors/
├── {vendorId}/
│   ├── profile: {...}
│   ├── orders:
│   │   ├── {orderId}: {...}
│   ├── inventory:
│   │   ├── {serviceType}: {...}
│   ├── drivers:
│   │   ├── {driverId}: {...}
│   └── earnings:
│       └── {date}: {...}

orders/
├── {orderId}/
│   ├── vendorId: string
│   ├── status: string
│   ├── customerInfo: {...}
│   └── timeline: [...]

notifications/
├── {vendorId}/
│   └── {notificationId}: {...}
```

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Vendor can only read their own data
    match /vendors/{vendorId} {
      allow read, write: if request.auth.uid == vendorId;
    }
    
    // Vendors can read orders assigned to them
    match /orders/{orderId} {
      allow read: if resource.data.vendorId == request.auth.uid;
      allow update: if resource.data.vendorId == request.auth.uid;
    }
    
    // Vendors can read their notifications
    match /notifications/{vendorId}/{notificationId} {
      allow read: if request.auth.uid == vendorId;
    }
  }
}
```

## Real-Time Features

### Firebase Messaging Setup

1. Configure Cloud Messaging in Firebase Console
2. Get server key for backend
3. Add to Android: `google-services.json`
4. Add to iOS: `GoogleService-Info.plist`

### Push Notification Types

- **New Order**: When customer books service
- **Order Status Update**: When admin approves/rejects
- **Inventory Alert**: When stock runs low
- **Payment Alert**: When payment is processed
- **Driver Alert**: When driver status changes
- **Customer Rating**: When customer rates service

## Performance Optimization

### Image Caching
```dart
import 'package:cached_network_image/cached_network_image.dart';

CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
);
```

### List Optimization
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    // Build only visible items
  },
);
```

### State Management
- Use Provider for efficient rebuilds
- Only notify listeners when data changes
- Use `Selector` for fine-grained updates

## Error Handling

### Network Errors
```dart
try {
  final response = await api.call();
} on SocketException {
  _showError('Network connection failed');
} on TimeoutException {
  _showError('Request timeout. Please try again.');
} catch (e) {
  _showError('An error occurred: $e');
}
```

### Firebase Errors
```dart
try {
  await auth.signInWithEmailAndPassword(email, password);
} on FirebaseAuthException catch (e) {
  switch (e.code) {
    case 'user-not-found':
      _showError('User not found');
    case 'wrong-password':
      _showError('Wrong password');
    default:
      _showError(e.message ?? 'Auth error');
  }
}
```

## Testing

### Unit Tests
```dart
test('VendorOrder.fromJson', () {
  final json = {'_id': '1', 'orderId': 'UT-123', ...};
  final order = VendorOrder.fromJson(json);
  expect(order.orderId, 'UT-123');
});
```

### Widget Tests
```dart
testWidgets('Dashboard displays pending orders', (tester) async {
  await tester.pumpWidget(const VendorApp());
  expect(find.text('Pending Order Requests'), findsOneWidget);
});
```

### Integration Tests
```dart
testWidgets('Complete order acceptance flow', (tester) async {
  // Test full order flow
});
```

## Deployment

### Android APK
```bash
flutter build apk --split-per-abi
# or
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS App
```bash
flutter build ios --release
# Then upload to App Store Connect
```

### Version Management
Update in `pubspec.yaml`:
```yaml
version: 1.0.0+1
# Format: x.y.z+buildNumber
```

## Next Steps

1. **Complete Firebase Integration**
   - Setup Firebase Authentication
   - Configure Firestore Rules
   - Setup Cloud Messaging
   - Configure Storage

2. **Implement Additional Screens**
   - Orders Management (pending, active, completed)
   - Inventory Management (add/update stock)
   - Fleet Management (driver tracking, assignment)
   - Earnings & Payment (settlement, withdrawal)
   - Settings (profile, preferences, logout)

3. **Connect to Backend API**
   - Implement API service layer
   - Replace mock data with real API calls
   - Setup request/response interceptors
   - Implement error handling

4. **Add WebSocket Real-Time Updates**
   - Real-time order notifications
   - Live driver tracking
   - Inventory synchronization
   - Payment status updates

5. **Implement Maps Integration**
   - Google Maps for delivery tracking
   - Real-time driver location
   - Delivery route optimization
   - Distance and ETA calculation

6. **Add Analytics & Monitoring**
   - Firebase Analytics
   - Crash Reporting (Crashlytics)
   - Performance Monitoring
   - Custom Events Tracking

7. **Notification System**
   - Local notifications
   - Firebase Cloud Messaging
   - In-app notification center
   - Notification preferences

8. **Testing**
   - Unit tests
   - Widget tests
   - Integration tests
   - Firebase Emulator testing

## Troubleshooting

### Common Issues

**Issue**: Firebase initialization fails
```
Solution: Run `flutterfire configure` and check firebase options
```

**Issue**: Location permission denied
```
Solution: Check AndroidManifest.xml and Info.plist permissions
Request runtime permissions using permission_handler package
```

**Issue**: Poppins font not loading
```
Solution: Verify assets path in pubspec.yaml
Ensure font files are in assets/fonts/ directory
Run `flutter pub get` and restart app
```

**Issue**: WebSocket connection fails
```
Solution: Check server is running
Verify WebSocket URL in constants
Check network connectivity
```

## Support & Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Firebase Flutter**: https://firebase.flutter.dev/
- **Provider Package**: https://pub.dev/packages/provider
- **Poppins Font**: https://fonts.google.com/specimen/Poppins
- **Material Design**: https://material.io/design

## License

MIT License - See LICENSE file

## Version History

### v1.0.0 (Current)
- Initial vendor mobile app launch
- Dashboard with KPI cards
- Order management (pending view)
- Inventory tracking
- Fleet status
- Earnings display
- Firebase integration setup
- Poppins font system
- Provider state management
- Responsive design for all screen sizes

---

**Status**: 🟢 Development Ready  
**Last Updated**: 2026-08-28  
**Maintained By**: Urban Tanker Team
