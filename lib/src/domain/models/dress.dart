import 'package:flutter/foundation.dart';

/// Represents a rentable dress with pricing and availability metadata.
@immutable
class Dress {
  const Dress({
    required this.id,
    required this.name,
    required this.price,
    required this.sizes,
    required this.images,
    required this.bookedDates,
    required this.vendorId,
  });

  final String id;
  final String name;
  final double price;
  final List<String> sizes;
  final List<String> images;
  final List<DateTime> bookedDates;
  final String vendorId;

  bool isAvailableOn(DateTime date) =>
      !bookedDates.any((booked) => _sameDate(booked, date));

  Dress copyWith({
    String? id,
    String? name,
    double? price,
    List<String>? sizes,
    List<String>? images,
    List<DateTime>? bookedDates,
    String? vendorId,
  }) {
    return Dress(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      sizes: sizes ?? this.sizes,
      images: images ?? this.images,
      bookedDates: bookedDates ?? this.bookedDates,
      vendorId: vendorId ?? this.vendorId,
    );
  }

  static bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
