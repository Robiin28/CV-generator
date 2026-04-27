import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/resume_service.dart';

class CvPreviewDocument extends StatelessWidget {
  const CvPreviewDocument({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeService = context.watch<ResumeService>();
    final resume = resumeService.currentResume;

    if (resume == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: 210 * 3.7795275591, // A4 width in pixels (~793)
      constraints: const BoxConstraints(
        minHeight: 297 * 3.7795275591, // A4 height (~1122)
      ),
      margin: const EdgeInsets.symmetric(vertical: 40),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        // Premium shadow matching your CSS --shadow-premium
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25), // Fixes opacity warning
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(12), // Fixes opacity warning
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Center(
            child: Column(
              children: [
                Text(
                  resume.personalInfo.fullName.toUpperCase(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF0A2540)),
                ),
                const SizedBox(height: 8),
                Text(
                  resume.personalInfo.jobTitle?.toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF334155), letterSpacing: 1.2),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  children: [
                    if (resume.personalInfo.email.isNotEmpty)
                      _IconText(Icons.email, resume.personalInfo.email),
                    if (resume.personalInfo.phone.isNotEmpty)
                      _IconText(Icons.phone, resume.personalInfo.phone),
                    if (resume.personalInfo.location.isNotEmpty)
                      _IconText(Icons.location_on, resume.personalInfo.location),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 32, thickness: 1, color: Color(0xFFE2E8F0)),

          // Summary Section
          if (resume.summary.isNotEmpty) ...[
            const Text('PROFESSIONAL SUMMARY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0A2540))),
            const SizedBox(height: 8),
            Text(resume.summary, style: const TextStyle(height: 1.5, color: Color(0xFF475569))),
            const SizedBox(height: 24),
          ],

          // Experience Section
          if (resume.experience.isNotEmpty) ...[
            const Text('EXPERIENCE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0A2540))),
            const SizedBox(height: 12),
            // Fix: removed unnecessary toList() in spread
            ...resume.experience.map((exp) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(exp.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ),
                      const SizedBox(width: 16),
                      Text('${exp.startDate} - ${exp.endDate}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    ],
                  ),
                  Text('${exp.company} | ${exp.location}', style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF334155))),
                  const SizedBox(height: 8),
                  Text(exp.description, style: const TextStyle(height: 1.4, color: Color(0xFF475569))),
                ],
              ),
            )),
            const SizedBox(height: 8),
          ],

          // Education Section
          if (resume.education.isNotEmpty) ...[
            const Text('EDUCATION', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0A2540))),
            const SizedBox(height: 12),
            // Fix: removed unnecessary toList() in spread
            ...resume.education.map((edu) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(edu.degree, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ),
                      const SizedBox(width: 16),
                      Text('${edu.startDate} - ${edu.endDate}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    ],
                  ),
                  Text(edu.school, style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF334155))),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconText(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
      ],
    );
  }
}
