import 'package:flutter/material.dart';
import '../theme/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: surfaceMid,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: const Icon(Icons.school_rounded, color: ashLight, size: 30),
              ),
              const SizedBox(height: 20),
              const Text("You're in!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
                      color: white, letterSpacing: -0.8)),
              const SizedBox(height: 8),
              const Text("Home screen coming soon.",
                  style: TextStyle(color: ash, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}