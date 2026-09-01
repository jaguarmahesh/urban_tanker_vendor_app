import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/vendor_app_state.dart';
import '../widgets/vendor_widgets.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({Key? key}) : super(key: key);

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fleet Management'),
        elevation: 0,
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primary),
            onPressed: () => _showAddDriverModal(context),
          ),
        ],
      ),
      body: Consumer<VendorAppState>(
        builder: (context, appState, _) {
          if (appState.drivers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 64,
                    color: AppTheme.border,
                  ),
                  SizedBox(height: AppTheme.spacing4),
                  const Text(
                    'No Drivers Added',
                    style: TextStyle(
                      fontSize: AppTheme.fontLg,
                      fontWeight: AppTheme.fw700,
                      color: AppTheme.text,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing2),
                  const Text(
                    'Add drivers to manage your fleet',
                    style: TextStyle(
                      fontSize: AppTheme.fontSm,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing5),
                  ElevatedButton.icon(
                    onPressed: () => _showAddDriverModal(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Driver'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // TODO: Implement refresh
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFleetSummary(appState),
                  SizedBox(height: AppTheme.spacing5),
                  _buildFilterButtons(),
                  SizedBox(height: AppTheme.spacing3),
                  _buildDriversList(context, appState),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFleetSummary(VendorAppState appState) {
    final onTrip = appState.drivers.where((d) => d.status == 'on_trip').length;
    final available = appState.drivers.where((d) => d.status == 'available').length;
    final offline = appState.drivers.where((d) => d.status == 'offline').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fleet Status',
          style: TextStyle(
            fontSize: AppTheme.fontLg,
            fontWeight: AppTheme.fw700,
            color: AppTheme.text,
          ),
        ),
        SizedBox(height: AppTheme.spacing3),
        VendorCard(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusSummary(
                  'On Trip',
                  onTrip.toString(),
                  AppTheme.primary,
                  Icons.navigation,
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: AppTheme.border,
                ),
                _buildStatusSummary(
                  'Available',
                  available.toString(),
                  AppTheme.success,
                  Icons.check_circle,
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: AppTheme.border,
                ),
                _buildStatusSummary(
                  'Offline',
                  offline.toString(),
                  AppTheme.textMuted,
                  Icons.offline_bolt,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSummary(
    String label,
    String count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: AppTheme.spacing2),
            Text(
              count,
              style: TextStyle(
                fontSize: AppTheme.fontLg,
                fontWeight: AppTheme.fw800,
                color: color,
              ),
            ),
            SizedBox(height: AppTheme.spacing1),
            Text(
              label,
              style: const TextStyle(
                fontSize: AppTheme.fontXs,
                color: AppTheme.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterButton('All', 'all'),
          SizedBox(width: AppTheme.spacing2),
          _buildFilterButton('On Trip', 'on_trip'),
          SizedBox(width: AppTheme.spacing2),
          _buildFilterButton('Available', 'available'),
          SizedBox(width: AppTheme.spacing2),
          _buildFilterButton('Offline', 'offline'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isActive = _filterStatus == value;
    return ElevatedButton(
      onPressed: () => setState(() => _filterStatus = value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppTheme.primary : AppTheme.surface,
        side: BorderSide(
          color: isActive ? AppTheme.primary : AppTheme.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AppTheme.textMuted,
          fontWeight: AppTheme.fw600,
        ),
      ),
    );
  }

  Widget _buildDriversList(BuildContext context, VendorAppState appState) {
    final drivers = _filterStatus == 'all'
        ? appState.drivers
        : appState.drivers.where((d) => d.status == _filterStatus).toList();

    if (drivers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing4),
          child: Column(
            children: [
              const Icon(
                Icons.person_off_outlined,
                size: 48,
                color: AppTheme.border,
              ),
              SizedBox(height: AppTheme.spacing3),
              const Text(
                'No drivers with this status',
                style: TextStyle(
                  fontSize: AppTheme.fontSm,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drivers.length,
      separatorBuilder: (context, index) => SizedBox(height: AppTheme.spacing2),
      itemBuilder: (context, index) {
        final driver = drivers[index];
        return _buildDriverCard(context, driver);
      },
    );
  }

  Widget _buildDriverCard(BuildContext context, dynamic driver) {
    return VendorCard(
      onTap: () => _showDriverDetails(context, driver),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: const TextStyle(
                          fontSize: AppTheme.fontBase,
                          fontWeight: AppTheme.fw700,
                          color: AppTheme.text,
                        ),
                      ),
                      SizedBox(height: AppTheme.spacing1),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          SizedBox(width: AppTheme.spacing1),
                          Text(
                            driver.phone,
                            style: const TextStyle(
                              fontSize: AppTheme.fontXs,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
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
                    driver.status.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(
                      fontSize: AppTheme.fontXs,
                      fontWeight: AppTheme.fw700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacing3),
            Divider(color: AppTheme.border, height: 1),
            SizedBox(height: AppTheme.spacing3),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Rating', '★ ${driver.rating}'),
                _buildStatItem('Deliveries', '${driver.totalDeliveries}'),
                _buildStatItem(
                  'License',
                  driver.licenseExpiry.substring(0, 10),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacing3),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Call driver
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling ${driver.name}...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call'),
                  ),
                ),
                SizedBox(width: AppTheme.spacing2),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: View on map
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${driver.name} location...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.location_on, size: 18),
                    label: const Text('Track'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTheme.fontXs,
            color: AppTheme.textMuted,
          ),
        ),
        SizedBox(height: AppTheme.spacing1),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppTheme.fontSm,
            fontWeight: AppTheme.fw700,
            color: AppTheme.text,
          ),
        ),
      ],
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

  void _showAddDriverModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _AddDriverModal(),
      isScrollControlled: true,
    );
  }

  void _showDriverDetails(BuildContext context, dynamic driver) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Details',
              style: TextStyle(
                fontSize: AppTheme.fontLg,
                fontWeight: AppTheme.fw700,
                color: AppTheme.text,
              ),
            ),
            SizedBox(height: AppTheme.spacing4),
            _buildDetailRow('Name', driver.name),
            _buildDetailRow('Phone', driver.phone),
            _buildDetailRow('License Number', driver.licenseNumber),
            _buildDetailRow('License Expiry', driver.licenseExpiry),
            _buildDetailRow('Rating', '★ ${driver.rating}'),
            _buildDetailRow('Total Deliveries', '${driver.totalDeliveries}'),
            _buildDetailRow('Status', driver.status.replaceAll('_', ' ')),
            _buildDetailRow('Active', driver.isActive ? 'Yes' : 'No'),
            SizedBox(height: AppTheme.spacing5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
            value,
            style: const TextStyle(
              fontSize: AppTheme.fontSm,
              fontWeight: AppTheme.fw600,
              color: AppTheme.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddDriverModal extends StatefulWidget {
  @override
  State<_AddDriverModal> createState() => _AddDriverModalState();
}

class _AddDriverModalState extends State<_AddDriverModal> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _licenseController;
  late TextEditingController _expiryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _licenseController = TextEditingController();
    _expiryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: AppTheme.spacing4,
          right: AppTheme.spacing4,
          top: AppTheme.spacing4,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spacing4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Driver',
              style: TextStyle(
                fontSize: AppTheme.fontLg,
                fontWeight: AppTheme.fw700,
                color: AppTheme.text,
              ),
            ),
            SizedBox(height: AppTheme.spacing4),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Driver Name',
                hintText: 'Enter driver name',
              ),
            ),
            SizedBox(height: AppTheme.spacing3),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
              ),
            ),
            SizedBox(height: AppTheme.spacing3),
            TextField(
              controller: _licenseController,
              decoration: const InputDecoration(
                labelText: 'License Number',
                hintText: 'Enter license number',
              ),
            ),
            SizedBox(height: AppTheme.spacing3),
            TextField(
              controller: _expiryController,
              decoration: const InputDecoration(
                labelText: 'License Expiry Date',
                hintText: 'YYYY-MM-DD',
              ),
            ),
            SizedBox(height: AppTheme.spacing5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nameController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty &&
                        _licenseController.text.isNotEmpty &&
                        _expiryController.text.isNotEmpty
                    ? () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Driver ${_nameController.text} added successfully',
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Add Driver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
