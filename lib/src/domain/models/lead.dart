import 'package:flutter/foundation.dart';

/// Possible lead statuses tracked through the lead bot.
enum LeadStatus { pending, connected, completed, failed }

/// Single message exchanged via the lead bot.
@immutable
class LeadMessage {
  const LeadMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.isBot,
  });

  final String id;
  final String content;
  final String sender;
  final DateTime timestamp;
  final bool isBot;
}

/// Lead domain model capturing the customer/vendor conversation.
@immutable
class Lead {
  const Lead({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.vendorId,
    required this.serviceType,
    required this.timestamp,
    required this.status,
    required this.messages,
  });

  final String id;
  final String customerName;
  final String customerPhone;
  final String vendorId;
  final String serviceType;
  final DateTime timestamp;
  final LeadStatus status;
  final List<LeadMessage> messages;

  Lead copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? vendorId,
    String? serviceType,
    DateTime? timestamp,
    LeadStatus? status,
    List<LeadMessage>? messages,
  }) {
    return Lead(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      vendorId: vendorId ?? this.vendorId,
      serviceType: serviceType ?? this.serviceType,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      messages: messages ?? this.messages,
    );
  }
}
