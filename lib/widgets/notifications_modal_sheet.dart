import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/notification_model.dart';
import '../providers/vendor_app_state.dart';

class NotificationsModalSheet extends StatefulWidget {
  const NotificationsModalSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationsModalSheet(),
    );
  }

  @override
  State<NotificationsModalSheet> createState() => _NotificationsModalSheetState();
}

class _NotificationsModalSheetState extends State<NotificationsModalSheet> {
  String _selectedCategory = 'all';
  bool _unreadOnly = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorAppState>(
      builder: (context, appState, _) {
        final allNotifs = appState.notifications;
        final filteredNotifs = allNotifs.filter((n) {
          if (_selectedCategory != 'all' && n.category != _selectedCategory) {
            return false;
          }
          if (_unreadOnly && n.read) {
            return false;
          }
          return true;
        }).toList();

        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Modal Grab Handle & Header
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.notifications_active, color: AppTheme.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Update Notifications',
                              style: TextStyle(
                                fontSize: AppTheme.fontBase,
                                fontWeight: AppTheme.fw700,
                                color: AppTheme.text,
                              ),
                            ),
                            Text(
                              '${appState.unreadNotifications} unread alerts',
                              style: const TextStyle(
                                fontSize: AppTheme.fontXs,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (appState.unreadNotifications > 0)
                      TextButton.icon(
                        icon: const Icon(Icons.done_all, size: 16),
                        label: const Text('Mark All Read', style: TextStyle(fontSize: 12)),
                        onPressed: () => appState.markAllNotificationsRead(),
                      ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('all', 'All'),
                    _buildFilterChip('order', 'Orders'),
                    _buildFilterChip('fleet', 'Fleet & GPS'),
                    _buildFilterChip('inventory', 'Inventory'),
                    _buildFilterChip('billing', 'Billing'),
                    _buildFilterChip('system', 'System'),
                  ],
                ),
              ),

              // Notifications List
              Expanded(
                child: filteredNotifs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none, size: 54, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'No notifications found',
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMuted),
                            ),
                            const Text(
                              'You are all caught up with your client feed.',
                              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredNotifs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = filteredNotifs[index];
                          return _buildNotificationCard(context, item, appState);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedCategory == key;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppTheme.text,
          ),
        ),
        selectedColor: AppTheme.primary,
        backgroundColor: Colors.grey.shade100,
        checkmarkColor: Colors.white,
        onSelected: (val) {
          setState(() {
            _selectedCategory = key;
          });
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem item,
    VendorAppState appState,
  ) {
    Color cardBorder;
    Color iconBg;
    IconData icon;

    switch (item.severity) {
      case 'critical':
        cardBorder = AppTheme.error;
        iconBg = AppTheme.errorLight;
        icon = Icons.error_outline;
        break;
      case 'warning':
        cardBorder = AppTheme.warning;
        iconBg = AppTheme.warningLight;
        icon = Icons.warning_amber_rounded;
        break;
      case 'success':
        cardBorder = AppTheme.success;
        iconBg = AppTheme.successLight;
        icon = Icons.check_circle_outline;
        break;
      default:
        cardBorder = AppTheme.primary;
        iconBg = AppTheme.primaryLight;
        icon = Icons.info_outline;
        break;
    }

    return InkWell(
      onTap: () {
        if (!item.read) {
          appState.markNotificationRead(item.id);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.read ? Colors.white : Colors.blue.shade50.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.read ? Colors.grey.shade200 : cardBorder.withOpacity(0.6),
            width: item.read ? 1 : 1.5,
          ),
          boxShadow: item.read
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: cardBorder, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: AppTheme.fontSm,
                            fontWeight: item.read ? FontWeight.w600 : FontWeight.bold,
                            color: AppTheme.text,
                          ),
                        ),
                      ),
                      Text(
                        item.timestamp,
                        style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: const TextStyle(
                      fontSize: AppTheme.fontXs,
                      color: AppTheme.textMuted,
                      height: 1.35,
                    ),
                  ),
                  if (item.actionLabel != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: const Size(60, 26),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          appState.markNotificationRead(item.id);
                          Navigator.pop(context);
                        },
                        child: Text(
                          item.actionLabel!,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _ListFilter<T> on List<T> {
  Iterable<T> filter(bool Function(T) test) {
    return where(test);
  }
}
