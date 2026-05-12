import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/api.dart';
import '../theme/theme.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();
  final confCtrl  = TextEditingController();
  bool showPass   = false;
  bool loading    = false;

  Future<void> _register() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty || confCtrl.text.isEmpty) {
      showSnack(context, "Please fill all fields", error: true);
      return;
    }
    if (passCtrl.text != confCtrl.text) {
      showSnack(context, "Passwords do not match", error: true);
      return;
    }
    if (passCtrl.text.length < 6) {
      showSnack(context, "Password must be at least 6 characters", error: true);
      return;
    }

    setState(() => loading = true);

    try {
      final res = await dio.post("/auth/register", data: {
        "email": emailCtrl.text.trim(),
        "password": passCtrl.text.trim(),
      });

      if (res.statusCode == 200) {
        showSnack(context, "OTP sent to your email!");
        Navigator.push(context,
            MaterialPageRoute(builder: (_) =>
                OtpScreen(email: emailCtrl.text.trim(), isSignUp: true)));
      }
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ?? "Registration failed";
      showSnack(context, msg.toString(), error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ash, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildPageTitle("Create account", "Enter your email and choose a password."),
            const SizedBox(height: 28),
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
              const SizedBox(height: 14),
              buildLabel("Confirm Password"),
              buildTextField(confCtrl, "••••••••", obscure: true),
              const SizedBox(height: 24),
              buildPrimaryButton("Continue", _register, loading: loading),
            ])),
          ]),
        ),
      ),
    );
  }
}