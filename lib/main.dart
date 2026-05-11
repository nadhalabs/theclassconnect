import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Class Connect',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// PALETTE
// ─────────────────────────────────────────────
const _bg         = Color(0xFF0A0A0A);
const _surface    = Color(0xFF141414);
const _surfaceMid = Color(0xFF1C1C1C);
const _border     = Color(0xFF2A2A2A);
const _ash        = Color(0xFF8A8A8A);
const _ashLight   = Color(0xFFB0B0B0);
const _white      = Color(0xFFF2F2F2);
const _accent     = Color(0xFFD4D4D4);

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
Widget buildLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _ash,
              letterSpacing: 0.6)),
    );

Widget buildTextField(
    TextEditingController controller, String hint,
    {bool obscure = false, Widget? suffix, TextInputType? keyboardType}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    style: const TextStyle(color: _white, fontSize: 14.5),
    cursorColor: _accent,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 14),
      filled: true,
      fillColor: _surfaceMid,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _accent, width: 1.2)),
      suffixIcon: suffix,
    ),
  );
}

Widget buildPrimaryButton(String label, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _accent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0A0A0A),
              letterSpacing: 0.3)),
    ),
  );
}

Widget buildCard(Widget child) {
  return Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _border),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 40,
            offset: const Offset(0, 12))
      ],
    ),
    child: child,
  );
}

Widget buildPageTitle(String title, String sub) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title,
        style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: _white,
            letterSpacing: -0.8,
            height: 1.1)),
    const SizedBox(height: 8),
    Text(sub, style: const TextStyle(color: _ash, fontSize: 13.5)),
  ]);
}

// ─────────────────────────────────────────────
// 1. LOGIN SCREEN
// ─────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();
  bool showPass   = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Logo
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                  color: _surfaceMid,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border, width: 1.2)),
              child: const Icon(Icons.school_rounded, color: _ashLight, size: 26),
            ),
            const SizedBox(height: 20),
            const Text("Welcome back.",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: _white, letterSpacing: -0.8)),
            const SizedBox(height: 4),
            RichText(
              text: const TextSpan(
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.8),
                  children: [
                    TextSpan(text: "Class ", style: TextStyle(color: _ash)),
                    TextSpan(text: "Connect", style: TextStyle(color: _accent)),
                  ]),
            ),
            const SizedBox(height: 10),
            const Text("Sign in to continue learning",
                style: TextStyle(color: _ash, fontSize: 13.5)),
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
                        style: const TextStyle(color: _ash, fontSize: 12)),
                  )),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text("Forgot password?",
                      style: TextStyle(color: _ash, fontSize: 12)),
                ),
              ),
              const SizedBox(height: 20),
              buildPrimaryButton("Log In", () {
                if (emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => OtpScreen(email: emailCtrl.text)));
                }
              }),
              const SizedBox(height: 18),
              Row(children: const [
                Expanded(child: Divider(color: Color(0xFF262626))),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("or", style: TextStyle(color: Color(0xFF444444), fontSize: 12)),
                ),
                Expanded(child: Divider(color: Color(0xFF262626))),
              ]),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: _surfaceMid,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: _border),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                  Icon(Icons.g_mobiledata_rounded, size: 22, color: _ash),
                  SizedBox(width: 8),
                  Text("Continue with Google",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _ashLight)),
                ]),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? ",
                    style: TextStyle(color: Color(0xFF555555), fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignUpEmailScreen())),
                  child: const Text("Sign Up",
                      style: TextStyle(color: _ashLight, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ]),
            ])),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 2. SIGN UP — EMAIL & PASSWORD
// ─────────────────────────────────────────────
class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({super.key});
  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();
  final confCtrl  = TextEditingController();
  bool showPass   = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ash, size: 18),
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
              buildTextField(passCtrl, "••••••••", obscure: !showPass,
                  suffix: TextButton(
                    onPressed: () => setState(() => showPass = !showPass),
                    child: Text(showPass ? "Hide" : "Show",
                        style: const TextStyle(color: _ash, fontSize: 12)),
                  )),
              const SizedBox(height: 14),
              buildLabel("Confirm Password"),
              buildTextField(confCtrl, "••••••••", obscure: true),
              const SizedBox(height: 24),
              buildPrimaryButton("Continue", () {
                if (emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => OtpScreen(email: emailCtrl.text, isSignUp: true)));
                }
              }),
            ])),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 3. OTP VERIFICATION
