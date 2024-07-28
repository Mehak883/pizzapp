// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pizza_app/HomeScreen/BottomBar.dart';
import 'package:pizza_app/Utilities/FirebaseDatabase.dart';
import 'package:pizza_app/main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ValueNotifier<bool> _statusNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Center(
                child: CircleAvatar(
              backgroundColor: MyApp.reddish,
              radius: 100,
              child: Icon(
                Icons.person,
                size: 150,
                color: Colors.white,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/page.png',
                        color: MyApp.reddish,
                      ),
                      // ignore: prefer_const_constructors
                      Text(
                        ' Edit Profile information',
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _statusNotifier,
                    builder: (context, status, child) {
                      return Row(
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: MyApp.reddish,
                          ),
                          const Text(
                            ' Notification',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          FlutterSwitch(
                            width: 55.0,
                            height: 23.0,
                            toggleSize: 17.0,
                            value: status,
                            activeColor: const Color.fromARGB(255, 241, 202, 88),
                            borderRadius: 20.0,
                            onToggle: (val) {
                              _statusNotifier.value = val;
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(status ? 'ON' : 'OFF',
                              style: const TextStyle(fontSize: 20)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/wallet.png',
                        width: 24,
                        height: 24,
                        color: MyApp.reddish,
                      ),
                      const Text(
                        ' Wallet',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 23,
                  ),
               GestureDetector(
  onTap: () async {
    await FirebaseStore.signOut();
    // Check if Navigator has routes before using pushReplacement
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const BottomBar(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
      (route) => false, // Removes all existing routes
    );
  },
  child: Row(
    children: [
      SvgPicture.asset(
        'assets/logout.svg',
        color: MyApp.reddish,
      ),
      const Text(
        ' Log Out',
        style: TextStyle(color: MyApp.reddish, fontSize: 20),
      ),
    ],
  ),
)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _statusNotifier.dispose();
    super.dispose();
  }
}
