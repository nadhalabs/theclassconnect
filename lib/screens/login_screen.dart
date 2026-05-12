import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/api.dart';
import '../theme/theme.dart';
import 'signup_screen.dart';
import 'otp_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();
  bool showPass   = false;
  bool loading    = false;

  Future<void> _login() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      showSnack(context, "Please fill all fields", error: true);
      return;
    }

    setState(() => loading = true);

    try {
      final res = await dio.post("/auth/login", data: {
        "email": emailCtrl.text.trim(),
        "password": passCtrl.text.trim(),
      });

      if (res.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (_) => false);
      }
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ?? "Login failed";
      if (msg.toString().contains("not verified")) {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => OtpScreen(
                    email: emailCtrl.text.trim(), isSignUp: false)));
      } else {
        showSnack(context, msg.toString(), error: true);
      }
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                  color: surfaceMid,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border, width: 1.2)),
              child: const Icon(Icons.school_rounded, color: ashLight, size: 26),
            ),
            const SizedBox(height: 20),
            const Text("Welcome back.",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700,
                    color: white, letterSpacing: -0.8)),
            const SizedBox(height: 4),
            RichText(
              text: const TextSpan(
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700,
                      letterSpacing: -0.8),
                  children: [
                    TextSpan(text: "Class ", style: TextStyle(color: ash)),
                    TextSpan(text: "Connect", style: TextStyle(color: accent)),
                  ]),
            ),
            const SizedBox(height: 10),
            const Text("Sign in to continue learning",
                style: TextStyle(color: ash, fontSize: 13.5)),
            const SizedBox(height: 32),
            buildCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildLabel("Email"),
              buildTextField(emailCtrl, "you@example.com",
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              buildLabel("Password"),
              buildTextField(passCtrl, "••••••••",
                  obscure: !showPass,
                  suffix: TextButton(
                    onPressed: () => setState(() => showPass = !showPass),
                    child: Text(showPass ? "Hide" : "Show",
                        style: const TextStyle(color: ash, fontSize: 12)),
                  )),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text("Forgot password?",
                      style: TextStyle(color: ash, fontSize: 12)),
                ),
              ),
              const SizedBox(height: 20),
              buildPrimaryButton("Log In", _login, loading: loading),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? ",
                    style: TextStyle(color: Color(0xFF555555), fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  child: const Text("Sign Up",
                      style: TextStyle(color: ashLight,
                          fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ]),
            ])),
          ]),
        ),
      ),
    );
  }
}