// ─────────────────────────────────────────────
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ash, size: 18),
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
                style: const TextStyle(
                    color: _accent, fontSize: 14, fontWeight: FontWeight.w600)),
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
                      style: const TextStyle(
                          color: _white, fontSize: 20, fontWeight: FontWeight.w700),
                      cursorColor: _accent,
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: _surfaceMid,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _accent, width: 1.4)),
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 5) {
                          focusNodes[i + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              buildPrimaryButton("Verify", () {
                if (widget.isSignUp) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()));
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (_) => false);
                }
              }),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: const Text("Resend code",
                      style: TextStyle(color: _ash, fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ),
            ])),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 4. PROFILE — Name, Username, DOB
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameCtrl     = TextEditingController();
  final usernameCtrl = TextEditingController();
  final dobCtrl      = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
              primary: _accent, onPrimary: _bg, surface: _surface),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dobCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ash, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildPageTitle("Your profile", "Tell us a bit about yourself."),
            const SizedBox(height: 28),
            buildCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildLabel("Full Name"),
              buildTextField(nameCtrl, "John Doe"),
              const SizedBox(height: 14),
              buildLabel("Username"),
              buildTextField(usernameCtrl, "@yourusername"),
              const SizedBox(height: 14),
              buildLabel("Date of Birth"),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: buildTextField(dobCtrl, "DD / MM / YYYY"),
                ),
              ),
              const SizedBox(height: 24),
              buildPrimaryButton("Continue", () {
                if (nameCtrl.text.isNotEmpty && usernameCtrl.text.isNotEmpty && dobCtrl.text.isNotEmpty) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CollegeScreen()));
                }
              }),
            ])),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 5. COLLEGE / SCHOOL SELECTION
// ─────────────────────────────────────────────
const List<String> _colleges = [
  "MIT — Massachusetts Institute of Technology",
  "Stanford University",
  "Harvard University",
  "IIT Bombay",
  "IIT Delhi",
  "IIT Madras",
  "University of Oxford",
  "University of Cambridge",
  "National University of Singapore",
  "UC Berkeley",
  "Caltech",
  "ETH Zurich",
  "University of Toronto",
  "University of Melbourne",
  "Delhi University",
  "Amrita Vishwa Vidyapeetham",
  "BITS Pilani",
  "VIT University",
  "Anna University",
  "Cochin University of Science and Technology",
];

class CollegeScreen extends StatefulWidget {
  const CollegeScreen({super.key});
  @override
  State<CollegeScreen> createState() => _CollegeScreenState();
}

class _CollegeScreenState extends State<CollegeScreen> {
  final searchCtrl = TextEditingController();
  String? selected;
  List<String> filtered = _colleges;

  void _onSearch(String q) {
    setState(() {
      filtered = _colleges
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ash, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildPageTitle("Connect to your\ninstitution",
                "Search and select your college or school."),
            const SizedBox(height: 24),
            // Search bar
            TextField(
              controller: searchCtrl,
              onChanged: _onSearch,
              style: const TextStyle(color: _white, fontSize: 14),
              cursorColor: _accent,
              decoration: InputDecoration(
                hintText: "Search college or school...",
                hintStyle: const TextStyle(color: Color(0xFF3A3A3A)),
                filled: true,
                fillColor: _surfaceMid,
                prefixIcon: const Icon(Icons.search_rounded, color: _ash, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _accent, width: 1.2)),
              ),
            ),
            const SizedBox(height: 16),
            // List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.isEmpty ? 1 : filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Color(0xFF222222), height: 1),
                  itemBuilder: (_, i) {
                    if (filtered.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text("No results found",
                              style: TextStyle(color: _ash, fontSize: 13)),
                        ),
                      );
                    }
                    final college = filtered[i];
                    final isSelected = selected == college;
                    return ListTile(
                      onTap: () => setState(() => selected = college),
                      title: Text(college,
                          style: TextStyle(
                              color: isSelected ? _accent : _ashLight,
                              fontSize: 13.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: _accent, size: 18)
                          : null,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            buildPrimaryButton(
              selected == null ? "Select a college to continue" : "Join ${ selected!.split('—').first.trim()}",
              selected == null
                  ? () {}
                  : () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                      ),
            ),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 6. HOME SCREEN (placeholder)
// ─────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: _surfaceMid,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _border),
                ),
                child: const Icon(Icons.school_rounded, color: _ashLight, size: 30),
              ),
              const SizedBox(height: 20),
              const Text("You're in!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _white, letterSpacing: -0.8)),
              const SizedBox(height: 8),
              const Text("Home screen coming soon.",
                  style: TextStyle(color: _ash, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}