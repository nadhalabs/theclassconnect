import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../config/api.dart';
import '../../theme/theme.dart';

class AdvisorHome extends StatefulWidget {
  final String email;
  final String name;
  const AdvisorHome({super.key, required this.email, required this.name});
  @override
  State<AdvisorHome> createState() => _AdvisorHomeState();
}

class _AdvisorHomeState extends State<AdvisorHome> {
  List<dynamic> pendingRequests = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadPending();
  }

  Future<void> _loadPending() async {
    setState(() => loading = true);
    try {
      final res = await dio.get("/advisor/pending",
          queryParameters: {"email": widget.email});
      if (res.statusCode == 200) {
        setState(() => pendingRequests = res.data["requests"] ?? []);
      }
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _approve(String studentEmail) async {
    try {
      await dio.post("/advisor/approve",
          data: {"advisor_email": widget.email, "student_email": studentEmail});
      showSnack(context, "Student approved!");
      _loadPending();
    } catch (_) {
      showSnack(context, "Failed to approve", error: true);
    }
  }

  Future<void> _reject(String studentEmail) async {
    try {
      await dio.post("/advisor/reject",
          data: {"advisor_email": widget.email, "student_email": studentEmail});
      showSnack(context, "Student rejected");
      _loadPending();
    } catch (_) {
      showSnack(context, "Failed to reject", error: true);
    }
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
              PopupMenuItem(
                onTap: _loadPending,
                child: Row(children: [
                  const Icon(Icons.pending_actions_rounded,
                      color: ash, size: 16),
                  const SizedBox(width: 10),
                  Text("Pending Requests (${pendingRequests.length})",
                      style: const TextStyle(color: white, fontSize: 13)),
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
            Text("Welcome, ${widget.name.isEmpty ? 'Advisor' : widget.name}! 👋",
                style: const TextStyle(color: white, fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text("Class Advisor",
                style: TextStyle(color: ash, fontSize: 13)),
            const SizedBox(height: 24),
            // Pending requests section
            Row(children: [
              const Text("Pending Requests",
                  style: TextStyle(color: white, fontSize: 15,
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              if (pendingRequests.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: pendingColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("${pendingRequests.length}",
                      style: const TextStyle(color: pendingColor,
                          fontSize: 12, fontWeight: FontWeight.w700)),
                ),
            ]),
            const SizedBox(height: 12),
            if (loading)
              const Center(child: CircularProgressIndicator(color: accent))
            else if (pendingRequests.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
                ),
                child: const Column(children: [
                  Icon(Icons.check_circle_outline_rounded,
                      color: ash, size: 32),
                  SizedBox(height: 12),
                  Text("No pending requests",
                      style: TextStyle(color: ash, fontSize: 14)),
                ]),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: pendingRequests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final req = pendingRequests[i];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(req["full_name"] ?? "Unknown",
                            style: const TextStyle(color: white,
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(req["email"] ?? "",
                            style: const TextStyle(color: ash, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text("${req["stream"]} · ${req["semester"]}",
                            style: const TextStyle(color: ashLight,
                                fontSize: 12)),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _approve(req["email"]),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: successColor.withOpacity(0.15),
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text("Approve",
                                  style: TextStyle(color: successColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _reject(req["email"]),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: errorColor.withOpacity(0.15),
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text("Reject",
                                  style: TextStyle(color: errorColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ]),
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