import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  // ── Palette ──────────────────────────────────────────────
  static const _bg         = Color(0xFF0A0A0A);
  static const _surface    = Color(0xFF141414);
  static const _surfaceMid = Color(0xFF1C1C1C);
  static const _border     = Color(0xFF2A2A2A);
  static const _ash        = Color(0xFF8A8A8A);
  static const _ashLight   = Color(0xFFB0B0B0);
  static const _white      = Color(0xFFF2F2F2);
  static const _accent     = Color(0xFFD4D4D4);
  static const _accentGlow = Color(0xFF3A3A3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 36),
                _buildCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _surfaceMid,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border, width: 1.2),
          ),
          child: const Icon(Icons.school_rounded, color: _ashLight, size: 26),
        ),
        const SizedBox(height: 20),
        const Text(
          "Welcome back.",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: _white,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.8, height: 1.1),
            children: [
              TextSpan(text: "Class ", style: TextStyle(color: _ash)),
              TextSpan(text: "Connect", style: TextStyle(color: _accent)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Sign in to continue learning",
          style: TextStyle(color: _ash, fontSize: 13.5, letterSpacing: 0.1),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInput("Email", emailController, false),
          const SizedBox(height: 14),
          _buildInput("Password", passwordController, true),
          const SizedBox(height: 8),
          _buildForgot(),
          const SizedBox(height: 20),
          _buildLoginButton(),
          _buildDivider(),
          _buildGoogleButton(),
          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _ash,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: isPassword ? !showPassword : false,
          style: const TextStyle(color: _white, fontSize: 14.5),
          cursorColor: _accent,
          decoration: InputDecoration(
            hintText: isPassword ? "••••••••" : "you@example.com",
            hintStyle: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 14),
            filled: true,
            fillColor: _surfaceMid,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _accent, width: 1.2),
            ),
            suffixIcon: isPassword
                ? TextButton(
                    onPressed: () => setState(() => showPassword = !showPassword),
                    child: Text(
                      showPassword ? "Hide" : "Show",
                      style: const TextStyle(color: _ash, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildForgot() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {},
        child: const Text(
          "Forgot password?",
          style: TextStyle(color: _ash, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _accent,
        boxShadow: [
          BoxShadow(
            color: _accentGlow.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // TODO: add navigation later
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          "Log In",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0A0A0A), letterSpacing: 0.3),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: const [
          Expanded(child: Divider(color: Color(0xFF262626))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text("or", style: TextStyle(color: Color(0xFF444444), fontSize: 12)),
          ),
          Expanded(child: Divider(color: Color(0xFF262626))),
        ],
      ),
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: _surfaceMid,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: _border, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.g_mobiledata_rounded, size: 22, color: _ash),
          SizedBox(width: 8),
          Text(
            "Continue with Google",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _ashLight),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Color(0xFF555555), fontSize: 13),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            "Sign Up",
            style: TextStyle(color: _ashLight, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }
}