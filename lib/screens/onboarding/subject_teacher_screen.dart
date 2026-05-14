import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../config/api.dart';
import '../../theme/theme.dart';
import '../home/subject_teacher_home.dart';

class SubjectTeacherScreen extends StatefulWidget {
  final String email;
  final String name;
  const SubjectTeacherScreen({super.key, required this.email, required this.name});
  @override
  State<SubjectTeacherScreen> createState() => _SubjectTeacherScreenState();
}

class _SubjectTeacherScreenState extends State<SubjectTeacherScreen> {
  final codeCtrl = TextEditingController();
  List<String> selectedSubjects = [];
  bool loading = false;

  final List<String> allSubjects = [
    'Mathematics', 'Physics', 'Chemistry',
    'Data Structures', 'Algorithms', 'Database Systems',
    'Operating Systems', 'Computer Networks', 'Machine Learning',
    'Artificial Intelligence', 'Web Development', 'Mobile Development',
    'Software Engineering', 'Computer Architecture', 'Digital Electronics',
    'Circuit Theory', 'Signals & Systems', 'Control Systems',
    'Thermodynamics', 'Fluid Mechanics', 'Structural Analysis',
  ];

  Future<void> _submit() async {
    if (codeCtrl.text.isEmpty || selectedSubjects.isEmpty) {
      showSnack(context, "Please enter code and select subjects", error: true);
      return;
    }
    setState(() => loading = true);
    try {
      final res = await dio.post("/auth/teacher-onboard", data: {
        "email": widget.email,
        "teacher_type": "subject",
        "code": codeCtrl.text.trim(),
        "subjects": selectedSubjects,
        "college": "UKF College of Engineering, Paripally",
      });
      if (res.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) =>
                SubjectTeacherHome(email: widget.email, name: widget.name)),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildPageTitle("Subject Teacher",
                "Enter your code and select your subjects."),
            const SizedBox(height: 24),
            buildCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildLabel("Subject Teacher Code"),
              buildTextField(codeCtrl, "Enter your subject teacher code"),
              const SizedBox(height: 16),
              buildLabel("Select Your Subjects"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allSubjects.map((subject) {
                  final isSelected = selectedSubjects.contains(subject);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedSubjects.remove(subject);
                        } else {
                          selectedSubjects.add(subject);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? accent.withOpacity(0.15) : surfaceMid,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isSelected ? accent : border),
                      ),
                      child: Text(subject,
                          style: TextStyle(
                              color: isSelected ? accent : ash,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600 : FontWeight.w400)),
                    ),
                  );
                }).toList(),
              ),
            ])),
            const SizedBox(height: 16),
            buildPrimaryButton("Verify & Continue", _submit, loading: loading),
          ]),
        ),
      ),
    );
  }
}