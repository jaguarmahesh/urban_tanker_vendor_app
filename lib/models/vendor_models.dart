class VendorUser {
  final String id;
  final String businessName;
  final String ownerName;
  final String email;
  final String phone;
  final String profilePhoto;
  final String businessRegistration;
  final String taxId;
  final String licenseNumber;
  final String address;
  final double latitude;
  final double longitude;
  final String serviceArea;
  final List<String> serviceTypes;
  final List<String> deviceTokens;
  final bool isVerified;
  final bool isActive;
  final int totalOrders;
  final double totalEarnings;
  final double rating;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;

  VendorUser({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.phone,
    this.profilePhoto = '',
    this.businessRegistration = '',
    this.taxId = '',
    this.licenseNumber = '',
    this.address = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.serviceArea = '',
    this.serviceTypes = const [],
    this.deviceTokens = const [],
    this.isVerified = false,
    this.isActive = true,
    this.totalOrders = 0,
    this.totalEarnings = 0.0,
    this.rating = 0.0,
    required this.createdAt,
    this.lastUpdatedAt,
  });

  factory VendorUser.fromJson(Map<String, dynamic> json) {
    return VendorUser(
      id: json['_id'] ?? '',
      businessName: json['businessName'] ?? '',
      ownerName: json['ownerName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
      businessRegistration: json['businessRegistration'] ?? '',
      taxId: json['taxId'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['location']?['coordinates']?[1] ?? 0.0).toDouble(),
      longitude: (json['location']?['coordinates']?[0] ?? 0.0).toDouble(),
      serviceArea: json['serviceArea'] ?? '',
      serviceTypes: List<String>.from(json['serviceTypes'] ?? []),
      deviceTokens: List<String>.from(json['deviceTokens'] ?? []),
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      totalOrders: json['totalOrders'] ?? 0,
      totalEarnings: (json['totalEarnings'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastUpdatedAt: json['lastUpdatedAt'] != null ? DateTime.parse(json['lastUpdatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'businessName': businessName,
    'ownerName': ownerName,
    'email': email,
    'phone': phone,
    'profilePhoto': profilePhoto,
    'businessRegistration': businessRegistration,
    'taxId': taxId,
    'licenseNumber': licenseNumber,
    'address': address,
    'location': {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    },
    'serviceArea': serviceArea,
    'serviceTypes': serviceTypes,
    'deviceTokens': deviceTokens,
    'isVerified': isVerified,
    'isActive': isActive,
    'totalOrders': totalOrders,
    'totalEarnings': totalEarnings,
    'rating': rating,
    'createdAt': createdAt.toIso8601String(),
    'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
  };
}

class VendorOrder {
  final String id;
  final String orderId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String serviceType;
  final int capacity;
  final String status;
  final double amount;
  final double commission;
  final double netEarnings;
  final String paymentMethod;
  final bool isPaid;
  final String? assignedDriverId;
  final String? assignedDriverName;
  final String? vehicleNumber;
  final double? rating;
  final String? review;
  final DateTime requestedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final List<String> statusHistory;

  VendorOrder({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    this.deliveryLatitude = 0.0,
    this.deliveryLongitude = 0.0,
    required this.serviceType,
    required this.capacity,
    this.status = 'requested',
    this.amount = 0.0,
    this.commission = 0.0,
    this.netEarnings = 0.0,
    this.paymentMethod = 'Cash',
    this.isPaid = false,
    this.assignedDriverId,
    this.assignedDriverName,
    this.vehicleNumber,
    this.rating,
    this.review,
    required this.requestedAt,
    this.acceptedAt,
    this.completedAt,
    this.statusHistory = const [],
  });

  factory VendorOrder.fromJson(Map<String, dynamic> json) {
    return VendorOrder(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      deliveryLatitude: (json['deliveryLocation']?['coordinates']?[1] ?? 0.0).toDouble(),
      deliveryLongitude: (json['deliveryLocation']?['coordinates']?[0] ?? 0.0).toDouble(),
      serviceType: json['serviceType'] ?? '',
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? 'requested',
      amount: (json['amount'] ?? 0.0).toDouble(),
      commission: (json['commission'] ?? 0.0).toDouble(),
      netEarnings: (json['netEarnings'] ?? 0.0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      isPaid: json['isPaid'] ?? false,
      assignedDriverId: json['assignedDriver']?['_id'],
      assignedDriverName: json['assignedDriver']?['name'],
      vehicleNumber: json['vehicle']?['number'],
      rating: json['rating']?.toDouble(),
      review: json['review'],
      requestedAt: DateTime.parse(json['requestedAt'] ?? DateTime.now().toIso8601String()),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      statusHistory: List<String>.from(json['statusHistory'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'orderId': orderId,
    'customerId': customerId,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'deliveryAddress': deliveryAddress,
    'deliveryLocation': {
      'type': 'Point',
      'coordinates': [deliveryLongitude, deliveryLatitude],
    },
    'serviceType': serviceType,
    'capacity': capacity,
    'status': status,
    'amount': amount,
    'commission': commission,
    'netEarnings': netEarnings,
    'paymentMethod': paymentMethod,
    'isPaid': isPaid,
    'requestedAt': requestedAt.toIso8601String(),
    'acceptedAt': acceptedAt?.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'statusHistory': statusHistory,
  };
}

class VendorInventory {
  final String id;
  final String vendorId;
  final String serviceType;
  final int totalCapacity;
  final int currentStock;
  final int minThreshold;
  final int maxCapacity;
  final List<InventoryTransaction> transactions;
  final DateTime lastUpdatedAt;

  VendorInventory({
    required this.id,
    required this.vendorId,
    required this.serviceType,
    required this.totalCapacity,
    required this.currentStock,
    this.minThreshold = 0,
    required this.maxCapacity,
    this.transactions = const [],
    required this.lastUpdatedAt,
  });

  int get availableCapacity => maxCapacity - currentStock;
  double get utilizationPercent => (currentStock / maxCapacity) * 100;
  bool get isLowStock => currentStock < minThreshold;

  factory VendorInventory.fromJson(Map<String, dynamic> json) {
    return VendorInventory(
      id: json['_id'] ?? '',
      vendorId: json['vendorId'] ?? '',
      serviceType: json['serviceType'] ?? '',
      totalCapacity: json['totalCapacity'] ?? 0,
      currentStock: json['currentStock'] ?? 0,
      minThreshold: json['minThreshold'] ?? 0,
      maxCapacity: json['maxCapacity'] ?? 0,
      transactions: (json['transactions'] as List?)?.map((t) => InventoryTransaction.fromJson(t)).toList() ?? [],
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'vendorId': vendorId,
    'serviceType': serviceType,
    'totalCapacity': totalCapacity,
    'currentStock': currentStock,
    'minThreshold': minThreshold,
    'maxCapacity': maxCapacity,
    'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
  };
}

class InventoryTransaction {
  final String id;
  final String type; // 'add', 'use', 'waste'
  final int quantity;
  final String reason;
  final DateTime timestamp;

  InventoryTransaction({
    required this.id,
    required this.type,
    required this.quantity,
    required this.reason,
    required this.timestamp,
  });

  factory InventoryTransaction.fromJson(Map<String, dynamic> json) {
    return InventoryTransaction(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      quantity: json['quantity'] ?? 0,
      reason: json['reason'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    'quantity': quantity,
    'reason': reason,
    'timestamp': timestamp.toIso8601String(),
  };
}

class VendorDriver {
  final String id;
  final String name;
  final String phone;
  final String licenseNumber;
  final String licenseExpiry;
  final String profilePhoto;
  final bool isActive;
  final bool isVerified;
  final double rating;
  final int totalDeliveries;
  final String status; // 'available', 'on_trip', 'offline'
  final DateTime createdAt;

  VendorDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.licenseNumber,
    required this.licenseExpiry,
    this.profilePhoto = '',
    this.isActive = true,
    this.isVerified = false,
    this.rating = 0.0,
    this.totalDeliveries = 0,
    this.status = 'offline',
    required this.createdAt,
  });

  factory VendorDriver.fromJson(Map<String, dynamic> json) {
    return VendorDriver(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      licenseExpiry: json['licenseExpiry'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalDeliveries: json['totalDeliveries'] ?? 0,
      status: json['status'] ?? 'offline',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'phone': phone,
    'licenseNumber': licenseNumber,
    'licenseExpiry': licenseExpiry,
    'profilePhoto': profilePhoto,
    'isActive': isActive,
    'isVerified': isVerified,
    'rating': rating,
    'totalDeliveries': totalDeliveries,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };
}

class VendorEarnings {
  final String id;
  final String vendorId;
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final double totalEarnings;
  final int completedOrders;
  final double commissionRate;
  final double totalCommission;
  final List<EarningsBreakdown> breakdown;
  final DateTime lastUpdatedAt;

  VendorEarnings({
    required this.id,
    required this.vendorId,
    this.todayEarnings = 0.0,
    this.weekEarnings = 0.0,
    this.monthEarnings = 0.0,
    this.totalEarnings = 0.0,
    this.completedOrders = 0,
    this.commissionRate = 0.0,
    this.totalCommission = 0.0,
    this.breakdown = const [],
    required this.lastUpdatedAt,
  });

  factory VendorEarnings.fromJson(Map<String, dynamic> json) {
    return VendorEarnings(
      id: json['_id'] ?? '',
      vendorId: json['vendorId'] ?? '',
      todayEarnings: (json['todayEarnings'] ?? 0.0).toDouble(),
      weekEarnings: (json['weekEarnings'] ?? 0.0).toDouble(),
      monthEarnings: (json['monthEarnings'] ?? 0.0).toDouble(),
      totalEarnings: (json['totalEarnings'] ?? 0.0).toDouble(),
      completedOrders: json['completedOrders'] ?? 0,
      commissionRate: (json['commissionRate'] ?? 0.0).toDouble(),
      totalCommission: (json['totalCommission'] ?? 0.0).toDouble(),
      breakdown: (json['breakdown'] as List?)?.map((b) => EarningsBreakdown.fromJson(b)).toList() ?? [],
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'vendorId': vendorId,
    'todayEarnings': todayEarnings,
    'weekEarnings': weekEarnings,
    'monthEarnings': monthEarnings,
    'totalEarnings': totalEarnings,
    'completedOrders': completedOrders,
    'commissionRate': commissionRate,
    'totalCommission': totalCommission,
    'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
  };
}

class EarningsBreakdown {
  final String serviceType;
  final int count;
  final double amount;

  EarningsBreakdown({
    required this.serviceType,
    required this.count,
    required this.amount,
  });

  factory EarningsBreakdown.fromJson(Map<String, dynamic> json) {
    return EarningsBreakdown(
      serviceType: json['serviceType'] ?? '',
      count: json['count'] ?? 0,
      amount: (json['amount'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'serviceType': serviceType,
    'count': count,
    'amount': amount,
  };
}
