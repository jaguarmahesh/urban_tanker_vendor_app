import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/vendor_app_state.dart';
import '../widgets/vendor_widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Management'),
        elevation: 0,
        backgroundColor: AppTheme.surface,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textMuted,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingOrdersTab(),
          _buildActiveOrdersTab(),
          _buildCompletedOrdersTab(),
        ],
      ),
    );
  }

  Widget _buildPendingOrdersTab() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        final orders = appState.pendingOrders;

        if (orders.isEmpty) {
          return _buildEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No Pending Orders',
            message: 'All caught up! Check back soon.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacing4),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(context, orders[index], 'pending');
            },
          ),
        );
      },
    );
  }

  Widget _buildActiveOrdersTab() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        final orders = appState.activeOrders;

        if (orders.isEmpty) {
          return _buildEmptyState(
            icon: Icons.local_shipping_outlined,
            title: 'No Active Orders',
            message: 'No orders in progress.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacing4),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(context, orders[index], 'active');
            },
          ),
        );
      },
    );
  }

  Widget _buildCompletedOrdersTab() {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        final orders = appState.completedOrders;

        if (orders.isEmpty) {
          return _buildEmptyState(
            icon: Icons.check_circle_outline,
            title: 'No Completed Orders',
            message: 'Start accepting orders to complete them.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacing4),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(context, orders[index], 'completed');
            },
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    dynamic order,
    String type,
  ) {
    return VendorCard(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderId,
                      style: const TextStyle(
                        fontSize: AppTheme.fontSm,
                        fontWeight: AppTheme.fw700,
                        color: AppTheme.primary,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing1),
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        fontSize: AppTheme.fontBase,
                        fontWeight: AppTheme.fw600,
                        color: AppTheme.text,
                      ),
                    ),
                  ],
                ),
                StatusBadge(
                  label: order.status.replaceAll('_', ' ').toUpperCase(),
                  status: _getStatusType(order.status),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacing3),
            Divider(color: AppTheme.border, height: 1),
            SizedBox(height: AppTheme.spacing3),

            // Order Details
            _buildDetailRow('Service', order.serviceType.replaceAll('_', ' ')),
            _buildDetailRow('Capacity', '${order.capacity}L'),
            _buildDetailRow('Amount', '₹${order.amount.toStringAsFixed(0)}'),
            _buildDetailRow(
              'Location',
              order.deliveryAddress.length > 30
                  ? '${order.deliveryAddress.substring(0, 30)}...'
                  : order.deliveryAddress,
            ),

            if (order.assignedDriverId != null) ...[
              _buildDetailRow('Driver', order.assignedDriverName ?? 'N/A'),
              _buildDetailRow('Vehicle', order.vehicleNumber ?? 'N/A'),
            ],

            SizedBox(height: AppTheme.spacing3),

            // Action Buttons
            if (type == 'pending') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showRejectDialog(context, order);
                      },
                      child: const Text('Reject'),
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing2),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.verified_user, size: 16),
                      onPressed: () {
                        _showOtpAcceptDialog(context, order);
                      },
                      label: const Text('Accept with OTP'),
                    ),
                  ),
                ],
              ),
            ] else if (type == 'active') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showStatusDialog(context, order);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Update Status'),
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing2),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to map/tracking
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Track'),
                    ),
                  ),
                ],
              ),
            ] else if (type == 'completed') ...[
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing3),
                decoration: BoxDecoration(
                  color: AppTheme.successLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.success,
                          size: 20,
                        ),
                        SizedBox(width: AppTheme.spacing2),
                        Text(
                          'Order Completed',
                          style: TextStyle(
                            fontSize: AppTheme.fontSm,
                            fontWeight: AppTheme.fw700,
                            color: AppTheme.success,
                          ),
                        ),
                      ],
                    ),
                    if (order.rating != null) ...[
                      SizedBox(height: AppTheme.spacing2),
                      Text(
                        'Rating: ★ ${order.rating}',
                        style: const TextStyle(
                          fontSize: AppTheme.fontXs,
                          color: AppTheme.success,
                        ),
                      ),
                      if (order.review != null) ...[
                        SizedBox(height: AppTheme.spacing1),
                        Text(
                          'Review: ${order.review}',
                          style: const TextStyle(
                            fontSize: AppTheme.fontXs,
                            color: AppTheme.textMuted,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTheme.fontXs,
              color: AppTheme.textMuted,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: AppTheme.fontXs,
                fontWeight: AppTheme.fw600,
                color: AppTheme.text,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.border,
          ),
          SizedBox(height: AppTheme.spacing4),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppTheme.fontLg,
              fontWeight: AppTheme.fw700,
              color: AppTheme.text,
            ),
          ),
          SizedBox(height: AppTheme.spacing2),
          Text(
            message,
            style: const TextStyle(
              fontSize: AppTheme.fontSm,
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStatusType(String status) {
    switch (status) {
      case 'requested':
      case 'onTheWay':
        return 'wait';
      case 'accepted':
        return 'info';
      case 'completed':
        return 'ok';
      case 'cancelled':
        return 'bad';
      default:
        return 'info';
    }
  }

  void _showRejectDialog(BuildContext context, dynamic order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Order?'),
        content: Text('Are you sure you want to reject order ${order.orderId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order ${order.orderId} rejected')),
              );
            },
            child: const Text('Reject'),
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

  void _showStatusDialog(BuildContext context, dynamic order) {
    const statusOptions = [
      'accepted',
      'onTheWay',
      'unloading',
      'completed',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statusOptions
              .map((status) => ListTile(
                    title: Text(status.replaceAll('_', ' ').toUpperCase()),
                    onTap: () {
                      context
                          .read<VendorAppState>()
                          .updateOrderStatus(order.orderId, status);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order status updated to $status'),
                        ),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
