class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String category; // 'order', 'fleet', 'inventory', 'billing', 'system'
  final String severity; // 'critical', 'warning', 'success', 'info'
  final String timestamp;
  final bool read;
  final String? actionLabel;
  final String? actionType;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.severity,
    required this.timestamp,
    this.read = false,
    this.actionLabel,
    this.actionType,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? category,
    String? severity,
    String? timestamp,
    bool? read,
    String? actionLabel,
    String? actionType,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
      actionLabel: actionLabel ?? this.actionLabel,
      actionType: actionType ?? this.actionType,
    );
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      category: map['category'] ?? 'system',
      severity: map['severity'] ?? 'info',
      timestamp: map['timestamp'] ?? '',
      read: map['read'] == 1 || map['read'] == true,
      actionLabel: map['action_label'] ?? map['actionLabel'],
      actionType: map['action_type'] ?? map['actionType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'category': category,
      'severity': severity,
      'timestamp': timestamp,
      'read': read ? 1 : 0,
      'action_label': actionLabel,
      'action_type': actionType,
    };
  }
}
