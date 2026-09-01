# Urban Tanker Vendor Mobile App

A modern Flutter-based mobile application for water delivery vendors to manage orders, track deliveries, inventory, and earnings in real-time.

## 🚀 Quick Start

### Prerequisites
- **Flutter**: 3.0 or higher
- **Dart**: 3.0 or higher
- **Android**: API 21 or higher
- **iOS**: 11.0 or higher
- **Firebase Project**: Active Firebase account

### Installation

```bash
# Clone repository
git clone <repo-url>
cd urban_tanker_vendor_app

# Install dependencies
flutter pub get

# Configure Firebase
flutterfire configure

# Run development build
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --split-per-abi --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS App
flutter build ios --release
```

## 📱 Features

### Dashboard
- 📊 Real-time KPI metrics (pending orders, active orders, earnings, inventory)
- 📋 Pending order requests with quick accept/reject
- 💰 Earnings tracking with service breakdown
- 📦 Inventory status by service type
- 👥 Fleet status and driver information
- ⚠️ Alert notifications (low stock, pending actions)

### Order Management
- Accept/reject incoming orders
- Track order status in real-time
- View customer details and delivery location
- Monitor order progress from requested to completed
- Rate and review customer interactions

### Inventory Tracking
- Monitor stock levels by service type
- Track capacity utilization percentage
- Add/update inventory with transaction history
- Low stock alerts
- Service-wise inventory breakdown

### Fleet Management
- Real-time driver status (available, on trip, offline)
- Driver performance metrics and ratings
- Driver assignments and tracking
- Vehicle information and status
- Driver availability management

### Earnings & Payments
- Daily earnings tracking
- Weekly and monthly performance
- Service-wise earnings breakdown
- Commission tracking
- Payment settlement status

### Notifications
- Real-time order notifications
- Inventory alerts
- Payment confirmations
- Driver status updates
- Customer ratings and reviews

## 🎨 Design System

### Color Scheme
| Color | Hex | Usage |
|-------|-----|-------|
| Primary | #2563EB | Main actions, links |
| Secondary | #7655D6 | Accents, highlights |
| Success | #159447 | Positive states, confirmations |
| Warning | #D97706 | Alerts, cautions |
| Danger | #D92D3B | Errors, deletions |
| Background | #F5F7FB | App background |
| Surface | #FFFFFF | Cards, panels |
| Text | #20252B | Primary text |
| Muted | #6F7883 | Secondary text |
| Border | #E4E8ED | Borders, dividers |

### Typography
- **Font Family**: Poppins
- **Weights**: 400, 500, 600, 700, 800
- **Sizes**: 10px (XS) to 28px (3XL)

### Spacing
- **Scale**: 4px → 32px (8-tier system)
- **Components**: Consistent padding, margins, gaps

### Border Radius
- **Values**: 6px, 8px, 10px, 99px (rounded)

## 📂 Project Structure

```
urban_tanker_vendor_app/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── config/
│   │   ├── app_theme.dart                 # Design tokens & theme
│   │   ├── app_constants.dart             # App constants
│   │   └── firebase_config.dart           # Firebase setup
│   ├── models/
│   │   └── vendor_models.dart             # Data classes
│   ├── providers/
│   │   └── vendor_app_state.dart          # State management
│   ├── screens/
│   │   ├── vendor_dashboard_screen.dart   # Main dashboard
│   │   └── ...                            # Other screens (TBD)
│   ├── widgets/
│   │   └── vendor_widgets.dart            # Reusable components
│   └── services/                          # (To be added)
├── android/                               # Android native code
├── ios/                                   # iOS native code
├── assets/
│   ├── fonts/                             # Poppins font files
│   └── images/                            # App images (TBD)
└── pubspec.yaml                           # Dependencies
```

## 🔐 Security

