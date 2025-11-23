import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:second_app/src/application/lead/lead_bot_controller.dart';
import 'package:second_app/src/infrastructure/services/dress_service.dart';
import 'package:second_app/src/infrastructure/services/lead_service.dart';
import 'package:second_app/src/infrastructure/services/vendor_service.dart';

/// Service layer providers keep singletons alive throughout the app lifecycle.
final dressServiceProvider = Provider<DressService>((ref) => DressService());
final vendorServiceProvider = Provider<VendorService>((ref) => VendorService());
final leadServiceProvider = Provider<LeadService>((ref) => LeadService());

final vendorCatalogProvider = FutureProvider((ref) {
  final service = ref.read(vendorServiceProvider);
  return service.fetchVendors();
});

/// Lead bot provider family defined close to the DI graph for clarity.
final leadBotControllerProvider =
    StateNotifierProvider.family<LeadBotController, LeadBotState, LeadBotArgs>(
      (ref, args) => LeadBotController(
        args: args,
        leadService: ref.read(leadServiceProvider),
      ),
    );
