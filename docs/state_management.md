# State Management & DI

## Recommended Stack
- **Riverpod + StateNotifier** for feature controllers: scoped providers ensure widgets subscribe only to the slices they need, aiding availability (fewer unnecessary rebuilds) and enabling background refresh.
- **Freezed + Sealed Classes** to model UI states (`Loading`, `Content`, `Empty`, `Failure`), keeping transitions explicit.
- **GoRouter** for navigation so deep links per category (e.g., `/events/music/:id`) remain declarative.

## Provider Graph
- `ProviderScope` bootstraps in `main.dart`, injecting `AppRouter`, `AppTheme`, and `TelemetryClient`.
- Each feature exposes a `ProviderFamily` keyed by category or entity id, allowing instant extension when new categories arrive.
- StateNotifiers call application-layer use cases; no direct networking in presentation.

## Dependency Injection
- Use `riverpod_generator` to auto-wire repositories/use cases while keeping constructors visible for testing.
- Register core singletons (`Dio`, `SecureStorage`, `AnalyticsDispatcher`) in `core/di/providers.dart`.
- Feature modules declare their own provider files (`catalog/providers.dart`) importing only what they need, improving build times.

## Testing Strategy
- Widget tests wrap trees with `ProviderScope(overrides: [...])` to inject mock notifiers.
- Use `fake_async` to simulate animation + network timelines for splash/booking flows.
- Maintain a `test/fixtures` directory with JSON payloads for catalog categories, ensuring new categories can be tested without API calls.
