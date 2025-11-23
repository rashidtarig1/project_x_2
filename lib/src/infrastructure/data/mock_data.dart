import 'package:second_app/src/domain/models/dress.dart';
import 'package:second_app/src/domain/models/vendor.dart';

/// Sample vendor catalog to unblock UI flows.
final mockVendors = <Vendor>[
  const Vendor(
    id: 'vendor_a',
    name: 'Lumiere Couture',
    phone: '+97150000001',
    type: 'dress',
    rating: 4.8,
  ),
  const Vendor(
    id: 'vendor_b',
    name: 'Velvet Atelier',
    phone: '+97150000002',
    type: 'dress',
    rating: 4.6,
  ),
];

/// Sample dresses with lightweight availability data.
final mockDresses = <Dress>[
  Dress(
    id: 'dress_a',
    name: 'Aurora Gown',
    price: 280.0,
    sizes: const ['S', 'M', 'L'],
    images: const [
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
    ],
    bookedDates: [
      DateTime.now().add(const Duration(days: 3)),
      DateTime.now().add(const Duration(days: 7)),
    ],
    vendorId: 'vendor_a',
  ),
  Dress(
    id: 'dress_b',
    name: 'Pearl Silhouette',
    price: 320.0,
    sizes: const ['XS', 'S', 'M'],
    images: const [
      'https://images.unsplash.com/photo-1499636136210-6f4ee915583e',
    ],
    bookedDates: [DateTime.now().add(const Duration(days: 2))],
    vendorId: 'vendor_b',
  ),
  Dress(
    id: 'dress_c',
    name: 'Ivy Saree',
    price: 190.0,
    sizes: const ['M', 'L'],
    images: const [
      'https://images.unsplash.com/photo-1436831135709-48bdc150cce5',
    ],
    bookedDates: const [],
    vendorId: 'vendor_a',
  ),
];
