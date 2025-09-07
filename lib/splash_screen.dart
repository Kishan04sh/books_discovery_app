import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/app_colors.dart';
import 'package:books_discovery_app/providers/LogInController.dart';
import 'package:books_discovery_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    /// call function
    checkAuthAndNavigate();
  }

  /// ****************************************************
  Future<void> checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      // context.router.replace(const HomeRoute());
      context.router.replace(const TabsRoute());
    } else {
      context.router.replace(const OnboardingRoute());
    }
  }

  /// ***********************************************************

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: AppColors.offWhite,
                  child: Icon(
                    Icons.book_outlined,
                    size: screenWidth * 0.3,
                    color: AppColors.primary,
                  ),
                ),
              ),


              const SizedBox(height: 20),


              Text(
                "Book Discovery",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                  shadows: const [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 8),


              Text(
                "Explore. Read. Grow.",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
