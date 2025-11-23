import 'package:flutter/foundation.dart';

/// Vendor entity that can be matched to a lead.
@immutable
class Vendor {
  const Vendor({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    required this.rating,
  });

  final String id;
  final String name;
  final String phone;
  final String type;
  final double rating;
}
