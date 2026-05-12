import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/api.dart';
import '../theme/theme.dart';
import 'home_screen.dart';

const List<String> colleges = [
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
  final String email;
  const CollegeScreen({super.key, required this.email});
  @override
  State<CollegeScreen> createState() => _CollegeScreenState();
}

class _CollegeScreenState extends State<CollegeScreen> {
  final searchCtrl = TextEditingController();
  String? selected;
  List<String> filtered = colleges;
  bool loading = false;

  void _onSearch(String q) {
    setState(() {
      filtered = colleges
          .where((c) => c.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  Future<void> _saveCollege() async {
    if (selected == null) return;
    setState(() => loading = true);
    try {
      final res = await dio.post("/auth/college", data: {
        "email": widget.email,
        "college": selected,
      });
      if (res.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
      }
    } on DioException catch (e) {
      final msg = e.response?.data["detail"] ?? "Failed to save college";
      showSnack(context, msg.toString(), error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ash, size: 18),
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
            TextField(
              controller: searchCtrl,
              onChanged: _onSearch,
              style: const TextStyle(color: white, fontSize: 14),
              cursorColor: accent,
              decoration: InputDecoration(
                hintText: "Search college or school...",
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
                          color: accent, size: 18)
                          : null,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            buildPrimaryButton(
              selected == null
                  ? "Select a college to continue"
                  : "Join ${selected!.split('—').first.trim()}",
              selected == null ? null : _saveCollege,
              loading: loading,
            ),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }
}