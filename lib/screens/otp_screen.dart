import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/api.dart';
import '../theme/theme.dart';
import 'profile_screen.dart';
import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isSignUp;
  const OtpScreen({super.key, required this.email, this.isSignUp = false});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  bool loading = false;

  String get _otpCode => controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otpCode.length < 6) {
      showSnack(context, "Enter the full 6-digit code", error: true);
      return;
    }
    setState(() => loading = true);
    try {
      final res = await dio.post("/auth/verify-otp", data: {
        "email": widget.email,
        "otp_code": _otpCode,
      });
      if (res.statusCode == 200) {
        showSnack(context, "Email verified!");
        if (widget.isSignUp) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ProfileScreen(email: widget.email)));
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
        }
      }
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ?? "Invalid OTP";
      showSnack(context, msg.toString(), error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _resend() async {
    try {
      await dio.post("/auth/resend-otp",
          data: {"email": widget.email, "password": ""});
      showSnack(context, "OTP resent!");
    } catch (_) {
      showSnack(context, "Failed to resend OTP", error: true);
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
            buildPageTitle("Check your email", "A verification code was sent to"),
            const SizedBox(height: 6),
            Text(widget.email,
                style: const TextStyle(color: accent, fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 28),
            buildCard(Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 44,
                    child: TextField(
                      controller: controllers[i],
                      focusNode: focusNodes[i],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: white, fontSize: 20,
                          fontWeight: FontWeight.w700),
                      cursorColor: accent,
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: surfaceMid,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: border)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: border)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: accent, width: 1.4)),
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 5) focusNodes[i + 1].requestFocus();
                        if (v.isEmpty && i > 0) focusNodes[i - 1].requestFocus();
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              buildPrimaryButton("Verify", _verify, loading: loading),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _resend,
                  child: const Text("Resend code",
                      style: TextStyle(color: ash, fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ])),
          ]),
        ),
      ),
    );
  }
}