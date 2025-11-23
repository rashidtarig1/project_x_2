import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:second_app/src/application/lead/lead_bot_controller.dart';
import 'package:second_app/src/core/config/providers.dart';
import 'package:second_app/src/domain/models/lead.dart';
import 'package:second_app/src/domain/models/vendor.dart';
import 'package:second_app/src/presentation/widgets/app_button.dart';

/// In-app mock chat that demonstrates the lead bot flow.
class LeadBotScreen extends ConsumerStatefulWidget {
  const LeadBotScreen({super.key, required this.lead, required this.vendor});

  final Lead lead;
  final Vendor vendor;

  @override
  ConsumerState<LeadBotScreen> createState() => _LeadBotScreenState();
}

class _LeadBotScreenState extends ConsumerState<LeadBotScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = LeadBotArgs(lead: widget.lead, vendor: widget.vendor);
    final state = ref.watch(leadBotControllerProvider(args));
    final notifier = ref.read(leadBotControllerProvider(args).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Talala Lead Bot'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Chip(
              label: Text(
                state.lead.status.name,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.deepPurple,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                final isBot = message.isBot;
                return Align(
                  alignment: isBot
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBot
                          ? Colors.white
                          : Colors.deepPurple.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBot ? 'Talala Bot' : 'You',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isBot ? Colors.black87 : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isBot ? Colors.black87 : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Type here...'),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 110,
                  child: AppButton(
                    label: 'Send',
                    onPressed: () {
                      final text = _messageController.text;
                      if (text.trim().isEmpty) return;
                      _messageController.clear();
                      notifier.onUserInput(text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
