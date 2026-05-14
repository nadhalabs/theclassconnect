import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../config/api.dart';
import '../../theme/theme.dart';
import '../home/student_home.dart';

class StudentAdmissionScreen extends StatefulWidget {
  final String email;
  final String name;
  final String college;
  const StudentAdmissionScreen(
      {super.key, required this.email, required this.name, required this.college});
  @override
  State<StudentAdmissionScreen> createState() => _StudentAdmissionScreenState();
}

class _StudentAdmissionScreenState extends State<StudentAdmissionScreen> {
  final admissionCtrl = TextEditingController();
  bool loading = false;
  Map<String, String>? parsed;

  void _onChanged(String val) {
    setState(() {
      parsed = parseAdmissionId(val);
    });
  }

  Future<void> _submit() async {
    if (parsed == null) {
      showSnack(context, "Invalid admission ID", error: true);
      return;
    }
    setState(() => loading = true);
    try {
      final res = await dio.post("/auth/student-onboard", data: {
        "email": widget.email,
        "college": widget.college,
        "admission_id": admissionCtrl.text.trim().toUpperCase(),
        "stream": parsed!['stream'],
        "semester": parsed!['semester'],
        "roll_no": parsed!['roll_no'],
        "year_joined": parsed!['year'],
      });
      if (!mounted) return; // ← ADDED mounted check after await
      if (res.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => StudentHome(
                    email: widget.email,
                    name: widget.name,
                    stream: parsed!['stream']!,
                    semester: parsed!['semester']!,
                    isApproved: false)),
            (_) => false);
      }
    } on DioException catch (e) {
      if (!mounted) return; // ← ADDED mounted check before showing snack
      final msg = e.response?.data["detail"] ?? "Failed to submit";
      showSnack(context, msg.toString(), error: true);
    } finally {
      if (mounted) setState(() => loading = false); // ← ADDED mounted check in finally
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ash, size: 18),
            onPressed: () => Navigator.pop(context),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildPageTitle("Admission ID",
                "Enter your college admission ID to auto-detect your stream."),
            const SizedBox(height: 28),
            buildCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildLabel("Admission ID"),
              buildTextField(
                admissionCtrl,
                "e.g. UKF25CD030",
                capitalization: TextCapitalization.characters,
                onChanged: _onChanged, // ← ADDED onChanged connected here
              ),
              const SizedBox(height: 8),
              // Auto detected info
              if (parsed != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: surfaceMid,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF55FF99).withOpacity(0.3)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _InfoRow("College", parsed!['college']!),
                    const SizedBox(height: 6),
                    _InfoRow("Stream", parsed!['stream']!),
                    const SizedBox(height: 6),
                    _InfoRow("Semester", parsed!['semester']!),
                    const SizedBox(height: 6),
                    _InfoRow("Roll No", parsed!['roll_no']!),
                    const SizedBox(height: 6),
                    _InfoRow("Year Joined", parsed!['year']!),
                  ]),
                ),
              ] else if (admissionCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text("Invalid admission ID format",
                    style: TextStyle(color: errorColor, fontSize: 12)),
              ],
              const SizedBox(height: 24),
              buildPrimaryButton(
                  "Submit & Join", parsed == null ? null : _submit,
                  loading: loading),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfaceMid,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: border),
                ),
                child: const Text(
                  "After submitting, your request will be sent to your class advisor for approval.",
                  style: TextStyle(color: ash, fontSize: 12, height: 1.5),
                ),
              ),
            ])),
          ]),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("$label: ",
          style: const TextStyle(
              color: ash, fontSize: 12, fontWeight: FontWeight.w600)),
      Expanded(
          child: Text(value,
              style: const TextStyle(color: white, fontSize: 12))),
    ]);
  }
}