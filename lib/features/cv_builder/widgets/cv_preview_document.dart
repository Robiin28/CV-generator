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

    // Website Brand Colors
    const Color primaryNavy = Color(0xFF0A2540);
    const Color linkColor = Color(0xFF2563EB);
    const Color darkText = Color(0xFF1A1A1A);

    return Container(
      width: 793.7, // A4 width
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Center(
            child: Column(
              children: [
                Text(
                  resume.personalInfo.fullName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.w800, 
                    letterSpacing: -0.5, 
                    color: Colors.black,
                    fontFamily: 'Segoe UI',
                    height: 1.0,
                  ),
                ),
                if (resume.personalInfo.jobTitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    resume.personalInfo.jobTitle!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w700, 
                      color: primaryNavy,
                      fontFamily: 'Segoe UI',
                      height: 1.1,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Contact Info
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _contactItem('Phone:', resume.personalInfo.phone),
                    _sep(),
                    _contactItem('Email:', resume.personalInfo.email),
                    _sep(),
                    _contactItem('Location:', resume.personalInfo.location),
                    if (resume.personalInfo.linkedin != null && resume.personalInfo.linkedin!.isNotEmpty) ...[
                      _sep(),
                      _contactItem('LinkedIn:', resume.personalInfo.linkedin!, isLink: true),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          const Divider(thickness: 2, color: primaryNavy),
          const SizedBox(height: 12),

          // SUMMARY
          if (resume.summary.isNotEmpty) ...[
            Text(
              resume.summary, 
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.4, color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
            ),
            const SizedBox(height: 24),
          ],

          // EXPERIENCE
          if (resume.experience.isNotEmpty) ...[
            _SectionHeader('PROFESSIONAL EXPERIENCE', color: primaryNavy),
            const SizedBox(height: 12),
            ...resume.experience.map((exp) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exp.jobTitle.toUpperCase(), 
                    style: const TextStyle(fontWeight: FontWeight.w800, color: darkText, fontSize: 15, fontFamily: 'Segoe UI'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${exp.company} | ${exp.startDate} – ${exp.current ? "Present" : exp.endDate}', 
                    style: const TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
                  ),
                  if (exp.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...exp.description.split('\n').map((bullet) {
                      final text = bullet.trim();
                      if (text.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8, right: 10),
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: primaryNavy,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                text.replaceFirst('•', '').trim(), 
                                textAlign: TextAlign.justify,
                                style: const TextStyle(height: 1.4, color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
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

          // EDUCATION
          if (resume.education.isNotEmpty) ...[
            _SectionHeader('EDUCATION', color: primaryNavy),
            const SizedBox(height: 12),
            ...resume.education.map((edu) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${edu.degree}${edu.fieldOfStudy.isNotEmpty ? " " + edu.fieldOfStudy : ""}'.toUpperCase(), 
                    style: const TextStyle(fontWeight: FontWeight.w800, color: darkText, fontSize: 15, fontFamily: 'Segoe UI'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${edu.school} | ${edu.startDate} – ${edu.endDate}', 
                    style: const TextStyle(fontWeight: FontWeight.w500, color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
                  ),
                ],
              ),
            )),
          ],

          // SKILLS & LANGUAGES
          if (resume.skills.isNotEmpty) ...[
            _SectionHeader('SKILLS AND LANGUAGES', color: primaryNavy),
            const SizedBox(height: 12),
            ...resume.skills.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(height: 1.5, color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
                  children: [
                    const TextSpan(
                      text: '• ',
                      style: TextStyle(fontWeight: FontWeight.w900, color: primaryNavy),
                    ),
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

          // PROJECTS
          if (resume.projects != null && resume.projects!.isNotEmpty) ...[
            _SectionHeader('PROJECTS & PUBLICATIONS', color: primaryNavy),
            const SizedBox(height: 12),
            ...resume.projects!.map((proj) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(height: 1.5, color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
                  children: [
                    TextSpan(
                      text: '${proj.name}: ',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(text: proj.description),
                    const TextSpan(
                      text: ' View profile',
                      style: TextStyle(color: linkColor, decoration: TextDecoration.underline, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )),
          ],

          // CERTIFICATIONS
          if (resume.certifications != null && resume.certifications!.isNotEmpty) ...[
            _SectionHeader('CERTIFICATIONS', color: primaryNavy),
            const SizedBox(height: 12),
            ...resume.certifications!.map((cert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cert.name.toUpperCase(), 
                    style: const TextStyle(fontWeight: FontWeight.w800, color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
                  ),
                  Text(
                    '${cert.issuer} | ${cert.date}', 
                    style: const TextStyle(color: darkText, fontSize: 13, fontFamily: 'Segoe UI'),
                  ),
                ],
              ),
            )),
          ],

          // VOLUNTEERING
          if (resume.volunteering != null && resume.volunteering!.isNotEmpty) ...[
            _SectionHeader('VOLUNTEERING & ACTIVITIES', color: primaryNavy),
            const SizedBox(height: 12),
            ...resume.volunteering!.map((vol) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vol.role.toUpperCase(), 
                    style: const TextStyle(fontWeight: FontWeight.w800, color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
                  ),
                  Text(
                    '${vol.organization} | ${vol.startDate} – ${vol.current ? "Present" : vol.endDate}', 
                    style: const TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: darkText, fontSize: 13, fontFamily: 'Segoe UI'),
                  ),
                  if (vol.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      vol.description,
                      style: const TextStyle(fontSize: 13, color: darkText, fontFamily: 'Segoe UI'),
                    ),
                  ],
                ],
              ),
            )),
          ],

          // LANGUAGES
          if (resume.languages != null && resume.languages!.isNotEmpty) ...[
            _SectionHeader('LANGUAGES', color: primaryNavy),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: resume.languages!.map((lang) => RichText(
                text: TextSpan(
                  style: const TextStyle(color: darkText, fontSize: 14, fontFamily: 'Segoe UI'),
                  children: [
                    TextSpan(text: lang.name, style: const TextStyle(fontWeight: FontWeight.w800)),
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

  Widget _contactItem(String label, String value, {bool isLink = false}) {
    if (value.isEmpty) return const SizedBox.shrink();
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Colors.black, fontFamily: 'Segoe UI'),
        children: [
          TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(
            text: value.replaceFirst('https://', '').replaceFirst('www.', ''),
            style: TextStyle(
              color: isLink ? const Color(0xFF2563EB) : Colors.black,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
              fontWeight: isLink ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sep() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text('|', style: TextStyle(fontSize: 13, color: Colors.grey)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader(this.title, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Divider(thickness: 2, color: color.withOpacity(0.8))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: 1.2,
                fontFamily: 'Segoe UI',
              ),
            ),
          ),
          Expanded(child: Divider(thickness: 2, color: color.withOpacity(0.8))),
        ],
      ),
    );
  }
}
