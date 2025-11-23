import 'package:flutter/material.dart';
import 'package:second_app/src/presentation/routes/app_router.dart';
import 'package:second_app/src/presentation/widgets/app_button.dart';

/// Detailed dress page with carousel and contact CTA.
class DressDetailsScreen extends StatefulWidget {
  const DressDetailsScreen({super.key, required this.args});

  final DressDetailsArgs args;

  @override
  State<DressDetailsScreen> createState() => _DressDetailsScreenState();
}

class _DressDetailsScreenState extends State<DressDetailsScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dress = widget.args.dress;
    final vendor = widget.args.vendor;

    return Scaffold(
      appBar: AppBar(title: Text(dress.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(
            height: 260,
            child: dress.images.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.black12,
                    ),
                    child: const Icon(Icons.image_not_supported, size: 48),
                  )
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) =>
                        setState(() => _currentIndex = value),
                    itemCount: dress.images.length,
                    itemBuilder: (_, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        dress.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          if (dress.images.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dress.images.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.deepPurple
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            'AED ${dress.price.toStringAsFixed(0)} per day',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: dress.sizes
                .map(
                  (size) =>
                      Chip(label: Text(size), backgroundColor: Colors.white),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Text('Availability', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _AvailabilityGrid(bookedDates: dress.bookedDates),
          const SizedBox(height: 24),
          Text('Vendor', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text('Rating: ${vendor.rating.toStringAsFixed(1)} / 5.0'),
                const SizedBox(height: 8),
                Text(
                  'Talala verifies every vendor and stores their contact details securely before handing them over.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Request Contact',
            icon: Icons.chat_bubble_outline,
            onPressed: () => Navigator.pushNamed(
              context,
              AppRouter.requestContact,
              arguments: RequestContactArgs(dress: dress, vendor: vendor),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityGrid extends StatelessWidget {
  const _AvailabilityGrid({required this.bookedDates});

  final List<DateTime> bookedDates;

  @override
  Widget build(BuildContext context) {
    if (bookedDates.isEmpty) {
      return const Text('Fully available for the next 30 days.');
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: bookedDates
          .map(
            (date) => Chip(
              label: Text('${date.day}/${date.month}'),
              backgroundColor: Colors.red.shade100,
            ),
          )
          .toList(),
    );
  }
}
