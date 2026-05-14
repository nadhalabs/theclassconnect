import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'student_college_screen.dart';
import 'teacher_type_screen.dart';

class RoleScreen extends StatelessWidget {
  final String email;
  final String name;
  const RoleScreen({super.key, required this.email, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildPageTitle("Who are you?", "Select your role to continue."),
            const SizedBox(height: 40),
            _RoleCard(
              icon: Icons.school_rounded,
              title: "Student",
              subtitle: "Join your college and access class resources",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                      StudentCollegeScreen(email: email, name: name))),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              icon: Icons.person_rounded,
              title: "Teacher",
              subtitle: "Manage your department and share resources",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                      TeacherTypeScreen(email: email, name: name))),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              icon: Icons.menu_book_rounded,
              title: "Private Tutor",
              subtitle: "Coming soon — stay tuned!",
              onTap: () => showSnack(context, "Private Tutor coming soon!"),
              disabled: true,
            ),
          ]),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool disabled;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFF111111) : surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: disabled ? border : const Color(0xFF3A3A3A)),
          boxShadow: disabled ? [] : [
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
              color: disabled ? const Color(0xFF1A1A1A) : surfaceMid,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Icon(icon,
                color: disabled ? ash : ashLight, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: disabled ? ash : white)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12.5,
                      color: disabled ? const Color(0xFF444444) : ash)),
            ]),
          ),
          if (!disabled)
            const Icon(Icons.arrow_forward_ios_rounded,
                color: ash, size: 14),
        ]),
      ),
    );
  }
}