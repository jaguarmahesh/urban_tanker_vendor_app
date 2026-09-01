import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../providers/vendor_app_state.dart';
import '../widgets/vendor_widgets.dart';
import '../widgets/notifications_modal_sheet.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({Key? key}) : super(key: key);

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    if (mounted) {
      await context.read<VendorAppState>().loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<VendorAppState>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context, appState),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTenantHeaderCard(appState),
              const SizedBox(height: 12),
              if (appState.isGpsBroadcasting)
                _buildLiveGpsBroadcastBanner(appState),
              _buildWelcomeSection(),
              SizedBox(height: AppTheme.spacing5),
              _buildKPICards(),
              SizedBox(height: AppTheme.spacing5),
              _buildPendingOrdersSection(),
              SizedBox(height: AppTheme.spacing5),
              _buildEarningsSection(),
              SizedBox(height: AppTheme.spacing5),
              _buildInventorySection(),
              SizedBox(height: AppTheme.spacing5),
              _buildFleetSection(),
              SizedBox(height: AppTheme.spacing5),
              _buildAlertSection(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, VendorAppState appState) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vendor Operations', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          Text(
            appState.currentClient?.name ?? 'Distributed Multi-Customer App',
            style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: AppTheme.surface,
      actions: [
        // Live GPS Share Button
        IconButton(
          tooltip: 'Share Current GPS Location',
          icon: const Icon(Icons.my_location, color: AppTheme.primary),
          onPressed: () async {
            final loc = await appState.shareCurrentLocation('Manual On-Demand Check-in');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'GPS Broadcasted: ${loc["latitude"].toStringAsFixed(4)}, ${loc["longitude"].toStringAsFixed(4)}',
                ),
                backgroundColor: AppTheme.success,
              ),
            );
          },
        ),
        // Notifications Bottom Sheet Trigger
        IconButton(
          tooltip: 'Update Notifications',
          icon: Badge(
            label: Text(appState.unreadNotifications.toString()),
            isLabelVisible: appState.unreadNotifications > 0,
            child: const Icon(Icons.notifications_outlined, color: AppTheme.text),
          ),
          onPressed: () {
            NotificationsModalSheet.show(context);
          },
        ),
        IconButton(
          tooltip: 'Logout',
          icon: const Icon(Icons.logout, color: AppTheme.textMuted),
          onPressed: () => appState.logout(),
        ),
      ],
    );
  }

  Widget _buildTenantHeaderCard(VendorAppState appState) {
    final client = appState.currentClient;
    if (client == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: client.accentColor,
            radius: 8,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Client Environment: ${client.name}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text,
                  ),
                ),
                Text(
                  'Code: ${client.clientCode} • ${client.location.split(",")[0]} • Support: ${client.supportPhone}',
                  style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.successLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'AES-256',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveGpsBroadcastBanner(VendorAppState appState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Live GPS Tracking active for order ${appState.activeTrackingOrderId ?? "Active"}. Coordinates streaming to customer.',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E40AF),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 24),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => appState.shareCurrentLocation('Manual Sync'),
            child: const Text('Share GPS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${appState.currentUser?.ownerName ?? "Vendor"}!',
              style: const TextStyle(
                fontSize: AppTheme.font2xl,
                fontWeight: AppTheme.fw800,
                color: AppTheme.text,
              ),
            ),
            SizedBox(height: AppTheme.spacing1),
            Text(
              'Manage your orders, inventory & fleet',
              style: const TextStyle(
                fontSize: AppTheme.fontBase,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPICards() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppTheme.spacing3,
          mainAxisSpacing: AppTheme.spacing3,
          childAspectRatio: 1.0,
          children: [
            MetricCard(
              label: 'Pending Requests',
              value: appState.getPendingOrdersCount().toString(),
              trend: 'Awaiting action',
              trendUp: true,
              color: AppTheme.warning,
            ),
            MetricCard(
              label: 'Active Orders',
              value: appState.getActiveOrdersCount().toString(),
              trend: 'In progress',
              trendUp: true,
              color: AppTheme.primary,
            ),
            MetricCard(
              label: "Today's Earnings",
              value: '₹${appState.earnings?.todayEarnings.toStringAsFixed(0) ?? "0"}',
              trend: '7.2% vs yesterday',
              trendUp: true,
              color: AppTheme.success,
            ),
            MetricCard(
              label: 'Inventory Status',
              value: '89%',
              trend: 'Stock available',
              trendUp: true,
              color: AppTheme.primary,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingOrdersSection() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Pending Order Requests', 'Action Required'),
            SizedBox(height: AppTheme.spacing3),
            if (appState.pendingOrders.isEmpty)
              VendorCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing5),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: AppTheme.border,
                        ),
                        SizedBox(height: AppTheme.spacing3),
                        const Text(
                          'No pending orders',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: AppTheme.fontBase,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appState.pendingOrders.length,
                separatorBuilder: (context, index) => SizedBox(height: AppTheme.spacing2),
                itemBuilder: (context, index) {
                  final order = appState.pendingOrders[index];
                  return VendorCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.orderId,
                                style: const TextStyle(
                                  fontSize: AppTheme.fontSm,
                                  fontWeight: AppTheme.fw700,
                                  color: AppTheme.primary,
                                ),
                              ),
                              Text(
                                '₹${order.amount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: AppTheme.fontBase,
                                  fontWeight: AppTheme.fw700,
                                  color: AppTheme.text,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppTheme.spacing1),
                          Text(
                            '${order.customerName} • ${order.serviceType}',
                            style: const TextStyle(
                              fontSize: AppTheme.fontSm,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          SizedBox(height: AppTheme.spacing2),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text('Reject'),
                                ),
                              ),
                              SizedBox(width: AppTheme.spacing2),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.security, size: 15),
                                  onPressed: () {
                                    _showOtpAcceptDialog(context, order);
                                  },
                                  label: const Text('Accept with OTP'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildEarningsSection() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        final earnings = appState.earnings;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Today's Earnings", 'Real-time'),
            SizedBox(height: AppTheme.spacing3),
            VendorCard(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing4),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppTheme.primary, AppTheme.secondary],
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Today's Total",
                            style: TextStyle(
                              fontSize: AppTheme.fontSm,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: AppTheme.spacing2),
                          Text(
                            '₹${earnings?.todayEarnings.toStringAsFixed(0) ?? "0"}',
                            style: const TextStyle(
                              fontSize: AppTheme.font2xl,
                              fontWeight: AppTheme.fw800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: AppTheme.spacing1),
                          const Text(
                            '▲ 7.2% vs yesterday',
                            style: TextStyle(
                              fontSize: AppTheme.fontXs,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing4),
                    Column(
                      children: [
                        _buildEarningsRow('Completed Orders', '₹1800'),
                        Divider(height: AppTheme.spacing4, color: AppTheme.border),
                        _buildEarningsRow('Pending Settlement', '₹650'),
                        Divider(height: AppTheme.spacing4, color: AppTheme.border),
                        _buildEarningsRow('Commission Deducted', '-₹280', negative: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEarningsRow(String label, String amount, {bool negative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTheme.fontSm,
              color: AppTheme.textMuted,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: AppTheme.fontBase,
              fontWeight: AppTheme.fw700,
              color: negative ? AppTheme.danger : AppTheme.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Inventory Status', 'Current Stock'),
            SizedBox(height: AppTheme.spacing3),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appState.inventory.length,
              separatorBuilder: (context, index) => SizedBox(height: AppTheme.spacing2),
              itemBuilder: (context, index) {
                final inv = appState.inventory[index];
                return VendorCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              inv.serviceType.replaceAll('_', ' ').toUpperCase(),
                              style: const TextStyle(
                                fontSize: AppTheme.fontSm,
                                fontWeight: AppTheme.fw700,
                                color: AppTheme.text,
                              ),
                            ),
                            Text(
                              '${inv.utilizationPercent.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: AppTheme.fontBase,
                                fontWeight: AppTheme.fw700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacing1),
                        Text(
                          '${inv.currentStock} L / ${inv.maxCapacity} L',
                          style: const TextStyle(
                            fontSize: AppTheme.fontXs,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing2),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          child: LinearProgressIndicator(
                            value: inv.utilizationPercent / 100,
                            minHeight: 6,
                            backgroundColor: AppTheme.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              inv.isLowStock ? AppTheme.warning : AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFleetSection() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Fleet Status', 'Active Drivers'),
            SizedBox(height: AppTheme.spacing3),
            VendorCard(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing3),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildFleetStat(
                            '${appState.drivers.where((d) => d.status == 'on_trip').length}',
                            'On Trip',
                          ),
                        ),
                        Expanded(
                          child: _buildFleetStat(
                            '${appState.drivers.where((d) => d.status == 'available').length}',
                            'Available',
                          ),
                        ),
                        Expanded(
                          child: _buildFleetStat(
                            '${appState.drivers.where((d) => d.status == 'offline').length}',
                            'Offline',
                          ),
                        ),
                      ],
                    ),
                    Divider(height: AppTheme.spacing4, color: AppTheme.border),
                    ...appState.drivers.map((driver) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver.name,
                                  style: const TextStyle(
                                    fontSize: AppTheme.fontSm,
                                    fontWeight: AppTheme.fw600,
                                  ),
                                ),
                                Text(
                                  driver.status.replaceAll('_', ' '),
                                  style: const TextStyle(
                                    fontSize: AppTheme.fontXs,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing2,
                              vertical: AppTheme.spacing1,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(driver.status),
                              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                            ),
                            child: Text(
                              '★ ${driver.rating}',
                              style: const TextStyle(
                                fontSize: AppTheme.fontXs,
                                fontWeight: AppTheme.fw600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFleetStat(String count, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: AppTheme.fontLg,
              fontWeight: AppTheme.fw800,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(height: AppTheme.spacing1),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTheme.fontXs,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'on_trip':
        return AppTheme.primary;
      case 'available':
        return AppTheme.success;
      case 'offline':
        return AppTheme.textMuted;
      default:
        return AppTheme.textMuted;
    }
  }

  Widget _buildAlertSection() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        final hasLowStock = appState.hasLowStockAlerts();
        
        if (!hasLowStock && appState.pendingOrders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Alerts', 'Important'),
            SizedBox(height: AppTheme.spacing3),
            VendorCard(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasLowStock)
                      _buildAlertItem(
                        '⚠ Low Stock Warning',
                        'RO Water below 30%',
                        AppTheme.warning,
                      ),
                    if (appState.pendingOrders.isNotEmpty) ...[
                      if (hasLowStock)
                        Divider(height: AppTheme.spacing3, color: AppTheme.border),
                      _buildAlertItem(
                        'ℹ Pending Orders',
                        '${appState.pendingOrders.length} order(s) awaiting response',
                        AppTheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlertItem(String title, String message, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: AppTheme.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSm,
                    fontWeight: AppTheme.fw700,
                    color: AppTheme.text,
                  ),
                ),
                SizedBox(height: AppTheme.spacing1),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: AppTheme.fontXs,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOtpAcceptDialog(BuildContext context, dynamic order) {
    final otpController = TextEditingController();
    const demoOtp = '849201';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.security, color: AppTheme.primary),
                SizedBox(width: 8),
                Text('Order Acceptance OTP'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer: ${order.customerName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Order: ${order.orderId} • ₹${order.amount.toStringAsFixed(0)}'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.infoLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.info.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Demo OTP: 849201',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.info),
                        ),
                        TextButton(
                          onPressed: () {
                            otpController.text = demoOtp;
                            setDialogState(() {});
                          },
                          child: const Text('Auto-Fill'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Enter 6-Digit OTP',
                      border: OutlineInputBorder(),
                      hintText: '849201',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, size: 16),
                onPressed: () {
                  final entered = otpController.text.trim();
                  if (entered.length < 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter valid confirmation OTP')),
                    );
                    return;
                  }
                  Navigator.pop(dialogCtx);
                  context.read<VendorAppState>().acceptOrder(order.orderId, entered);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order ${order.orderId} verified with OTP [$entered] and accepted!'),
                      backgroundColor: AppTheme.success,
                    ),
                  );
                },
                label: const Text('Verify & Accept'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: AppTheme.fontLg,
                fontWeight: AppTheme.fw700,
                color: AppTheme.text,
              ),
            ),
            SizedBox(height: AppTheme.spacing1),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: AppTheme.fontXs,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
