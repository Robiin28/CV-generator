import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/resume_service.dart';
import '../../../core/models/resume_model.dart';

class CvPreviewDocument extends StatelessWidget {
  const CvPreviewDocument({super.key});

  @override
  Widget build(BuildContext context) {
    final resume = context.watch<ResumeService>().currentResume;
    if (resume == null) return const Center(child: Text('No Resume Found'));

    return Container(
      width: 793.7, // A4 width at 96 DPI
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                if (resume.personalInfo.jobTitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    resume.personalInfo.jobTitle!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w800, 
                      color: Colors.black,
                      fontFamily: 'Segoe UI',
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '${resume.personalInfo.phone}  |  ${resume.personalInfo.email}  |  ${resume.personalInfo.location}  |  ${resume.personalInfo.linkedin ?? ""}',
                  style: const TextStyle(fontSize: 13, color: Colors.black, fontFamily: 'Segoe UI'),
                ),
                if (resume.personalInfo.website != null && resume.personalInfo.website!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    resume.personalInfo.website!,
                    style: const TextStyle(fontSize: 13, color: Colors.black, fontStyle: FontStyle.italic, fontFamily: 'Segoe UI'),
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
                    '${exp.company} | ${exp.location} | ${exp.startDate} – ${exp.current ? "Present" : exp.endDate}', 
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
                    '${edu.degree} ${edu.fieldOfStudy}'.toUpperCase(), 
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

          // Skills Section
          if (resume.skills.isNotEmpty) ...[
            const _SectionHeader('SKILLS AND LANGUAGES'),
            const SizedBox(height: 12),
            ...resume.skills.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(height: 1.5, color: Colors.black, fontSize: 13, fontFamily: 'Segoe UI'),
                  children: [
                    TextSpan(
                      text: '${category.category.toUpperCase()}: ',
                      style: const TextStyle(fontWeight: FontWeight.w900),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(height: 1.5, color: Colors.black, fontSize: 13, fontFamily: 'Segoe UI'),
                      children: [
                        TextSpan(
                          text: '${proj.name.toUpperCase()}: ',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        TextSpan(text: proj.description),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${proj.technologies} | View profile',
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black54, fontFamily: 'Segoe UI'),
                  ),
                ],
              ),
            )),
          ],

          // Languages Section
          if (resume.languages != null && resume.languages!.isNotEmpty) ...[
            const _SectionHeader('LANGUAGES'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: resume.languages!.map((lang) => RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'Segoe UI'),
                  children: [
                    TextSpan(text: lang.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                    TextSpan(text: ' (${lang.level})'),
                  ],
                ),
              )).toList(),
            ),
          ],
        ],
      ),
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
