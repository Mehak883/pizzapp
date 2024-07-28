// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:pizza_app/HomeScreen/BottomBar.dart';
import 'package:pizza_app/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _animateImage = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _animateImage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.reddish,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;

          // Calculate white container height and image size
          final double containerHeight = screenHeight * 0.4;
          final double imageHeight = screenHeight * 0.5; // Increased image height
          final double imageWidth = screenWidth * 0.9; // Adjusted width to match

          return Stack(
            children: [
              Positioned(
                left: screenWidth * 0.2,
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.4,
                  color: Colors.amber[300],
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.1,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: screenWidth * 0.9,
                    height: containerHeight,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Quick Delivery at your ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32, // Adjusted font size
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                ),
                                TextSpan(
                                  text: 'Doorstep',
                                  style: TextStyle(
                                      color: MyApp.reddish,
                                      fontSize: 32, // Adjusted font size
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            loremIpsum(words: 14),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: MyApp.reddish,
                                fontWeight: FontWeight.w500,
                                height: 1),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            width: screenWidth * 0.6,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyApp.reddish,
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomBar()));
                              },
                              child: const Text(
                                'Get Started',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                top: _animateImage ? (screenHeight * 0.1 + containerHeight - imageHeight) : screenHeight, // Adjusted to use screen height
                left: 0,
                right: 0,
                duration: const Duration(seconds: 1),
                child: Align(
                  alignment: Alignment.center,
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    width: imageWidth, // Adjusted width to be responsive
                    height: imageHeight, // Increased height for larger image
                    child: Image.asset(
                      'assets/PizzaGirl.png',
                      fit: BoxFit.cover,
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
