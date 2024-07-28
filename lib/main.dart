import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pizza_app/HomeScreen/BottomBar.dart';
import 'package:pizza_app/HomeScreen/OnboardingScreen.dart';
import 'package:pizza_app/HomeScreen/RestaurantProvider.dart';
import 'package:pizza_app/Login/Login.dart';
import 'package:pizza_app/Login/LoginProvider.dart';
import 'package:pizza_app/Login/Signup.dart';
import 'package:pizza_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String ?uid = prefs.getString('uid');
  runApp( MyApp(initialRoute: uid!=null ? '/bottomBar' : '/onboarding'));
}

class MyApp extends StatelessWidget {
     final String initialRoute;

  const MyApp({super.key, required this.initialRoute});
  static const  reddish = Color.fromARGB(255, 95, 12, 6);

  @override
  Widget build(BuildContext context) {
    
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_)=> RestProvider())
      ],
    
   child:  MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: reddish),
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        routes: {
          '/bottomBar': (context) => const BottomBar(),
          '/onboarding': (context) => const OnboardingScreen(), 
          '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        },
        // home: Profile()
        ));
  }
}
