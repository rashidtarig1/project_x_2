import 'dart:async';

import 'package:second_app/src/domain/models/vendor.dart';
import 'package:second_app/src/infrastructure/data/mock_data.dart';

/// Facade that provides vendor information to the presentation layer.
class VendorService {
  Future<List<Vendor>> fetchVendors() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return mockVendors;
  }

  Future<Vendor?> fetchVendorById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return mockVendors.firstWhere(
      (vendor) => vendor.id == id,
      orElse: () => mockVendors.first,
    );
  }
}
