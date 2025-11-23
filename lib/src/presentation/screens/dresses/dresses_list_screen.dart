import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:second_app/src/application/dresses/dress_list_controller.dart';
import 'package:second_app/src/core/config/providers.dart';
import 'package:second_app/src/domain/models/dress.dart';
import 'package:second_app/src/domain/models/vendor.dart';
import 'package:second_app/src/presentation/routes/app_router.dart';

/// Grid listing of dresses with lightweight filtering controls.
class DressesListScreen extends ConsumerStatefulWidget {
  const DressesListScreen({super.key});

  @override
  ConsumerState<DressesListScreen> createState() => _DressesListScreenState();
}

class _DressesListScreenState extends ConsumerState<DressesListScreen> {
  static const sizes = ['XS', 'S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dressListControllerProvider);
    final vendorsAsync = ref.watch(vendorCatalogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dresses')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _FiltersRow(
              selectedSize: state.filters.size,
              maxPrice: state.filters.maxPrice ?? 600,
              onSizeSelected: (size) => ref
                  .read(dressListControllerProvider.notifier)
                  .updateSize(size == state.filters.size ? null : size),
              onPriceChanged: (value) => ref
                  .read(dressListControllerProvider.notifier)
                  .updateMaxPrice(value),
              onPickDate: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: state.filters.date ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 180)),
                );
                ref
                    .read(dressListControllerProvider.notifier)
                    .updateDate(picked);
              },
              onClearDate: () => ref
                  .read(dressListControllerProvider.notifier)
                  .updateDate(null),
              selectedDate: state.filters.date,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: vendorsAsync.when(
                data: (vendors) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list = state.filtered;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text('No dresses match your filters.'),
                    );
                  }
                  final vendorMap = {for (final v in vendors) v.id: v};
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final dress = list[index];
                      final vendor = vendorMap[dress.vendorId];
                      return _DressCard(
                        dress: dress,
                        vendor: vendor,
                        onTap: vendor == null
                            ? null
                            : () => Navigator.pushNamed(
                                context,
                                AppRouter.dressDetails,
                                arguments: DressDetailsArgs(
                                  dress: dress,
                                  vendor: vendor,
                                ),
                              ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Failed to load vendors: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({
    required this.selectedSize,
    required this.maxPrice,
    required this.onSizeSelected,
    required this.onPriceChanged,
    required this.onPickDate,
    required this.onClearDate,
    required this.selectedDate,
  });

  final String? selectedSize;
  final double maxPrice;
  final ValueChanged<String?> onSizeSelected;
  final ValueChanged<double> onPriceChanged;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final size = _DressesListScreenState.sizes[index];
              final active = selectedSize == size;
              return ChoiceChip(
                label: Text(size),
                selected: active,
                onSelected: (_) => onSizeSelected(active ? null : size),
              );
            },
            separatorBuilder: (context, _) => const SizedBox(width: 8),
            itemCount: _DressesListScreenState.sizes.length,
          ),
        ),
        const SizedBox(height: 12),
        Text('Max price: AED ${maxPrice.toStringAsFixed(0)}'),
        Slider(
          min: 150,
          max: 600,
          divisions: 9,
          value: maxPrice.clamp(150, 600),
          onChanged: onPriceChanged,
        ),
        Row(
          children: [
            FilledButton.tonal(
              onPressed: onPickDate,
              child: Text(
                selectedDate == null
                    ? 'Select date'
                    : '${selectedDate!.day}/${selectedDate!.month}',
              ),
            ),
            const SizedBox(width: 8),
            TextButton(onPressed: onClearDate, child: const Text('Clear date')),
          ],
        ),
      ],
    );
  }
}

class _DressCard extends StatelessWidget {
  const _DressCard({required this.dress, this.vendor, this.onTap});

  final Dress dress;
  final Vendor? vendor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final image = dress.images.isNotEmpty ? dress.images.first : '';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: image.isEmpty
                    ? Container(color: Colors.black12)
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dress.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('AED ${dress.price.toStringAsFixed(0)} / day'),
                  const SizedBox(height: 4),
                  Text(
                    'Sizes: ${dress.sizes.join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vendor == null
                        ? 'Vendor pending'
                        : '${vendor!.name} (${vendor!.rating.toStringAsFixed(1)}/5)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
