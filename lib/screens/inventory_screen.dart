import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../providers/vendor_app_state.dart';
import '../widgets/vendor_widgets.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        elevation: 0,
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primary),
            onPressed: () => _showAddInventoryModal(context),
          ),
        ],
      ),
      body: Consumer<VendorAppState>(
        builder: (context, appState, _) {
          if (appState.inventory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: AppTheme.border,
                  ),
                  SizedBox(height: AppTheme.spacing4),
                  const Text(
                    'No Inventory Items',
                    style: TextStyle(
                      fontSize: AppTheme.fontLg,
                      fontWeight: AppTheme.fw700,
                      color: AppTheme.text,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing2),
                  const Text(
                    'Add inventory items to get started',
                    style: TextStyle(
                      fontSize: AppTheme.fontSm,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing5),
                  ElevatedButton.icon(
                    onPressed: () => _showAddInventoryModal(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Inventory'),
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
                  _buildInventorySummary(appState),
                  SizedBox(height: AppTheme.spacing5),
                  _buildInventoryList(context, appState),
                  SizedBox(height: AppTheme.spacing5),
                  _buildTransactionHistory(appState),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInventorySummary(VendorAppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            fontSize: AppTheme.fontLg,
            fontWeight: AppTheme.fw700,
            color: AppTheme.text,
          ),
        ),
        SizedBox(height: AppTheme.spacing3),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppTheme.spacing3,
          mainAxisSpacing: AppTheme.spacing3,
          childAspectRatio: 1.0,
          children: [
            _buildSummaryCard(
              'Total Stock',
              '${appState.inventory.fold<int>(0, (sum, inv) => sum + inv.currentStock)} L',
              AppTheme.primary,
            ),
            _buildSummaryCard(
              'Total Capacity',
              '${appState.inventory.fold<int>(0, (sum, inv) => sum + inv.maxCapacity)} L',
              AppTheme.secondary,
            ),
            _buildSummaryCard(
              'Avg Utilization',
              '${(appState.inventory.fold<double>(0.0, (sum, inv) => sum + inv.utilizationPercent) / appState.inventory.length).toStringAsFixed(1)}%',
              AppTheme.success,
            ),
            _buildSummaryCard(
              'Low Stock Items',
              '${appState.inventory.where((inv) => inv.isLowStock).length}',
              AppTheme.warning,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return VendorCard(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppTheme.fontXs,
                fontWeight: AppTheme.fw700,
                color: AppTheme.textMuted,
              ),
            ),
            SizedBox(height: AppTheme.spacing2),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTheme.fontLg,
                fontWeight: AppTheme.fw800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryList(BuildContext context, VendorAppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inventory by Service',
          style: TextStyle(
            fontSize: AppTheme.fontLg,
            fontWeight: AppTheme.fw700,
            color: AppTheme.text,
          ),
        ),
        SizedBox(height: AppTheme.spacing3),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appState.inventory.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: AppTheme.spacing2),
          itemBuilder: (context, index) {
            final inv = appState.inventory[index];
            final isLowStock = inv.isLowStock;

            return VendorCard(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with service name and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                inv.serviceType
                                    .replaceAll('_', ' ')
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: AppTheme.fontBase,
                                  fontWeight: AppTheme.fw700,
                                  color: AppTheme.text,
                                ),
                              ),
                              SizedBox(height: AppTheme.spacing1),
                              Text(
                                '${inv.currentStock}L / ${inv.maxCapacity}L',
                                style: const TextStyle(
                                  fontSize: AppTheme.fontXs,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isLowStock)
                          StatusBadge(
                            label: 'Low Stock',
                            status: 'bad',
                          )
                        else
                          StatusBadge(
                            label: '${inv.utilizationPercent.toStringAsFixed(0)}%',
                            status: 'ok',
                          ),
                      ],
                    ),

                    SizedBox(height: AppTheme.spacing3),

                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Capacity',
                              style: TextStyle(
                                fontSize: AppTheme.fontXs,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            Text(
                              '${inv.availableCapacity}L available',
                              style: const TextStyle(
                                fontSize: AppTheme.fontXs,
                                fontWeight: AppTheme.fw600,
                                color: AppTheme.text,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacing1),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusFull),
                          child: LinearProgressIndicator(
                            value: inv.utilizationPercent / 100,
                            minHeight: 8,
                            backgroundColor: AppTheme.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isLowStock ? AppTheme.warning : AppTheme.primary,
                            ),
                          ),
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
                              _showAddStockModal(context, inv.serviceType);
                            },
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add Stock'),
                          ),
                        ),
                        SizedBox(width: AppTheme.spacing2),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showUseStockModal(context, inv.serviceType);
                            },
                            icon: const Icon(Icons.remove, size: 18),
                            label: const Text('Use Stock'),
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
  }

  Widget _buildTransactionHistory(VendorAppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: AppTheme.fontLg,
            fontWeight: AppTheme.fw700,
            color: AppTheme.text,
          ),
        ),
        SizedBox(height: AppTheme.spacing3),
        VendorCard(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing3),
            child: Column(
              children: [
                _buildTransactionItem(
                  'Added RO Water',
                  '+5000L',
                  'Water Supply',
                  '2 hours ago',
                  true,
                ),
                Divider(height: AppTheme.spacing3, color: AppTheme.border),
                _buildTransactionItem(
                  'Used Purified Water',
                  '-2500L',
                  'Order UT-2026-1048',
                  '4 hours ago',
                  false,
                ),
                Divider(height: AppTheme.spacing3, color: AppTheme.border),
                _buildTransactionItem(
                  'Added Construction Water',
                  '+3000L',
                  'Supply Refill',
                  '6 hours ago',
                  true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String quantity,
    String reason,
    String time,
    bool isAdd,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isAdd
                  ? AppTheme.successLight
                  : const Color(0xFFFFEEE8),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(
              isAdd ? Icons.add : Icons.remove,
              color: isAdd ? AppTheme.success : AppTheme.warning,
              size: 20,
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
                    fontWeight: AppTheme.fw600,
                    color: AppTheme.text,
                  ),
                ),
                Text(
                  reason,
                  style: const TextStyle(
                    fontSize: AppTheme.fontXs,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                quantity,
                style: TextStyle(
                  fontSize: AppTheme.fontSm,
                  fontWeight: AppTheme.fw700,
                  color: isAdd ? AppTheme.success : AppTheme.danger,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: AppTheme.fontXs,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddInventoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _AddInventoryModal(),
      isScrollControlled: true,
    );
  }

  void _showAddStockModal(BuildContext context, String serviceType) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Stock - $serviceType'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Quantity in Liters',
                labelText: 'Stock Quantity',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(controller.text) ?? 0;
              if (quantity > 0) {
                context.read<VendorAppState>().updateInventory(
                  serviceType,
                  quantity,
                  'Manual addition',
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added $quantity L to $serviceType',
                    ),
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showUseStockModal(BuildContext context, String serviceType) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Use Stock - $serviceType'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Quantity in Liters',
                labelText: 'Stock Quantity',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(controller.text) ?? 0;
              if (quantity > 0) {
                context.read<VendorAppState>().updateInventory(
                  serviceType,
                  -quantity,
                  'Manual reduction',
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Used $quantity L from $serviceType',
                    ),
                  ),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _AddInventoryModal extends StatefulWidget {
  @override
  State<_AddInventoryModal> createState() => _AddInventoryModalState();
}

class _AddInventoryModalState extends State<_AddInventoryModal> {
  late TextEditingController _quantityController;
  String? _selectedService;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
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
              'Add Inventory',
              style: TextStyle(
                fontSize: AppTheme.fontLg,
                fontWeight: AppTheme.fw700,
                color: AppTheme.text,
              ),
            ),
            SizedBox(height: AppTheme.spacing4),
            const Text(
              'Service Type',
              style: TextStyle(
                fontSize: AppTheme.fontSm,
                fontWeight: AppTheme.fw600,
                color: AppTheme.text,
              ),
            ),
            SizedBox(height: AppTheme.spacing2),
            DropdownButton<String>(
              value: _selectedService,
              hint: const Text('Select service type'),
              isExpanded: true,
              items: serviceTypes.keys
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.replaceAll('_', ' ')),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedService = value),
            ),
            SizedBox(height: AppTheme.spacing4),
            const Text(
              'Quantity (Liters)',
              style: TextStyle(
                fontSize: AppTheme.fontSm,
                fontWeight: AppTheme.fw600,
                color: AppTheme.text,
              ),
            ),
            SizedBox(height: AppTheme.spacing2),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter quantity',
              ),
            ),
            SizedBox(height: AppTheme.spacing5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedService != null &&
                        _quantityController.text.isNotEmpty
                    ? () {
                        final quantity = int.tryParse(_quantityController.text);
                        if (quantity != null && quantity > 0) {
                          context.read<VendorAppState>().updateInventory(
                            _selectedService!,
                            quantity,
                            'Stock addition',
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added $quantity L of $_selectedService',
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Add to Inventory'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
