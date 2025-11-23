import 'package:flutter/material.dart';
import 'package:second_app/src/presentation/routes/app_router.dart';
import 'package:second_app/src/presentation/widgets/app_card.dart';
import 'package:second_app/src/presentation/widgets/app_input.dart';

/// Landing page with quick access to Talala services.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9F5FF), Color(0xFFEFE4FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(
                  'Talala',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Booking assistant for photographers, artists, and stunning dresses.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                AppInput(
                  controller: _searchController,
                  hint: 'Search talent, dresses, or events',
                  icon: Icons.search,
                  onSubmitted: (_) =>
                      Navigator.pushNamed(context, AppRouter.dresses),
                ),
                const SizedBox(height: 24),
                AppCard(
                  title: 'Photographers',
                  subtitle: 'Capture every emotion with curated lenses.',
                  icon: Icons.camera_alt_outlined,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                AppCard(
                  title: 'Artists',
                  subtitle: 'Live music, DJs, and cultural performances.',
                  icon: Icons.music_note_outlined,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                AppCard(
                  title: 'Dresses',
                  subtitle: 'Rent couture pieces with Talala protection.',
                  icon: Icons.local_mall_outlined,
                  onTap: () => Navigator.pushNamed(context, AppRouter.dresses),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
