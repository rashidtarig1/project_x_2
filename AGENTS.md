# Repository Guidelines
## Project Structure & Module Organization
This Flutter repo centers on lib/, where main.dart wires the app shell and splash_screen.dart hosts the animated launch experience. Keep feature-specific widgets in their own files under lib/ using folders (lib/auth/, lib/home/) once the MVP grows. Tests live in 	est/ and should mirror the lib/ tree (e.g., lib/splash/splash_screen.dart ? 	est/splash/splash_screen_test.dart). Platform scaffolding sits in ndroid/, ios/, macos/, windows/, linux/, and web/; avoid editing generated build files unless platform configuration truly requires it.

## Build, Test, and Development Commands
- lutter pub get — resolve pubspec.yaml dependencies after every clone or dependency edit.
- lutter run -d chrome — launch the splash screen quickly in a browser for iterative UI checks.
- lutter test — execute the widget suite under 	est/ and block regressions before pushing.
- lutter analyze and lutter build apk --release — lint the codebase, then produce a release artifact when QA is satisfied.

## Coding Style & Naming Conventions
nalysis_options.yaml enables lutter_lints, so fix analyzer warnings immediately. Use Dart's two-space indentation, prefer const constructors for stable widgets, and keep widget, state, and controller classes in UpperCamelCase (SplashScreen, _SplashScreenState). Files, assets, and test names stay snake_case. Keep animation configuration (controllers, tweens) inside the owning State and document non-trivial math with brief comments.

## Testing Guidelines
Rely on lutter_test (WidgetTester) for golden and interaction tests; smoke examples live in 	est/widget_test.dart. Name every test file *_test.dart and group scenarios with group() for readability. Target at least one widget test per screen and verify animation triggers (e.g., logo fade completes before navigation). Run lutter test --coverage locally and upload coverage/lcov.info if your CI checks coverage.

## Commit & Pull Request Guidelines
Existing history (Add animated splash screen prototype, Fix glow animation bounds for splash screen) shows short, imperative subject lines under 72 characters; continue that pattern and mention the component touched. Each PR should link to the tracking issue, summarize platform impact, include screenshots or screen recordings for UI work, and state how you tested (lutter test, target device). Keep PRs focused on a single feature to ease review.

## Assets & Configuration Tips
Register every image you add under the lutter.assets section in pubspec.yaml (e.g., ssets/logo.png) and store binaries in ssets/ with descriptive names. When introducing fonts, declare them next to the existing uses-material-design stanza. Update .env-style secrets via platform-specific secure stores rather than checking them into source.
