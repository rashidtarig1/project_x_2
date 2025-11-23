import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:second_app/src/domain/models/dress.dart';
import 'package:second_app/src/domain/models/lead.dart';
import 'package:second_app/src/domain/models/vendor.dart';
import 'package:second_app/src/presentation/screens/dresses/dress_details_screen.dart';
import 'package:second_app/src/presentation/screens/dresses/dresses_list_screen.dart';
import 'package:second_app/src/presentation/screens/home/home_screen.dart';
import 'package:second_app/src/presentation/screens/lead/lead_bot_screen.dart';
import 'package:second_app/src/presentation/screens/lead/request_contact_screen.dart';

/// Provider exposing a single router instance.
final appRouterProvider = Provider<AppRouter>((ref) => AppRouter(ref));

class AppRouter {
  AppRouter(Ref ref);

  static const home = '/';
  static const dresses = '/dresses';
  static const dressDetails = '/dress-details';
  static const requestContact = '/request-contact';
  static const leadBot = '/lead-bot';

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case dresses:
        return MaterialPageRoute(builder: (_) => const DressesListScreen());
      case dressDetails:
        final args = settings.arguments as DressDetailsArgs;
        return MaterialPageRoute(
          builder: (_) => DressDetailsScreen(args: args),
        );
      case requestContact:
        final args = settings.arguments as RequestContactArgs;
        return MaterialPageRoute(
          builder: (_) => RequestContactScreen(args: args),
        );
      case leadBot:
        final args = settings.arguments as LeadBotScreenArgs;
        return MaterialPageRoute(
          builder: (_) => LeadBotScreen(lead: args.lead, vendor: args.vendor),
        );
    }
    return null;
  }
}

/// Arguments when navigating to the dress details view.
class DressDetailsArgs {
  DressDetailsArgs({required this.dress, required this.vendor});

  final Dress dress;
  final Vendor vendor;
}

/// Arguments for the request contact loading screen.
class RequestContactArgs {
  RequestContactArgs({required this.dress, required this.vendor});

  final Dress dress;
  final Vendor vendor;
}

/// Arguments for the LeadBot screen.
class LeadBotScreenArgs {
  LeadBotScreenArgs({required this.lead, required this.vendor});

  final Lead lead;
  final Vendor vendor;
}
