import 'package:aikeen_park/button.dart';
import 'package:aikeen_park/csv.dart';
import 'package:aikeen_park/screens/home.dart';
import 'package:aikeen_park/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aikeen_park/constants.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'http.dart';

class LogIn extends StatefulWidget {
  //const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown[400],
        elevation: 20.0,
        title: Text(
            // style: GoogleFonts.getFont(
            //     fontSize: 40, color: Colors.pink[200], 'Lobster'),
            // 'AikeenPark'),
            style: GoogleFonts.montserrat(
              fontSize: 33,
              color: Colors.white,
            ),
            'AikeenPark'),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.lightBlue.withOpacity(0.8),
                                BlendMode.modulate),
                            image: const AssetImage("assets/background1.png"),
                            fit: BoxFit.cover),
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      //color: Colors.grey[200],
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 200),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Email";
                                }
                                return null;
                              },
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                filled: true,
                                fillColor: Colors.white60,
                                hintText: 'Email',
                                prefixIcon: const Icon(Icons.email,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Password";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                password = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                  filled: true,
                                  fillColor: Colors.white60,
                                  hintText: 'Password',
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Colors.black)),
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                              title: 'Login',
                              onPoke: () async {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);

                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const Home(),
                                      ),
                                    );

                                    setState(() {
                                      isloading = false;
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Oops! Login Failed"),
                                        content: Text('${e.message}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text('Okay'),
                                          )
                                        ],
                                      ),
                                    );
                                    print(e);
                                  }
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an Account ?",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.lime[100]),
                                  ),
                                  const SizedBox(width: 10),
                                  const Hero(
                                    tag: '1',
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lime),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            // Uncomment to test current User
                            // ElevatedButton(
                            //   onPressed: () {
                            //     print(FirebaseAuth.instance.currentUser);
                            //   },
                            //   child: const Text("testing curUser"),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

//Tester Function for SignIn and SignOut
//   Future<void> _signIn(String email, String password) async {
//     UserCredential userCredential = await FirebaseAuth.instance
//         .signInWithEmailAndPassword(email: email, password: password);
//     print(userCredential);
//   }

//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }

}
