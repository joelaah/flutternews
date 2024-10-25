import 'package:demo_news/auth/helper/helper_function.dart';
import 'package:demo_news/components/my_buttons.dart';
import 'package:demo_news/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  final void Function()? onTap;
  const Loginpage({super.key, required this.onTap});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController usernamecontroller = TextEditingController();

  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmpwController = TextEditingController();

  //register
  void registerUser() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    //password not match
    if (passwordController.text != confirmpwController.text) {
      if (mounted) {
        Navigator.pop(context);
        displayMessageToUser("Password dont match", context);
      }
    }
    //create user
    else {
      try {
        //create user
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailcontroller.text, password: passwordController.text);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.newspaper,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 25,
              ),
              //app name
              const Text('News App'),
              const SizedBox(height: 25),
              //username
              MyTextfield(
                  hintText: "User Name",
                  obscureText: false,
                  controller: usernamecontroller),
              const SizedBox(
                height: 10,
              ),
              //emailtextfield
              MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailcontroller),
              const SizedBox(
                height: 10,
              ),
              //pw testfield
              MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController),
              const SizedBox(
                height: 10,
              ),
              //confirm password
              MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: false,
                  controller: confirmpwController),
              const SizedBox(
                height: 10,
              ),
              //forgot pw
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
              const SizedBox(height: 25),
              //sign in button
              MyButtons(text: 'Register', onTap: registerUser),
              //dont have account register
              Row(
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Login here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
