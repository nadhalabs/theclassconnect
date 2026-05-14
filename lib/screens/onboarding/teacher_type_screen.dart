import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'advisor_code_screen.dart';
import 'subject_teacher_screen.dart';

class TeacherTypeScreen extends StatelessWidget {
  final String email;
  final String name;
  const TeacherTypeScreen({super.key, required this.email, required this.name});

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
            buildPageTitle("Teacher Type", "What is your role?"),
            const SizedBox(height: 40),
            _TypeCard(
              icon: Icons.admin_panel_settings_rounded,
              title: "Class Advisor",
              subtitle: "Manage your department, approve students and oversee all groups",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                      AdvisorCodeScreen(email: email, name: name))),
            ),
            const SizedBox(height: 16),
            _TypeCard(
              icon: Icons.menu_book_rounded,
              title: "Subject Teacher",
              subtitle: "Access subject folders and share resources with students",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                      SubjectTeacherScreen(email: email, name: name))),
            ),
          ]),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A3A3A)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ],
        ),
        child: Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: surfaceMid,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Icon(icon, color: ashLight, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w700, color: white)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12.5, color: ash)),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: ash, size: 14),
        ]),
      ),
    );
  }
}