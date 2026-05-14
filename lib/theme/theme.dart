import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// PALETTE
// ─────────────────────────────────────────────
const bg         = Color(0xFF0A0A0A);
const surface    = Color(0xFF141414);
const surfaceMid = Color(0xFF1C1C1C);
const border     = Color(0xFF2A2A2A);
const ash        = Color(0xFF8A8A8A);
const ashLight   = Color(0xFFB0B0B0);
const white      = Color(0xFFF2F2F2);
const accent     = Color(0xFFD4D4D4);
const errorColor = Color(0xFFFF5555);
const successColor = Color(0xFF55FF99);
const pendingColor = Color(0xFFFFAA33);

// ─────────────────────────────────────────────
// STREAM CODES
// ─────────────────────────────────────────────
const Map<String, String> streamCodes = {
  'CS': 'Computer Science Engineering',
  'CD': 'Data Science',
  'EC': 'Electronics & Communication',
  'EE': 'Electrical & Electronics',
  'CV': 'Civil Engineering',
  'ME': 'Mechanical Engineering',
};

// ─────────────────────────────────────────────
// ADMISSION ID PARSER
// ─────────────────────────────────────────────
Map<String, String>? parseAdmissionId(String id) {
  id = id.toUpperCase().trim();
  if (id.length < 9) return null;

  final collegeCode = id.substring(0, 3);
  final yearStr     = id.substring(3, 5);
  final streamCode  = id.substring(5, 7);
  final rollNo      = id.substring(7);

  if (collegeCode != 'UKF') return null;

  final stream = streamCodes[streamCode];
  if (stream == null) return null;

  final currentYear = DateTime.now().year % 100;
  final joinYear    = int.tryParse(yearStr);
  if (joinYear == null) return null;

  final yearDiff  = currentYear - joinYear;
  final semester  = (yearDiff * 2) + 1;
  final semStr    = semester.clamp(1, 8).toString();

  return {
    'college_code': collegeCode,
    'college': 'UKF College of Engineering, Paripally',
    'year': '20$yearStr',
    'stream_code': streamCode,
    'stream': stream,
    'roll_no': rollNo,
    'semester': 'S$semStr',
  };
}

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
Widget buildLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ash,
              letterSpacing: 0.6)),
    );

Widget buildTextField(
    TextEditingController controller, String hint,
    {bool obscure = false,
    Widget? suffix,
    Widget? prefix,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    textCapitalization: capitalization,
    style: const TextStyle(color: white, fontSize: 14.5),
    cursorColor: accent,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 14),
      filled: true,
      fillColor: surfaceMid,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accent, width: 1.2)),
      suffixIcon: suffix,
      prefixIcon: prefix,
    ),
  );
}

Widget buildPrimaryButton(String label, VoidCallback? onTap,
    {bool loading = false}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        disabledBackgroundColor: border,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Color(0xFF0A0A0A)))
          : Text(label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0A0A0A),
                  letterSpacing: 0.3)),
    ),
  );
}

Widget buildCard(Widget child) {
  return Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 40,
            offset: const Offset(0, 12))
      ],
    ),
    child: child,
  );
}

Widget buildPageTitle(String title, String sub) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title,
        style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: white,
            letterSpacing: -0.8,
            height: 1.1)),
    const SizedBox(height: 8),
    Text(sub, style: const TextStyle(color: ash, fontSize: 13.5)),
  ]);
}

void showSnack(BuildContext context, String msg, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg,
        style: TextStyle(
            color: error ? errorColor : successColor,
            fontWeight: FontWeight.w600)),
    backgroundColor: surface,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ));
}

AppBar buildAppBar(BuildContext context, String title,
    {List<Widget>? actions}) {
  return AppBar(
    backgroundColor: bg,
    elevation: 0,
    centerTitle: true,
    title: Text(title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: white)),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ash, size: 18),
      onPressed: () => Navigator.pop(context),
    ),
    actions: actions,
  );
}