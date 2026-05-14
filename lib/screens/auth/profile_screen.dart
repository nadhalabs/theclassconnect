import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../config/api.dart';
import '../../theme/theme.dart';
import '../onboarding/role_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String email;
  const ProfileScreen({super.key, required this.email});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameCtrl     = TextEditingController();
  final usernameCtrl = TextEditingController();
  final dobCtrl      = TextEditingController();
  bool loading       = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
              primary: accent, onPrimary: bg, surface: surface),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dobCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  Future<void> _saveProfile() async {
    if (nameCtrl.text.isEmpty || usernameCtrl.text.isEmpty || dobCtrl.text.isEmpty) {
      showSnack(context, "Please fill all fields", error: true);
      return;
    }
    setState(() => loading = true);
    try {
      final res = await dio.post("/auth/profile", data: {
        "email": widget.email,
        "full_name": nameCtrl.text.trim(),
        "username": usernameCtrl.text.trim().replaceAll("@", ""),
        "date_of_birth": dobCtrl.text.trim(),
      });
      if (res.statusCode == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) =>
                RoleScreen(email: widget.email,
                    name: nameCtrl.text.trim())));
      }
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ?? "Failed to save profile";
      showSnack(context, msg.toString(), error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ash, size: 18),
            onPressed: () => Navigator.pop(context),
          )),
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
                child: AbsorbPointer(child: buildTextField(dobCtrl, "DD / MM / YYYY")),
              ),
              const SizedBox(height: 24),
              buildPrimaryButton("Continue", _saveProfile, loading: loading),
            ])),
          ]),
        ),
      ),
    );
  }
}