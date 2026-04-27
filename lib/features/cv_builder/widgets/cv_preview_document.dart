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
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section (EXECUTIVE STYLE)
          Center(
            child: Column(
              children: [
                Text(
                  resume.personalInfo.fullName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 36, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: -1.5, 
                    color: Colors.black,
                    fontFamily: 'Segoe UI',
                  ),
                ),
                const SizedBox(height: 4),
                if (resume.personalInfo.jobTitle != null)
                  Text(
                    resume.personalInfo.jobTitle!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w800, 
                      color: Colors.black,
                      fontFamily: 'Segoe UI',
                      letterSpacing: 0.2,
                    ),
                  ),
                const SizedBox(height: 12),
                // Centered contact line
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (resume.personalInfo.phone.isNotEmpty) ...[
                      RichText(text: TextSpan(
                        style: const TextStyle(fontSize: 11, color: Colors.black, fontFamily: 'Segoe UI'),
                        children: [
                          const TextSpan(text: 'Phone: ', style: TextStyle(fontWeight: FontWeight.w800)),
                          TextSpan(text: resume.personalInfo.phone),
                        ],
                      )),
                      const _Separator(),
                    ],
                    if (resume.personalInfo.email.isNotEmpty) ...[
                      RichText(text: TextSpan(
                        style: const TextStyle(fontSize: 11, color: Colors.black, fontFamily: 'Segoe UI'),
                        children: [
                          const TextSpan(text: 'Email: ', style: TextStyle(fontWeight: FontWeight.w800)),
                          TextSpan(text: resume.personalInfo.email),
                        ],
                      )),
                      const _Separator(),
                    ],
                    if (resume.personalInfo.location.isNotEmpty)
                      RichText(text: TextSpan(
                        style: const TextStyle(fontSize: 11, color: Colors.black, fontFamily: 'Segoe UI'),
                        children: [
                          const TextSpan(text: 'Location: ', style: TextStyle(fontWeight: FontWeight.w800)),
                          TextSpan(text: resume.personalInfo.location),
                        ],
                      )),
                  ],
                ),
                if (resume.personalInfo.linkedin != null || resume.personalInfo.website != null || resume.personalInfo.github != null) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (resume.personalInfo.linkedin != null) ...[
                        RichText(text: TextSpan(
                          style: const TextStyle(fontSize: 11, color: Colors.black, fontFamily: 'Segoe UI'),
                          children: [
                            const TextSpan(text: 'LinkedIn: ', style: TextStyle(fontWeight: FontWeight.w800)),
                            TextSpan(text: resume.personalInfo.linkedin!.replaceAll('https://', '').replaceAll('www.', ''), style: const TextStyle(color: Color(0xFF2563EB), decoration: TextDecoration.underline)),
                          ],
                        )),
                        const _Separator(),
                      ],
                      if (resume.personalInfo.website != null) ...[
                        RichText(text: TextSpan(
                          style: const TextStyle(fontSize: 11, color: Colors.black, fontFamily: 'Segoe UI'),
                          children: [
                            const TextSpan(text: 'Portfolio: ', style: TextStyle(fontWeight: FontWeight.w800)),
                            TextSpan(text: resume.personalInfo.website!.replaceAll('https://', '').replaceAll('www.', ''), style: const TextStyle(color: Color(0xFF2563EB), decoration: TextDecoration.underline)),
                          ],
                        )),
                        const _Separator(),
                      ],
                      if (resume.personalInfo.github != null)
                        RichText(text: TextSpan(
                          style: const TextStyle(fontSize: 11, color: Colors.black, fontFamily: 'Segoe UI'),
                          children: [
                            const TextSpan(text: 'GitHub: ', style: TextStyle(fontWeight: FontWeight.w800)),
                            TextSpan(text: resume.personalInfo.github!.replaceAll('https://', '').replaceAll('www.', ''), style: const TextStyle(color: Color(0xFF2563EB), decoration: TextDecoration.underline)),
                          ],
                        )),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(thickness: 2.5, color: Colors.black),
          const SizedBox(height: 16),

          // Summary Section
          if (resume.summary.isNotEmpty) ...[
            Text(
              resume.summary, 
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.4, color: Colors.black, fontSize: 13, fontFamily: 'Segoe UI'),
            ),
            const SizedBox(height: 24),
          ],

          // Education Section
          if (resume.education.isNotEmpty) ...[
            const _SectionHeader('EDUCATION'),
            const SizedBox(height: 12),
            ...resume.education.map((edu) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${edu.degree}${edu.fieldOfStudy != null ? " ${edu.fieldOfStudy}" : ""}'.toUpperCase(), 
                    style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 15, fontFamily: 'Segoe UI'),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${edu.school} | ${edu.startDate} – ${edu.endDate}', 
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14, fontFamily: 'Segoe UI'),
                  ),
                ],
              ),
            )),
          ],

          // Experience Section
          if (resume.experience.isNotEmpty) ...[
            const _SectionHeader('PROFESSIONAL EXPERIENCE'),
            const SizedBox(height: 12),
            ...resume.experience.map((exp) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exp.jobTitle.toUpperCase(), 
                    style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A), fontSize: 15, fontFamily: 'Segoe UI'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${exp.company} | ${exp.startDate} – ${exp.current ? "Present" : exp.endDate}', 
                    style: const TextStyle(fontWeight: FontWeight.w800, fontStyle: FontStyle.italic, color: Colors.black, fontSize: 14, fontFamily: 'Segoe UI'),
                  ),
                  if (exp.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...exp.description.split('\n').map((bullet) {
                      final text = bullet.trim();
                      if (text.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                text.replaceFirst('•', '').trim(), 
                                textAlign: TextAlign.justify,
                                style: const TextStyle(height: 1.4, color: Colors.black, fontSize: 13, fontFamily: 'Segoe UI'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            )),
          ],

          // Skills Section
          if (resume.skills.isNotEmpty) ...[
            const _SectionHeader('SKILLS AND LANGUAGES'),
            const SizedBox(height: 12),
            ...resume.skills.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(height: 1.5, color: Colors.black, fontSize: 14, fontFamily: 'Segoe UI'),
                  children: [
                    TextSpan(
                      text: '${category.category.toUpperCase()}: ',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(text: category.skills.join(', ')),
                  ],
                ),
              ),
            )),
          ],

          // Projects Section
          if (resume.projects != null && resume.projects!.isNotEmpty) ...[
            const _SectionHeader('PROJECTS & PUBLICATIONS'),
            const SizedBox(height: 12),
            ...resume.projects!.map((proj) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(height: 1.5, color: Colors.black, fontSize: 14, fontFamily: 'Segoe UI'),
                  children: [
                    TextSpan(
                      text: '${proj.name}: ',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(text: proj.description),
                  ],
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text('|', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: Divider(thickness: 2.5, color: Colors.black)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 2.0,
                fontFamily: 'Segoe UI',
              ),
            ),
          ),
          const Expanded(child: Divider(thickness: 2.5, color: Colors.black)),
        ],
      ),
    );
  }
}
