import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class StudentHome extends StatelessWidget {
  final String email;
  final String name;
  final String stream;
  final String semester;
  final bool isApproved;

  const StudentHome({
    super.key,
    required this.email,
    required this.name,
    required this.stream,
    required this.semester,
    required this.isApproved,
  });

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
                  Text("Dark Mode", style: TextStyle(color: white, fontSize: 13)),
                ]),
              ),
              PopupMenuItem(
                child: Row(children: const [
                  Icon(Icons.light_mode_rounded, color: ash, size: 16),
                  SizedBox(width: 10),
                  Text("Light Mode", style: TextStyle(color: white, fontSize: 13)),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: !isApproved ? _buildPendingView() : _buildApprovedView(),
      ),
    );
  }

  Widget _buildPendingView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Pending banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pendingColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: pendingColor.withOpacity(0.3)),
          ),
          child: Row(children: [
            const Icon(Icons.hourglass_empty_rounded,
                color: pendingColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text("Approval Pending",
                    style: TextStyle(color: pendingColor,
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 4),
                const Text("Your class advisor will approve your request soon.",
                    style: TextStyle(color: ash, fontSize: 12, height: 1.4)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 24),
        // Stream info
        buildCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Your Details",
              style: TextStyle(color: white, fontWeight: FontWeight.w700,
                  fontSize: 15)),
          const SizedBox(height: 16),
          _DetailRow("Stream", stream.isEmpty ? "Not set" : stream),
          const SizedBox(height: 8),
          _DetailRow("Semester", semester.isEmpty ? "Not set" : semester),
          const SizedBox(height: 8),
          _DetailRow("College", "UKF College of Engineering, Paripally"),
          const SizedBox(height: 8),
          _DetailRow("Status", "Pending Approval"),
        ])),
        const SizedBox(height: 24),
        // Locked folder preview
        const Text("Your Folders",
            style: TextStyle(color: ash, fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        _LockedFolder(stream.isEmpty ? "Your Stream" : stream),
      ]),
    );
  }

  Widget _buildApprovedView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Welcome, ${name.isEmpty ? 'Student' : name}! 👋",
            style: const TextStyle(color: white, fontSize: 20,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text("$stream · $semester",
            style: const TextStyle(color: ash, fontSize: 13)),
        const SizedBox(height: 24),
        // Folders
        _FolderCard(stream),
      ]),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("$label: ",
          style: const TextStyle(color: ash, fontSize: 13,
              fontWeight: FontWeight.w600)),
      Expanded(child: Text(value,
          style: const TextStyle(color: white, fontSize: 13))),
    ]);
  }
}

class _LockedFolder extends StatelessWidget {
  final String name;
  const _LockedFolder(this.name);

  @override
  Widget build(BuildContext context) {
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
          child: const Icon(Icons.folder_rounded, color: ash, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: const TextStyle(color: ashLight, fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text("Waiting for advisor approval",
                style: TextStyle(color: ash, fontSize: 11)),
          ]),
        ),
        const Icon(Icons.lock_rounded, color: ash, size: 16),
      ]),
    );
  }
}

class _FolderCard extends StatelessWidget {
  final String name;
  const _FolderCard(this.name);

  @override
  Widget build(BuildContext context) {
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
          child: const Icon(Icons.folder_rounded, color: ashLight, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: const TextStyle(color: white, fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text("Tap to open",
                style: TextStyle(color: ash, fontSize: 11)),
          ]),
        ),
        const Icon(Icons.arrow_forward_ios_rounded, color: ash, size: 14),
      ]),
    );
  }
}