import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'name_input_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  final List<Map<String, String>> slides = [
    {
      "title": "Welcome to PETRO",
      "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    },
    {
      "title": "Capture Your Pet Moments",
      "description": "Record and share your furry friends' best shots.",
    },
    {
      "title": "Get Inspired",
      "description": "See how others bond with their pets across the world.",
    },
    {
      "title": "Build Your Pet Legacy",
      "description": "Document milestones, birthdays, and everyday fun.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == slides.length - 1;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 80,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/logo.png',
                    ), // Replace with a background or placeholder
                    fit: BoxFit.cover,
                    opacity: 0.05,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      slides[index]["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      slides[index]["description"]!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          // Indicator + Skip/Next button
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: slides.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.tealAccent,
                    dotColor: Colors.white24,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (onLastPage) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NameInputPage(),
                        ),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent[700],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 80,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(onLastPage ? 'Continue' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
