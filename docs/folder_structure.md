# Folder Structure Plan

```
lib/
  src/
    core/
      config/        # env, constants, theme tokens
      errors/        # AppFailure, result wrappers
      network/       # Dio/HTTP, interceptors, retry policies
      utils/
    domain/
      catalog/
        entities/
        repositories/
      booking/
      identity/
      value_objects/
    application/
      catalog/
        usecases/
        dto_mappers/
      booking/
      identity/
    infrastructure/
      catalog/
        data_sources/   # remote/local implementations
        dtos/
        repository_impl/
      booking/
      identity/
    presentation/
      shared/
        widgets/
        theming/
        localization/
      catalog/
        views/
        controllers/
      booking/
      identity/
```

## Rationale
- `lib/src` keeps generated files (e.g., `main.dart`) isolated from business logic, easing testing.
- Feature folders mirror domain chunks so new categories mean cloning the pattern, not inventing one.
- Every layer has its own namespace (`catalog/application`, `catalog/presentation`) to prevent circular imports.
- Shared widgets/components live under `presentation/shared` so availability-critical UI (loaders, retry banners) stay consistent.
- Platform assets stored in `assets/<module>` with registration in `pubspec.yaml` per module ownership.
