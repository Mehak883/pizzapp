// ignore_for_file: use_build_context_synchronously, file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pizza_app/HomeScreen/BottomBar.dart';
import 'package:pizza_app/Login/LoginProvider.dart';
import 'package:pizza_app/main.dart';
import 'package:provider/provider.dart';
import 'package:pizza_app/Login/CustomWidget.dart';
import 'package:pizza_app/Utilities/FirebaseDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey1 = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<void> moveToLogin() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if (_formkey1.currentState != null && _formkey1.currentState!.validate()) {
      loginProvider.setLoading(true);
      var result = await FirebaseStore.signinUser(email.text.trim(), pass.text.trim());
      loginProvider.setLoading(false);
      if (result == true) {
        String uid=FirebaseAuth.instance.currentUser!.uid;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('uid', uid);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const BottomBar(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "Please Enter a Valid Email");
        } else if (errorCode == 'invalid-credential') {
          CustomSnackBar.showSnackBar(context, "Ok", () => null, 'Invalid Credentials');
        } else if (errorCode == 'wrong-password') {
          CustomSnackBar.showSnackBar(context, "Ok", () => null, 'Wrong Password');
        } else if (errorCode == "email-already-in-use") {
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "User Already Exist");
        } else if (errorCode == 'weak-password') {
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "Weak Password");
        } else if (errorCode == 'unknown') {
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "Something Went Wrong");
        } else if (errorCode == 'user-not-found') {
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "No User Found");
        } else if (errorCode == 'INVALID_LOGIN_CREDENTIALS') {
          CustomSnackBar.showSnackBar(context, "ok", () => {}, "Invalid login details");
        } else if (errorCode == 'network-request-failed') {
          CustomSnackBar.showSnackBar(context, "Ok", () => null, "Pleace Check Your Internet ");
        }
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      loginProvider.setLoading(true);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      loginProvider.setLoading(false);
      if (userCredential.user != null) {
         SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('uid', userCredential.user!.uid);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const BottomBar(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      loginProvider.setLoading(false);
      CustomSnackBar.showSnackBar(context, "ok", () => {}, e.code.toString());
    }
    return null;
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
                children: [
                  const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "No Account | ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text('Sign up',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: MyApp.reddish)),
                  ),
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
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your E-mail',
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can not be empty";
                          } else if (!value.contains('@')) {
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
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: pass,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Password',
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password can not be empty";
                          } else if (value.length < 6) {
                            return "Password should be greater than 6 digits";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          final loginProvider = Provider.of<LoginProvider>(context, listen: false);
                          loginProvider.setLoading(true);
                          await moveToLogin();
                          loginProvider.setLoading(false);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          backgroundColor: MyApp.reddish,
                        ),
                        child: loginProvider.isLoading
                            ? const SpinKitWave(size: 22, color: Colors.white)
                            : const Text(
                                'Sign in',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            signInWithGoogle();
                          },
                          child: Row(
                            children: [
                              const Text(
                                'Sign in with',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 15),
                              Image.asset('assets/Google.png')
                            ],
                          ),
                        ),
                      ],
                    ),
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