### Firebase Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Vendors can only access their own data
    match /vendors/{vendorId} {
      allow read, write: if request.auth.uid == vendorId;
    }
    
    // Vendors can only access assigned orders
    match /orders/{orderId} {
      allow read: if resource.data.vendorId == request.auth.uid;
      allow update: if resource.data.vendorId == request.auth.uid;
    }
  }
}
```

### Authentication
- JWT tokens (7-day and 30-day expiration)
- Secure token storage (flutter_secure_storage)
- Automatic token refresh
- Session management

### Data Protection
- Encrypted local storage
- HTTPS for all API calls
- Firebase security rules enforcement
- Rate limiting on endpoints

## 🔌 API Integration

### Base URL
```
Development: http://localhost:3000
Production: https://api.urban-tanker.com
```

### Key Endpoints
- `POST /api/auth/login` - Vendor login
- `POST /api/auth/register` - Vendor registration
- `GET /api/vendor/profile` - Get vendor profile
- `POST /api/vendor/orders/accept` - Accept order
- `PATCH /api/vendor/orders/:id/status` - Update order status
- `GET /api/vendor/inventory` - Get inventory
- `PATCH /api/vendor/inventory/:id` - Update inventory
- `GET /api/vendor/earnings` - Get earnings data

See [VENDOR_APP_DOCUMENTATION.md](./VENDOR_APP_DOCUMENTATION.md) for complete API reference.

## 🔄 Real-Time Features

### WebSocket Events
- Order updates (new, accepted, status changes)
- Driver location tracking
- Inventory synchronization
- Payment notifications

### Firebase Messaging
- Push notifications for new orders
- Alerts for low inventory
- Driver status updates
- Customer reviews and ratings

## 📊 State Management

Uses Provider pattern with ChangeNotifier:

```dart
Consumer<VendorAppState>(
  builder: (context, appState, child) {
    return Text('Pending: ${appState.getPendingOrdersCount()}');
  },
)
```

## 🧪 Testing

### Unit Tests
```bash
flutter test test/models/
```

### Widget Tests
```bash
flutter test test/widgets/
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 🚢 Deployment

### Android Play Store
1. Build app bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Configure store listing and screenshots
4. Submit for review

### iOS App Store
1. Build iOS app: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect
4. Configure app store information
5. Submit for review

## 🐛 Troubleshooting

### Firebase Initialization Issues
```bash
# Reconfigure Firebase
flutterfire configure

# Clear build cache
flutter clean
flutter pub get
```

### Location Permission Denied
- Check AndroidManifest.xml for permissions
- Verify iOS Info.plist descriptions
- Request runtime permissions using permission_handler

### Poppins Font Not Loading
```bash
# Ensure assets are in pubspec.yaml
# Verify font files exist in assets/fonts/
flutter pub get
flutter run
```

### WebSocket Connection Failed
- Verify server URL in constants
- Check network connectivity
- Review firewall settings

## 📚 Documentation

- [Complete Documentation](./VENDOR_APP_DOCUMENTATION.md) - Comprehensive guide
- [API Reference](./VENDOR_APP_DOCUMENTATION.md#api-integration) - Backend endpoints
- [Setup Guide](./VENDOR_APP_DOCUMENTATION.md#setup--installation) - Installation steps
- [Firebase Setup](./VENDOR_APP_DOCUMENTATION.md#firebase-setup) - Firebase configuration

## 🔄 Next Steps

### Phase 2: Additional Screens
- [ ] Orders Management (pending, active, completed)
- [ ] Inventory Management (add/update stock)
- [ ] Fleet Management (driver tracking)
- [ ] Earnings & Settlement
- [ ] Settings & Profile

### Phase 3: Backend Integration
- [ ] Connect to Express backend
- [ ] Implement WebSocket real-time updates
- [ ] Setup Firebase Cloud Functions
- [ ] Configure Cloud Messaging

### Phase 4: Advanced Features
- [ ] Maps integration (Google Maps)
- [ ] Driver tracking on map
- [ ] Route optimization
- [ ] Analytics dashboard
- [ ] Offline mode

## 📞 Support

### Common Issues
1. **Build Failures** - Run `flutter clean && flutter pub get`
2. **Permission Issues** - Check manifest files and request runtime permissions
3. **Firebase Issues** - Re-run `flutterfire configure`
4. **Network Issues** - Verify server URL and network connectivity

### Debugging
```bash
# Enable verbose logging
flutter run -v

# Run with Observatory for debugging
flutter run --observatory

# Check device logs
flutter logs
```

## 📝 Contributing

1. Create feature branch: `git checkout -b feature/new-feature`
2. Commit changes: `git commit -am 'Add new feature'`
3. Push to branch: `git push origin feature/new-feature`
4. Create Pull Request

## 📜 License

MIT License - See [LICENSE](./LICENSE) file

## 🎯 Version History

### v1.0.0 (Current)
- ✅ Dashboard with KPI metrics
- ✅ Order management (pending view)
- ✅ Inventory tracking
- ✅ Fleet status
- ✅ Earnings display
- ✅ Alerts and notifications
- ✅ Firebase integration setup
- ✅ Poppins design system
- ✅ Provider state management
- ✅ Responsive UI for all screen sizes

## 👥 Team

- **Project Lead**: Urban Tanker Team
- **Architecture**: Flutter & Firebase
- **Design System**: Consistent with web dashboards

## 📧 Contact

For support or questions:
- Email: support@urban-tanker.com
- GitHub Issues: [Report issue]
- Documentation: See VENDOR_APP_DOCUMENTATION.md

---

**Status**: 🟢 Development Ready  
**Last Updated**: 2026-08-28  
**Platform**: Flutter (Android/iOS)  
**Database**: Firebase Firestore
