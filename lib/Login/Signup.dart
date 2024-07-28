// ignore_for_file: use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pizza_app/HomeScreen/BottomBar.dart';
import 'package:pizza_app/Login/CustomWidget.dart';
import 'package:pizza_app/Login/Login.dart';
import 'package:pizza_app/Login/LoginProvider.dart';
import 'package:pizza_app/Utilities/FirebaseDatabase.dart';
import 'package:pizza_app/Utilities/UserData.dart';
import 'package:pizza_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  final _formkey1 = GlobalKey<FormState>();
  bool isLoading = false;
  Future<UserCredential?> signUpWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        await UserData.userdata(FirebaseAuth.instance.currentUser!.uid,
            userCredential.user!.email.toString());
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('uid', userCredential.user!.uid);

        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const BottomBar(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      }
      // Once signed in, return the UserCredential
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showSnackBar(context, "ok", () => {}, e.code.toString());
    }
    return null;
  }

  Future<void> moveToSignup() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    if (_formkey1.currentState != null && _formkey1.currentState!.validate()) {
      loginProvider.setLoading(true);
      var result = await FirebaseStore.createUser(email.text, pass.text.trim());
      loginProvider.setLoading(false);

      if (result == true) {
        // var SharedPref = await SharedPreferences.getInstance();
        // SharedPref.setBool(splash_screenState.KEYLOGIN, true);
        await UserData.userdata(
            FirebaseAuth.instance.currentUser!.uid, email.text);

        // context.go('/');
        String uid = FirebaseAuth.instance.currentUser!.uid;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('uid', uid);

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const BottomBar(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );

      } else if (result is String) {
        String errorCode = result;
        if (errorCode == "invalid-email") {
          CustomSnackBar.showSnackBar(
              context, "ok", () => {}, "Please Enter a Valid Email");
        } else if (errorCode == "email-already-in-use") {
          CustomSnackBar.showSnackBar(
              context, "ok", () => {}, "User Already Exist");
        } else if (errorCode == 'weak-password') {
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "Weak Password");
        } else if (errorCode == 'network-request-failed') {
          CustomSnackBar.showSnackBar(
              context, "Ok", () => null, "Pleace Check Your Internet ");
        }
      } else {
      
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 450,
              child: Stack(
                children: [
                  Positioned(
                    top: 150,
                    left: 25,
                    child: Container(
                      height: 280,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        color: MyApp.reddish,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: (MediaQuery.of(context).size.width) / 10,
                    child: Image.asset(
                      'assets/loginGirl.png',
                      height: 380,
                      width: 500,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Already account | ',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text('Sign in',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: MyApp.reddish))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Form(
                key: _formkey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'E-mail',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                            hintText: 'Enter Your E-mail',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can not be empty";
                          } else if (value.contains('@') == false) {
                            return "Please enter a valid Email";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Password',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                          obscureText: true,
                          controller: pass,
                          decoration: const InputDecoration(
                              hintText: 'Enter Your Password',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password can not be empty";
                            } else if (value.length < 6) {
                              return "Password should be greater then 6 digits";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          final loginProvider = Provider.of<LoginProvider>(
                              context,
                              listen: false);
                          loginProvider.setLoading(true);
                          await moveToSignup();
                          loginProvider.setLoading(false);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          backgroundColor: MyApp.reddish,
                        ),
                        child: loginProvider.isLoading
                            ? const SpinKitWave(
                                color: Colors.white,
                                size: 22,
                              )
                            : const Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            signUpWithGoogle();
                          },
                          child: Row(
                            children: [
                              const Text(
                                'Sign up with',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Image.asset('assets/Google.png')
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
