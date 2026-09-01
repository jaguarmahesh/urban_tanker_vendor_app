import 'package:flutter/material.dart';

class VendorClientConfig {
  final String id;
  final String clientCode;
  final String name;
  final String tagline;
  final List<String> allowedDomains;
  final List<String> allowedEmails;
  final Color accentColor;
  final String location;
  final String supportPhone;
  final int fleetSize;
  final double rating;
  final int totalOrdersServed;

  const VendorClientConfig({
    required this.id,
    required this.clientCode,
    required this.name,
    required this.tagline,
    required this.allowedDomains,
    required this.allowedEmails,
    required this.accentColor,
    required this.location,
    required this.supportPhone,
    required this.fleetSize,
    required this.rating,
    required this.totalOrdersServed,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientCode': clientCode,
    'name': name,
    'tagline': tagline,
    'allowedDomains': allowedDomains,
    'allowedEmails': allowedEmails,
    'accentColor': accentColor.value,
    'location': location,
    'supportPhone': supportPhone,
    'fleetSize': fleetSize,
    'rating': rating,
    'totalOrdersServed': totalOrdersServed,
  };
}

class VendorClientRegistry {
  static const Map<String, VendorClientConfig> clients = {
    'balaji': VendorClientConfig(
      id: 'balaji',
      clientCode: 'BALAJI',
      name: 'Sri Balaji Water Suppliers',
      tagline: 'Leading Pure RO & Commercial Tanker Logistics in South Chennai',
      allowedDomains: ['balajiwater.in', 'balajiwater.com', 'sribalaji.org'],
      allowedEmails: ['vendor@balajiwater.in', 'balaji@urban.com', 'ops@balajiwater.in'],
      accentColor: Color(0xFF2563EB),
      location: 'Nungambakkam, Chennai, TN',
      supportPhone: '+91 98401 23456',
      fleetSize: 8,
      rating: 4.8,
      totalOrdersServed: 1420,
    ),
    'aqua': VendorClientConfig(
      id: 'aqua',
      clientCode: 'AQUA',
      name: 'Aqua Logistics Vendor Hub',
      tagline: 'High-Volume Industrial & Hospital Clean Water Distribution',
      allowedDomains: ['aqualogistics.in', 'aqualog.com'],
      allowedEmails: ['ops@aqualogistics.in', 'aqua@urban.com', 'dispatch@aqualogistics.in'],
      accentColor: Color(0xFF0284C7),
      location: 'Guindy & OMR Hub, Chennai, TN',
      supportPhone: '+91 98405 88990',
      fleetSize: 14,
      rating: 4.9,
      totalOrdersServed: 2890,
    ),
    'metro': VendorClientConfig(
      id: 'metro',
      clientCode: 'METRO',
      name: 'Metro Water Movers Fleet',
      tagline: 'Urban Tanker Rapid Response & Bulk Residential Supply',
      allowedDomains: ['metrowater.in', 'metrotankers.com'],
      allowedEmails: ['fleet@metrowater.in', 'metro@urban.com', 'admin@metrowater.in'],
      accentColor: Color(0xFF16A34A),
      location: 'Koramangala, Bengaluru, KA',
      supportPhone: '+91 97412 34567',
      fleetSize: 10,
      rating: 4.7,
      totalOrdersServed: 1980,
    ),
    'civic': VendorClientConfig(
      id: 'civic',
      clientCode: 'CIVIC',
      name: 'Civic Tanker Operations',
      tagline: 'Municipal, Commercial & Construction Potable Water Solutions',
      allowedDomains: ['civictanker.com', 'civicwater.in'],
      allowedEmails: ['control@civictanker.com', 'civic@urban.com'],
      accentColor: Color(0xFFD97706),
      location: 'HITEC City, Hyderabad, TS',
      supportPhone: '+91 99887 65432',
      fleetSize: 12,
      rating: 4.6,
      totalOrdersServed: 2150,
    ),
    'chennai': VendorClientConfig(
      id: 'chennai',
      clientCode: 'CHENNAI',
      name: 'Chennai Express Waters',
      tagline: '24/7 Superfast Potable & Purified Tanker Fleet',
      allowedDomains: ['chennaiwaters.in', 'expresswaters.in'],
      allowedEmails: ['admin@chennaiwaters.in', 'chennai@urban.com'],
      accentColor: Color(0xFF7C3AED),
      location: 'Velachery & Tambaram, Chennai, TN',
      supportPhone: '+91 94441 12233',
      fleetSize: 6,
      rating: 4.85,
      totalOrdersServed: 960,
    ),
  };

  static VendorClientConfig resolveClient(String email, [String? clientCodeInput]) {
    final cleanEmail = email.trim().toLowerCase();
    final emailDomain = cleanEmail.contains('@') ? cleanEmail.split('@')[1] : '';
    final code = (clientCodeInput ?? '').trim().toLowerCase();

    // 1. Check direct client code
    if (code.isNotEmpty && clients.containsKey(code)) {
      return clients[code]!;
    }

    // 2. Search by client code or domain or email
    for (final client in clients.values) {
      if (code.isNotEmpty &&
          (client.clientCode.toLowerCase() == code || client.id.toLowerCase() == code)) {
        return client;
      }
      if (client.allowedEmails.any((e) => e.toLowerCase() == cleanEmail)) {
        return client;
      }
      if (emailDomain.isNotEmpty &&
          client.allowedDomains.any((d) => d.toLowerCase() == emailDomain)) {
        return client;
      }
    }

    // 3. Dynamic Distributed Multi-Customer Client Generation
    // Enables distribution to any new customer organization without code modifications!
    final generatedId = (code.isNotEmpty
            ? code
            : (emailDomain.isNotEmpty ? emailDomain.split('.')[0] : 'custom_vendor'))
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();

    final formattedName = code.isNotEmpty
        ? '${code.toUpperCase()} Water Enterprises'
        : (emailDomain.isNotEmpty
            ? '${emailDomain.split('.')[0].toUpperCase()} Logistics'
            : 'Custom Client Organization');

    return VendorClientConfig(
      id: generatedId,
      clientCode: generatedId.toUpperCase(),
      name: formattedName,
      tagline: 'Distributed Multi-Customer Cloud Water Management Portal',
      allowedDomains: emailDomain.isNotEmpty ? [emailDomain] : ['urbantanker.com'],
      allowedEmails: [cleanEmail],
      accentColor: const Color(0xFF2563EB),
      location: 'Regional Distribution Yard',
      supportPhone: '+91 1800-TANKER-1',
      fleetSize: 5,
      rating: 5.0,
      totalOrdersServed: 100,
    );
  }
}
