import 'dart:async';

import 'package:second_app/src/domain/models/dress.dart';
import 'package:second_app/src/infrastructure/data/mock_data.dart';

/// Repository-like service for dress catalog interactions.
class DressService {
  Future<List<Dress>> getAllDresses() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return mockDresses;
  }

  Future<Dress?> getDressById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return mockDresses.firstWhere(
      (dress) => dress.id == id,
      orElse: () => mockDresses.first,
    );
  }
}
