import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/app_constants.dart';
import 'providers/vendor_app_state.dart';
import 'screens/vendor_dashboard_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/fleet_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/single_column_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const VendorApp());
}

class VendorApp extends StatelessWidget {
  const VendorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VendorAppState()..initializeAppState(),
        ),
      ],
      child: MaterialApp(
        title: appName,
        theme: AppTheme.lightTheme,
        home: const VendorHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({Key? key}) : super(key: key);

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        if (!appState.isLoggedIn) {
          return const SingleColumnLoginScreen();
        }

        return Scaffold(
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const VendorDashboardScreen();
      case 1:
        return const OrdersScreen();
      case 2:
        return const InventoryScreen();
      case 3:
        return const FleetScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const VendorDashboardScreen();
    }
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.surface,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: AppTheme.textMuted,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          activeIcon: Icon(Icons.assignment),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping_outlined),
          activeIcon: Icon(Icons.local_shipping),
          label: 'Fleet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}


