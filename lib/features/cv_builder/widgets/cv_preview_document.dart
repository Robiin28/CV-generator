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
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                Text(
                  resume.personalInfo.jobTitle?.toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF475569), letterSpacing: 0.5, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                // Centered contact line like the website
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (resume.personalInfo.phone.isNotEmpty) ...[
                      Text('Phone: ${resume.personalInfo.phone}', style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('|', style: TextStyle(color: Color(0xFFCBD5E1))),
                      ),
                    ],
                    if (resume.personalInfo.email.isNotEmpty) ...[
                      Text('Email: ${resume.personalInfo.email}', style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('|', style: TextStyle(color: Color(0xFFCBD5E1))),
                      ),
                    ],
                    if (resume.personalInfo.location.isNotEmpty)
                      Text('Location: ${resume.personalInfo.location}', style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A))),
                  ],
                ),
                const SizedBox(height: 8),
                if (resume.personalInfo.linkedin != null || resume.personalInfo.website != null)
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (resume.personalInfo.linkedin != null) ...[
                        Text('LinkedIn: ${resume.personalInfo.linkedin}', style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), decoration: TextDecoration.underline)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('|', style: TextStyle(color: Color(0xFFCBD5E1))),
                        ),
                      ],
                      if (resume.personalInfo.website != null)
                        Text('Portfolio: ${resume.personalInfo.website}', style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), decoration: TextDecoration.underline)),
                    ],
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Divider(thickness: 2, color: Color(0xFF0F172A)),
          const SizedBox(height: 24),

          // Summary Section
          if (resume.summary.isNotEmpty) ...[
            const _SectionHeader('PROFESSIONAL SUMMARY'),
            const SizedBox(height: 12),
            Text(resume.summary, style: const TextStyle(height: 1.6, color: Color(0xFF334155), fontSize: 13)),
            const SizedBox(height: 32),
          ],

          // Experience Section
          if (resume.experience.isNotEmpty) ...[
            const _SectionHeader('EXPERIENCE'),
            const SizedBox(height: 12),
            ...resume.experience.map((exp) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exp.jobTitle.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${exp.company} | ${exp.startDate} – ${exp.endDate}', style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF475569), fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(exp.description, style: const TextStyle(height: 1.5, color: Color(0xFF334155), fontSize: 12)),
                ],
              ),
            )),
            const SizedBox(height: 8),
          ],

          // Education Section
          if (resume.education.isNotEmpty) ...[
            const _SectionHeader('EDUCATION'),
            const SizedBox(height: 12),
            ...resume.education.map((edu) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(edu.degree.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 14)),
                  Text('${edu.school} | ${edu.startDate} – ${edu.endDate}', style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF475569), fontSize: 12)),
                ],
              ),
            )),
          ],

          // Skills Section
          if (resume.skills.isNotEmpty) ...[
            const SizedBox(height: 12),
            const _SectionHeader('SKILLS'),
            const SizedBox(height: 12),
            ...resume.skills.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(height: 1.5, color: Color(0xFF334155), fontSize: 12),
                  children: [
                    TextSpan(
                      text: '${category.category}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    TextSpan(text: category.skills.join(', ')),
                  ],
                ),
              ),
            )),
          ],

          // Projects Section
          if (resume.projects != null && resume.projects!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const _SectionHeader('PROJECTS'),
            const SizedBox(height: 12),
            ...resume.projects!.map((proj) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(proj.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 13)),
                  if (proj.technologies.isNotEmpty)
                    Text('Technologies: ${proj.technologies}', style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF334155), fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(proj.description, style: const TextStyle(height: 1.4, color: Color(0xFF475569), fontSize: 12)),
                ],
              ),
            )),
          ],

          // Languages Section
          if (resume.languages != null && resume.languages!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const _SectionHeader('LANGUAGES'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: resume.languages!.map((lang) => RichText(
                text: TextSpan(
                  style: const TextStyle(color: Color(0xFF475569), fontSize: 12),
                  children: [
                    TextSpan(text: lang.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    TextSpan(text: ': ${lang.level}'),
                  ],
                ),
              )).toList(),
            ),
          ],

          // Certifications Section
          if (resume.certifications != null && resume.certifications!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const _SectionHeader('CERTIFICATIONS'),
            const SizedBox(height: 12),
            ...resume.certifications!.map((cert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cert.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 13)),
                        Text(cert.issuer, style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF334155), fontSize: 11)),
                      ],
                    ),
                  ),
                  Text(cert.date, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                ],
              ),
            )),
          ],

          // Volunteering Section
          if (resume.volunteering != null && resume.volunteering!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const _SectionHeader('VOLUNTEERING & ACTIVITIES'),
            const SizedBox(height: 12),
            ...resume.volunteering!.map((vol) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(vol.role.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 13)),
                      Text('${vol.startDate} - ${vol.endDate}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                    ],
                  ),
                  Text(vol.organization, style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF334155), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(vol.description, style: const TextStyle(height: 1.4, color: Color(0xFF475569), fontSize: 12)),
                ],
              ),
            )),
          ],

          // Custom Sections Section
          if (resume.customSections != null && resume.customSections!.isNotEmpty) ...[
            ...resume.customSections!.map((section) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _SectionHeader(section.title.toUpperCase()),
                const SizedBox(height: 12),
                ...section.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(height: 1.4, color: Color(0xFF475569), fontSize: 12),
                      children: [
                        TextSpan(
                          text: '${item.label}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        ),
                        TextSpan(text: item.value),
                      ],
                    ),
                  ),
                )),
              ],
            )),
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
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1.5, color: Color(0xFF0F172A))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              letterSpacing: 2.0,
            ),
          ),
        ),
        const Expanded(child: Divider(thickness: 1.5, color: Color(0xFF0F172A))),
      ],
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
