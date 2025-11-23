import 'package:flutter/material.dart';

/// A flexible splash screen suitable for MVP evolution.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _glowController;

  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    // Logo fade animation.
    _logoController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    // Text fade animation.
    _textController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _textFade = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    // Soft glow pulsing behind the logo.
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowPulse = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    // Kick off staged animations.
    _logoController.forward();
    _textController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Background gradient with inverted ordering for dark themes.
    final Color topColor =
        isDark ? const Color(0xFFEFE4FF) : const Color(0xFFF9F5FF);
    final Color bottomColor =
        isDark ? const Color(0xFFF9F5FF) : const Color(0xFFEFE4FF);

    final double logoSize = size.width * 0.35;
    final double minSpacing = size.height * 0.02;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [topColor, bottomColor],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: minSpacing * 1.5),
                // Logo section with fallback and glow.
                LogoWidget(
                  size: logoSize.clamp(120.0, 240.0),
                  fadeAnimation: _logoFade,
                  glowAnimation: _glowPulse,
                ),
                SizedBox(height: minSpacing),
                // Brand name.
                BrandNameWidget(fadeAnimation: _textFade),
                SizedBox(height: minSpacing * 0.6),
                // Tagline text.
                TaglineWidget(fadeAnimation: _textFade),
                // Spacer to push language selector to the bottom.
                const Expanded(child: SizedBox()),
                Padding(
                  padding: EdgeInsets.only(bottom: minSpacing * 1.5),
                  // Language selector placeholder actions.
                  child: const LanguageSelectorWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo widget with animated glow and graceful asset fallback.
class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
    required this.size,
    required this.fadeAnimation,
    required this.glowAnimation,
  });

  final double size;
  final Animation<double> fadeAnimation;
  final Animation<double> glowAnimation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: AnimatedBuilder(
        animation: glowAnimation,
        builder: (context, child) {
          final double intensity = glowAnimation.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size * 1.25,
                height: size * 1.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x885A2D82).withOpacity(0.4 * intensity),
                      blurRadius: 40 * intensity,
                      spreadRadius: 8 * intensity,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF5A2D82).withOpacity(0.3)),
                      ),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        size: size * 0.45,
                        color: const Color(0xFF5A2D82),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Brand name text styling.
class BrandNameWidget extends StatelessWidget {
  const BrandNameWidget({super.key, required this.fadeAnimation});

  final Animation<double> fadeAnimation;

  @override
  Widget build(BuildContext context) {
    final double fontSize = (MediaQuery.of(context).size.width * 0.12).clamp(26.0, 40.0);
    return FadeTransition(
      opacity: fadeAnimation,
      child: Text(
        'Talala',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5A2D82),
              letterSpacing: 0.8,
            ) ??
            const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5A2D82),
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}

/// Tagline text styling.
class TaglineWidget extends StatelessWidget {
  const TaglineWidget({super.key, required this.fadeAnimation});

  final Animation<double> fadeAnimation;

  @override
  Widget build(BuildContext context) {
    final double fontSize = (MediaQuery.of(context).size.width * 0.045).clamp(12.0, 16.0);
    return FadeTransition(
      opacity: fadeAnimation,
      child: Text(
        'Your Event, One Connection',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: fontSize,
              color: Colors.grey.shade700,
              letterSpacing: 1.2,
            ) ??
            TextStyle(
              fontSize: fontSize,
              color: Colors.grey.shade700,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

/// Language selection placeholder.
class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade600,
          letterSpacing: 0.6,
        ) ??
        TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
          letterSpacing: 0.6,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // TODO: Wire Arabic selection when MVP flow is ready.
          },
          child: Text('العربية', style: style),
        ),
        Text('  |  ', style: style),
        GestureDetector(
          onTap: () {
            // TODO: Wire English selection when MVP flow is ready.
          },
          child: Text('English', style: style),
        ),
      ],
    );
  }
}
