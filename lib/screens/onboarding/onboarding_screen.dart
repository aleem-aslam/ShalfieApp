import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP IMAGE + CIRCLE LOGO
            SizedBox(
              width: double.infinity,
              height: size.height * 0.45,
              child: Stack(
                clipBehavior: Clip.none, // 👈 IMPORTANT: allow logo to overflow
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/startedscreenbooks.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: -62, // you can change this to -20, -40, etc.
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.black,
                      child: Image.asset(
                        'assets/logos/splash_logo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 70), // space after overlapping logo
            // TEXT
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                "Read more and stress less with our online book "
                "shopping app. Shop from anywhere you are and "
                "discover titles that you love. Happy reading!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ),

            const Spacer(),

            // GET STARTED BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () => context.goNamed('login'),
                  child: const Text("Get Started"),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // REGISTER TEXT
            GestureDetector(
              onTap: () => context.goNamed('register'),
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
