import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:note_mory/presentation/login_page.dart';
import 'package:note_mory/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: const Color(0xFF440C0C),
      pages: [
        PageViewModel(
          title: "Welcome to NoteMory",
          body: "Create and manage your notes easily.",
          image: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/images/onboarding_1.png',
                width: 300,
              ),
            ],
          ),
          decoration: const PageDecoration(
            bodyFlex: 2,
            imageFlex: 4,
            imagePadding: EdgeInsets.all(24),
            pageColor: Color(0xFF440C0C),
            bodyTextStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        PageViewModel(
          title: "Stay Organized",
          body: "Keep your notes organized with ease.",
          image: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const SizedBox(height: 30),
              Image.asset('assets/images/onboarding_2.png', width: 300),
            ],
          ),
          decoration: const PageDecoration(
            bodyFlex: 2,
            imageFlex: 4,
            imagePadding: EdgeInsets.all(24),
            pageColor: Color(0xFF440C0C),
            bodyTextStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        PageViewModel(
          title: "Never Forget",
          body: "With NoteMory, your notes are always with you.",
          image: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const SizedBox(height: 30),
              Image.asset('assets/images/onboarding_3.png', width: 300),
            ],
          ),
          decoration: const PageDecoration(
            bodyFlex: 2,
            imageFlex: 4,
            imagePadding: EdgeInsets.all(24),
            pageColor: Color(0xFF440C0C),
            bodyTextStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
      onDone: () async {
        /// Navigasi ke halaman login atau halaman utama setelah onboarding selesai
        await Provider.of<OnboardingProvider>(context, listen: false)
            .setFirstTime(false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      onSkip: () async {
        /// Navigasi ke halaman login atau halaman utama jika "Skip" ditekan
        await Provider.of<OnboardingProvider>(context, listen: false)
            .setFirstTime(false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFE082),
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Color(0xFFFFE082),
      ),
      done: const Text(
        'Done', // Teks tombol Done
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFE082),
        ),
      ),
      dotsDecorator: DotsDecorator(
        color: Colors.black,
        activeColor: const Color(0xFFFFE082),
        size: const Size(10.0, 10.0),
        activeSize: const Size(22.0, 10.0),
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
