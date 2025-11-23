import 'dart:async';

import 'package:second_app/src/domain/models/lead.dart';

/// Handles lead creation and in-memory persistence for the prototype.
class LeadService {
  final Map<String, Lead> _leads = {};

  Future<Lead> createLead({
    required String vendorId,
    required String serviceType,
    String? customerName,
    String? customerPhone,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final id = 'lead_${DateTime.now().millisecondsSinceEpoch}';
    final lead = Lead(
      id: id,
      customerName: customerName ?? 'Pending Name',
      customerPhone: customerPhone ?? 'Pending Phone',
      vendorId: vendorId,
      serviceType: serviceType,
      timestamp: DateTime.now(),
      status: LeadStatus.pending,
      messages: const [],
    );
    _leads[id] = lead;
    return lead;
  }

  Lead? getLead(String id) => _leads[id];

  Future<Lead?> addMessage(String leadId, LeadMessage message) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final lead = _leads[leadId];
    if (lead == null) return null;
    final updated = lead.copyWith(messages: [...lead.messages, message]);
    _leads[leadId] = updated;
    return updated;
  }

  Future<Lead?> updateStatus(String leadId, LeadStatus status) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final lead = _leads[leadId];
    if (lead == null) return null;
    final updated = lead.copyWith(status: status);
    _leads[leadId] = updated;
    return updated;
  }

  Future<Lead?> updateCustomerDetails({
    required String leadId,
    required String name,
    required String phone,
  }) async {
    final lead = _leads[leadId];
    if (lead == null) return null;
    final updated = lead.copyWith(customerName: name, customerPhone: phone);
    _leads[leadId] = updated;
    return updated;
  }
}
