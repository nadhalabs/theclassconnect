import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../config/api.dart';
import '../../theme/theme.dart';
import 'student_admission_screen.dart';

const List<String> _colleges = [
  "UKF College of Engineering, Paripally",
  "MIT — Massachusetts Institute of Technology",
  "Stanford University",
  "Harvard University",
  "IIT Bombay",
  "IIT Delhi",
  "IIT Madras",
  "BITS Pilani",
  "VIT University",
  "Anna University",
];

class StudentCollegeScreen extends StatefulWidget {
  final String email;
  final String name;
  const StudentCollegeScreen({super.key, required this.email, required this.name});
  @override
  State<StudentCollegeScreen> createState() => _StudentCollegeScreenState();
}

class _StudentCollegeScreenState extends State<StudentCollegeScreen> {
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
            buildPageTitle("Select your college",
                "Search and select your institution."),
            const SizedBox(height: 24),
            TextField(
              controller: searchCtrl,
              onChanged: _onSearch,
              style: const TextStyle(color: white, fontSize: 14),
              cursorColor: accent,
              decoration: InputDecoration(
                hintText: "Search college...",
                hintStyle: const TextStyle(color: Color(0xFF3A3A3A)),
                filled: true,
                fillColor: surfaceMid,
                prefixIcon: const Icon(Icons.search_rounded, color: ash, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: accent, width: 1.2)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
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
                        child: Center(child: Text("No results found",
                            style: TextStyle(color: ash, fontSize: 13))),
                      );
                    }
                    final college = filtered[i];
                    final isSelected = selected == college;
                    return ListTile(
                      onTap: () => setState(() => selected = college),
                      title: Text(college,
                          style: TextStyle(
                              color: isSelected ? accent : ashLight,
                              fontSize: 13.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700 : FontWeight.w400)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                          color: accent, size: 18) : null,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            buildPrimaryButton(
              selected == null ? "Select a college to continue" : "Continue",
              selected == null ? null : () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>
                        StudentAdmissionScreen(
                            email: widget.email,
                            name: widget.name,
                            college: selected!)));
              },
            ),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }
}