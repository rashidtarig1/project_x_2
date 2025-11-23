import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:second_app/src/core/config/providers.dart';
import 'package:second_app/src/domain/models/dress.dart';
import 'package:second_app/src/infrastructure/services/dress_service.dart';

/// Filters used in the dresses module.
class DressFilters {
  const DressFilters({this.size, this.maxPrice, this.date});

  final String? size;
  final double? maxPrice;
  final DateTime? date;

  DressFilters copyWith({String? size, double? maxPrice, DateTime? date}) {
    return DressFilters(
      size: size ?? this.size,
      maxPrice: maxPrice ?? this.maxPrice,
      date: date ?? this.date,
    );
  }
}

/// Encapsulates loaded dresses and filter state.
class DressListState {
  const DressListState({
    required this.isLoading,
    required this.dresses,
    required this.filters,
  });

  final bool isLoading;
  final List<Dress> dresses;
  final DressFilters filters;

  List<Dress> get filtered {
    return dresses.where((dress) {
      final sizePass =
          filters.size == null || dress.sizes.contains(filters.size);
      final pricePass =
          filters.maxPrice == null || dress.price <= filters.maxPrice!;
      final datePass =
          filters.date == null || dress.isAvailableOn(filters.date!);
      return sizePass && pricePass && datePass;
    }).toList();
  }

  DressListState copyWith({
    bool? isLoading,
    List<Dress>? dresses,
    DressFilters? filters,
  }) {
    return DressListState(
      isLoading: isLoading ?? this.isLoading,
      dresses: dresses ?? this.dresses,
      filters: filters ?? this.filters,
    );
  }
}

class DressListController extends StateNotifier<DressListState> {
  DressListController(this._service)
    : super(
        DressListState(
          isLoading: true,
          dresses: const [],
          filters: const DressFilters(),
        ),
      ) {
    _load();
  }

  final DressService _service;

  Future<void> _load() async {
    final dresses = await _service.getAllDresses();
    state = state.copyWith(isLoading: false, dresses: dresses);
  }

  void updateSize(String? size) {
    state = state.copyWith(filters: state.filters.copyWith(size: size));
  }

  void updateMaxPrice(double? price) {
    state = state.copyWith(filters: state.filters.copyWith(maxPrice: price));
  }

  void updateDate(DateTime? date) {
    state = state.copyWith(filters: state.filters.copyWith(date: date));
  }
}

final dressListControllerProvider =
    StateNotifierProvider<DressListController, DressListState>(
      (ref) => DressListController(ref.read(dressServiceProvider)),
    );
