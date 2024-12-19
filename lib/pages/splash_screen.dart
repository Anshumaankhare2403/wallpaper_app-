// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import './home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/LOGO.png'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(90)),
            ),
          ),
        ),
      ),
    );
  }
}
