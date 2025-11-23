# Architecture Strategy

## Guiding Goals
- Guarantee availability by isolating critical booking/search flows in feature modules with clear contracts and enabling offline-first caching of catalog data.
- Preserve flexibility so new event categories (music, sport, wellness) plug into the same domain APIs without touching presentation widgets.
- Enable rapid iteration by decoupling UI (Flutter widgets) from data sources (REST, GraphQL, Firebase) via abstractions.

## Layered Approach
1. **Presentation** (`lib/src/presentation`): Widgets + Controllers (Cubit/StateNotifier) consume view models and handle navigation. Widgets stay dumb; side-effects happen in controllers.
2. **Application** (`lib/src/application`): Use-cases orchestrate domain rules (e.g., `FetchFeaturedExperiences`, `ReserveSlot`). Application logic is synchronous APIs returning `Future<Either<AppFailure, Result>>`.
3. **Domain** (`lib/src/domain`): Pure entities (`Event`, `Category`, `UserProfile`, `Booking`) plus repository interfaces. No Flutter imports.
4. **Infrastructure** (`lib/src/infrastructure`): Remote data sources (HTTP, gRPC) + local persistence (Hive/SharedPreferences). Implements repositories and handles DTO ? entity mapping.

## Module Boundaries
- **Catalog Module** (browse categories, search, filters)
- **Booking Module** (availability grid, payment handoff)
- **Identity Module** (auth, profiles, preferences)
Each module follows the same four-layer stack, allowing staged deployment and independent QA cycles.

## Cross-Cutting Concerns
- **Error Handling:** Central `AppFailure` sealed hierarchy with adapters to UI copy.
- **Analytics:** Presentation layer emits `AnalyticsEvent`s via a global dispatcher injected from DI.
- **Offline Resilience:** Infrastructure caches critical endpoints (categories, event details) and exposes stale data with freshness metadata.
- **Feature Flags:** Application layer consults a `FeatureToggleService` so experiments never leak into UI conditionals.
