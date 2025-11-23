import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:second_app/src/core/config/providers.dart';
import 'package:second_app/src/presentation/routes/app_router.dart';

/// Request contact screen simulates lead creation and transitions to the bot.
class RequestContactScreen extends ConsumerStatefulWidget {
  const RequestContactScreen({super.key, required this.args});

  final RequestContactArgs args;

  @override
  ConsumerState<RequestContactScreen> createState() =>
      _RequestContactScreenState();
}

class _RequestContactScreenState extends ConsumerState<RequestContactScreen> {
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final leadService = ref.read(leadServiceProvider);
    final lead = await leadService.createLead(
      vendorId: widget.args.vendor.id,
      serviceType: 'dress',
    );
    if (!mounted) return;
    setState(() => _isProcessing = false);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      AppRouter.leadBot,
      arguments: LeadBotScreenArgs(lead: lead, vendor: widget.args.vendor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creating Lead')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(strokeWidth: 6),
            ),
            const SizedBox(height: 24),
            Text(
              _isProcessing
                  ? 'Reserving a safe chat with the vendor...'
                  : 'Connecting you with Talala Bot...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
