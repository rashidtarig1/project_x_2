import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:second_app/src/domain/models/lead.dart';
import 'package:second_app/src/domain/models/vendor.dart';
import 'package:second_app/src/infrastructure/services/lead_service.dart';

/// Arguments used when launching the lead bot.
class LeadBotArgs {
  LeadBotArgs({required this.lead, required this.vendor});

  final Lead lead;
  final Vendor vendor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeadBotArgs &&
        other.lead.id == lead.id &&
        other.vendor.id == vendor.id;
  }

  @override
  int get hashCode => Object.hash(lead.id, vendor.id);
}

/// Conversation step machine for the bot prompts.
enum BotStep { greeting, askName, askPhone, askDate, askSize, summary, done }

/// State for the lead bot controller.
@immutable
class LeadBotState {
  const LeadBotState({
    required this.lead,
    required this.messages,
    required this.step,
    this.customerName,
    this.customerPhone,
    this.eventDate,
    this.dressSize,
    this.isSending = false,
  });

  final Lead lead;
  final List<LeadMessage> messages;
  final BotStep step;
  final String? customerName;
  final String? customerPhone;
  final String? eventDate;
  final String? dressSize;
  final bool isSending;

  LeadBotState copyWith({
    Lead? lead,
    List<LeadMessage>? messages,
    BotStep? step,
    String? customerName,
    String? customerPhone,
    String? eventDate,
    String? dressSize,
    bool? isSending,
  }) {
    return LeadBotState(
      lead: lead ?? this.lead,
      messages: messages ?? this.messages,
      step: step ?? this.step,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      eventDate: eventDate ?? this.eventDate,
      dressSize: dressSize ?? this.dressSize,
      isSending: isSending ?? this.isSending,
    );
  }
}

/// Orchestrates conversations to ensure commission-protected flows.
class LeadBotController extends StateNotifier<LeadBotState> {
  LeadBotController({
    required LeadBotArgs args,
    required LeadService leadService,
  }) : _leadService = leadService,
       super(
         LeadBotState(
           lead: args.lead,
           messages: args.lead.messages,
           step: BotStep.greeting,
         ),
       ) {
    _vendor = args.vendor;
    _bootSequence();
  }

  final LeadService _leadService;
  late final Vendor _vendor;

  Future<void> _bootSequence() async {
    await _sendBot(
      "Hey there! I'm Talala Lead Bot and I'll keep this conversation safe for both you and ${_vendor.name}.",
    );
    await _sendBot(
      "Let's start with your name so I can introduce you properly.",
    );
    state = state.copyWith(step: BotStep.askName);
  }

  /// Handles text typed by the customer in the chat box.
  Future<void> onUserInput(String rawText) async {
    if (rawText.trim().isEmpty || state.step == BotStep.done) {
      return;
    }

    final sanitized = state.step == BotStep.askPhone
        ? rawText
        : _stripPhoneNumbers(rawText);

    await _logMessage(content: sanitized, isBot: false);

    switch (state.step) {
      case BotStep.askName:
        await _handleName(rawText);
        break;
      case BotStep.askPhone:
        await _handlePhone(rawText);
        break;
      case BotStep.askDate:
        await _handleDate(rawText);
        break;
      case BotStep.askSize:
        await _handleSize(rawText);
        break;
      default:
        break;
    }
  }

  Future<void> _handleName(String input) async {
    final name = input.trim().isEmpty ? 'Guest' : input.trim();
    state = state.copyWith(customerName: name);
    await _sendBot(
      'Thanks, $name. Can I get the best phone number to reach you?',
    );
    state = state.copyWith(step: BotStep.askPhone);
  }

  Future<void> _handlePhone(String input) async {
    final digits = _extractDigits(input);
    if (digits.length < 7) {
      await _sendBot(
        'Hmm, that number looks incomplete. Mind sharing it again?',
      );
      return;
    }
    state = state.copyWith(customerPhone: digits);
    final leadAfterDetails = await _leadService.updateCustomerDetails(
      leadId: state.lead.id,
      name: state.customerName ?? 'Guest',
      phone: digits,
    );
    if (leadAfterDetails != null) {
      state = state.copyWith(lead: leadAfterDetails);
    }
    await _sendBot('Perfect. When is your event taking place? (DD/MM)');
    state = state.copyWith(step: BotStep.askDate);
  }

  Future<void> _handleDate(String input) async {
    state = state.copyWith(eventDate: input.trim());
    await _sendBot('Noted. Finally, which dress size do you need?');
    state = state.copyWith(step: BotStep.askSize);
  }

  Future<void> _handleSize(String input) async {
    state = state.copyWith(dressSize: input.trim());
    await _sendBot('Amazing! I am now connecting you with ${_vendor.name}.');
    final connected = await _leadService.updateStatus(
      state.lead.id,
      LeadStatus.connected,
    );
    if (connected != null) {
      state = state.copyWith(lead: connected);
    }
    await _sendBot('Vendor number: ${_vendor.phone}');
    await _sendBot(
      'Customer number: ${state.customerPhone ?? 'Talala collected'}',
    );
    await _sendBot(
      'Both contacts are logged for your safety. I will mark this lead as completed once you confirm.',
    );
    final completed = await _leadService.updateStatus(
      state.lead.id,
      LeadStatus.completed,
    );
    if (completed != null) {
      state = state.copyWith(lead: completed);
    }
    state = state.copyWith(step: BotStep.done);
  }

  Future<void> _logMessage({
    required String content,
    required bool isBot,
  }) async {
    final message = LeadMessage(
      id: 'msg_${DateTime.now().microsecondsSinceEpoch}',
      content: isBot ? content : _maskPhoneNumber(content),
      sender: isBot ? 'Talala Bot' : 'You',
      timestamp: DateTime.now(),
      isBot: isBot,
    );
    final updated = [...state.messages, message];
    state = state.copyWith(messages: updated, isSending: isBot);
    final lead = await _leadService.addMessage(state.lead.id, message);
    if (lead != null) {
      state = state.copyWith(lead: lead, messages: lead.messages);
    }
  }

  Future<void> _sendBot(String text) async {
    await _logMessage(content: text, isBot: true);
  }

  String _stripPhoneNumbers(String input) {
    final regex = RegExp(r'(?:\+?\d[\d\s-]{6,})');
    if (regex.hasMatch(input)) {
      return 'Contact shared by Talala Bot';
    }
    return input;
  }

  String _maskPhoneNumber(String input) {
    if (state.step == BotStep.askPhone) {
      return 'Contact shared by Talala Bot';
    }
    return input;
  }

  String _extractDigits(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[^0-9+]'), '');
    return digitsOnly;
  }
}
