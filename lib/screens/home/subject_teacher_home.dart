import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class SubjectTeacherHome extends StatefulWidget {
  final String email;
  final String name;
  const SubjectTeacherHome(
      {super.key, required this.email, required this.name});
  @override
  State<SubjectTeacherHome> createState() => _SubjectTeacherHomeState();
}

class _SubjectTeacherHomeState extends State<SubjectTeacherHome> {
  String selectedSem = "All";
  final List<String> sems = ["All", "S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8"];

  final List<Map<String, String>> folders = [
    {"name": "Mathematics", "sem": "S1", "stream": "All"},
    {"name": "Physics", "sem": "S1", "stream": "All"},
    {"name": "Data Structures", "sem": "S3", "stream": "CSE"},
    {"name": "Machine Learning", "sem": "S5", "stream": "Data Science"},
    {"name": "Circuit Theory", "sem": "S3", "stream": "ECE"},
    {"name": "Thermodynamics", "sem": "S3", "stream": "Mechanical"},
  ];

  List<Map<String, String>> get filtered {
    if (selectedSem == "All") return folders;
    return folders.where((f) => f["sem"] == selectedSem).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceMid,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border),
              ),
              child: const Icon(Icons.person_rounded, color: ashLight, size: 18),
            ),
          ),
        ),
        title: const Text("Class Connect",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                color: white)),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_rounded, color: ash),
            color: surfaceMid,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(children: const [
                  Icon(Icons.dark_mode_rounded, color: ash, size: 16),
                  SizedBox(width: 10),
                  Text("Dark Mode",
                      style: TextStyle(color: white, fontSize: 13)),
                ]),
              ),
              PopupMenuItem(
                child: Row(children: const [
                  Icon(Icons.light_mode_rounded, color: ash, size: 16),
                  SizedBox(width: 10),
                  Text("Light Mode",
                      style: TextStyle(color: white, fontSize: 13)),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Welcome, ${widget.name.isEmpty ? 'Teacher' : widget.name}! 👋",
                style: const TextStyle(color: white, fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text("Subject Teacher",
                style: TextStyle(color: ash, fontSize: 13)),
            const SizedBox(height: 24),
            // Semester filter
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final sem = sems[i];
                  final isSelected = selectedSem == sem;
                  return GestureDetector(
                    onTap: () => setState(() => selectedSem = sem),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? accent : surfaceMid,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isSelected ? accent : border),
                      ),
                      child: Text(sem,
                          style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF0A0A0A) : ash,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Folders
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text("No folders for this semester",
                          style: TextStyle(color: ash, fontSize: 14)))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final folder = filtered[i];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: border),
                          ),
                          child: Row(children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: surfaceMid,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: border),
                              ),
                              child: const Icon(Icons.folder_rounded,
                                  color: ashLight, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(folder["name"]!,
                                    style: const TextStyle(color: white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(
                                    "${folder["sem"]} · ${folder["stream"]}",
                                    style: const TextStyle(color: ash,
                                        fontSize: 11)),
                              ]),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                color: ash, size: 14),
                          ]),
                        );
                      },
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}