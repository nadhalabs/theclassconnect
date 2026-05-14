import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../config/api.dart';
import '../../theme/theme.dart';
import '../home/advisor_home.dart';

class AdvisorCodeScreen extends StatefulWidget {
  final String email;
  final String name;
  const AdvisorCodeScreen({super.key, required this.email, required this.name});
  @override
  State<AdvisorCodeScreen> createState() => _AdvisorCodeScreenState();
}

class _AdvisorCodeScreenState extends State<AdvisorCodeScreen> {
  final codeCtrl   = TextEditingController();
  final streamCtrl = TextEditingController();
  String? selectedStream;
  bool loading = false;

  final List<String> streams = [
    'Computer Science Engineering',
    'Data Science',
    'Electronics & Communication',
    'Electrical & Electronics',
    'Civil Engineering',
    'Mechanical Engineering',
  ];

  Future<void> _submit() async {
    if (codeCtrl.text.isEmpty || selectedStream == null) {
      showSnack(context, "Please fill all fields", error: true);
      return;
    }
    setState(() => loading = true);
    try {
      final res = await dio.post("/auth/teacher-onboard", data: {
        "email": widget.email,
        "teacher_type": "advisor",
        "code": codeCtrl.text.trim(),
        "stream": selectedStream,
        "college": "UKF College of Engineering, Paripally",
      });
      if (res.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) =>
                AdvisorHome(email: widget.email, name: widget.name)),
            (_) => false);
      }
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ?? "Invalid code";
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
            buildPageTitle("Advisor Code",
                "Enter your department code to verify."),
            const SizedBox(height: 28),
            buildCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildLabel("Department Code"),
              buildTextField(codeCtrl, "Enter your advisor code"),
              const SizedBox(height: 14),
              buildLabel("Your Stream / Department"),
              Container(
                decoration: BoxDecoration(
                  color: surfaceMid,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStream,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Select your stream",
                          style: TextStyle(color: Color(0xFF3A3A3A), fontSize: 14)),
                    ),
                    dropdownColor: surfaceMid,
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          color: ash),
                    ),
                    items: streams.map((s) => DropdownMenuItem(
                      value: s,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(s,
                            style: const TextStyle(color: white, fontSize: 14)),
                      ),
                    )).toList(),
                    onChanged: (v) => setState(() => selectedStream = v),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              buildPrimaryButton("Verify & Continue", _submit, loading: loading),
            ])),
          ]),
        ),
      ),
    );
  }
}