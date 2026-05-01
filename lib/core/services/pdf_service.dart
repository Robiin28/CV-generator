import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume_model.dart';

class PdfService {
  static const primaryNavy = PdfColor.fromInt(0xFF0A2540);
  static const darkText = PdfColor.fromInt(0xFF1E293B);
  static const linkColor = PdfColor.fromInt(0xFF2563EB);

  static String _sanitize(String text) {
    return text
        .replaceAll('•', '-')
        .replaceAll('|', '-')
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('●', '-')
        .replaceAll('\r', '');
  }

  static Future<void> generateAndDownload(Resume resume) async {
    final pdf = pw.Document();
    
    // Load Unicode-friendly fonts
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontItalic = await PdfGoogleFonts.robotoItalic();
    final fontBoldItalic = await PdfGoogleFonts.robotoBoldItalic();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
          italic: fontItalic,
          boldItalic: fontBoldItalic,
        ),
        build: (context) {
          return [
            // Header
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  _sanitize(resume.personalInfo.fullName.toUpperCase()),
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryNavy,
                    letterSpacing: 1.5,
                  ),
                ),
                pw.SizedBox(height: 6),
                if (resume.personalInfo.jobTitle != null)
                  pw.Text(
                    _sanitize(resume.personalInfo.jobTitle!.toUpperCase()),
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: darkText,
                      letterSpacing: 1,
                    ),
                  ),
                pw.SizedBox(height: 12),
                pw.Wrap(
                  alignment: pw.WrapAlignment.center,
                  spacing: 12,
                  children: [
                    _contactItem('Phone:', resume.personalInfo.phone),
                    _sep(),
                    _contactItem('Email:', resume.personalInfo.email),
                    _sep(),
                    _contactItem('Location:', resume.personalInfo.location),
                    if (resume.personalInfo.linkedin != null && resume.personalInfo.linkedin!.isNotEmpty) ...[
                      _sep(),
                      _contactItem('LinkedIn:', resume.personalInfo.linkedin!, isLink: true, color: linkColor),
                    ],
                    if (resume.personalInfo.website != null && resume.personalInfo.website!.isNotEmpty) ...[
                      _sep(),
                      _contactItem('Portfolio:', resume.personalInfo.website!, isLink: true, color: linkColor),
                    ],
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 24),

            // Summary
            if (resume.summary.isNotEmpty) ...[
              _sectionHeader('SUMMARY', primaryNavy),
              pw.Text(
                _sanitize(resume.summary),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 2),
              ),
              pw.SizedBox(height: 12),
            ],

            // Experience
            if (resume.experience.isNotEmpty) ...[
              _sectionHeader('PROFESSIONAL EXPERIENCE', primaryNavy),
              ...resume.experience.map((exp) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          _sanitize(exp.jobTitle.toUpperCase()),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                        ),
                        pw.Text(
                          _sanitize('${exp.startDate} - ${exp.current ? "Present" : exp.endDate}'),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    pw.Text(
                      _sanitize('${exp.company} | ${exp.location}'),
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10.5),
                    ),
                    pw.SizedBox(height: 6),
                    ...exp.description.split('\n').map((bullet) {
                      final text = bullet.trim();
                      if (text.isEmpty) return pw.SizedBox.shrink();
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2, left: 4),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 4, right: 8),
                              child: pw.Container(width: 2.5, height: 2.5, color: primaryNavy),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                _sanitize(text.replaceFirst('•', '').trim()),
                                textAlign: pw.TextAlign.justify,
                                style: const pw.TextStyle(fontSize: 10.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              )),
            ],

            // Education
            if (resume.education.isNotEmpty) ...[
              _sectionHeader('EDUCATION', primaryNavy),
              ...resume.education.map((edu) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          _sanitize('${edu.degree} ${edu.fieldOfStudy}'),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                        ),
                        pw.Text(
                          _sanitize('${edu.startDate} - ${edu.endDate}'),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    pw.Text(_sanitize(edu.school), style: const pw.TextStyle(fontSize: 10.5)),
                  ],
                ),
              )),
            ],

            // Skills
            if (resume.skills.isNotEmpty) ...[
              _sectionHeader('SKILLS', primaryNavy),
              ...resume.skills.map((cat) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 10.5),
                    children: [
                      pw.TextSpan(text: _sanitize('${cat.category}: '), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: _sanitize(cat.skills.join(', '))),
                    ],
                  ),
                ),
              )),
              pw.SizedBox(height: 12),
            ],

            // Projects
            if (resume.projects != null && resume.projects!.isNotEmpty) ...[
              _sectionHeader('PROJECTS', primaryNavy),
              ...resume.projects!.map((proj) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      _sanitize(proj.name.toUpperCase()),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                    ),
                    pw.Row(
                      children: [
                        if (proj.technologies.isNotEmpty)
                          pw.Text(
                            _sanitize(proj.technologies),
                            style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic, 
                              fontSize: 10, 
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                            ),
                          ),
                        if (proj.link != null && proj.link!.trim().isNotEmpty) ...[
                          if (proj.technologies.isNotEmpty)
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                              child: pw.Text('-', style: const pw.TextStyle(fontSize: 10)),
                            ),
                          pw.UrlLink(
                            destination: proj.link!.trim().startsWith('http') ? proj.link!.trim() : 'https://${proj.link!.trim()}',
                            child: pw.Text(
                              'View profile',
                              style: pw.TextStyle(
                                color: linkColor,
                                decoration: pw.TextDecoration.underline,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    ...proj.description.split('\n').map((bullet) {
                      final text = bullet.trim();
                      if (text.isEmpty) return pw.SizedBox.shrink();
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2, left: 4),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 4, right: 8),
                              child: pw.Container(width: 2.5, height: 2.5, color: primaryNavy),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                _sanitize(text.replaceFirst('•', '').trim()),
                                textAlign: pw.TextAlign.justify,
                                style: const pw.TextStyle(fontSize: 10.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              )),
            ],

            // Volunteering
            if (resume.volunteering != null && resume.volunteering!.isNotEmpty) ...[
              _sectionHeader('VOLUNTEERING & ACTIVITIES', primaryNavy),
              pw.SizedBox(height: 8),
              ...resume.volunteering!.map((vol) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(_sanitize(vol.role.toUpperCase()), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10.5)),
                    pw.Text(_sanitize('${vol.organization} | ${vol.startDate} - ${vol.endDate}'), style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
                    if (vol.description.isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      ...vol.description.split('\n').map((line) => pw.Text(_sanitize(line), style: const pw.TextStyle(fontSize: 10))),
                    ],
                  ],
                ),
              )),
            ],

            // Languages
            if (resume.languages != null && resume.languages!.isNotEmpty) ...[
              _sectionHeader('LANGUAGES', primaryNavy),
              pw.SizedBox(height: 8),
              pw.Wrap(
                spacing: 12,
                children: resume.languages!.map((lang) => pw.RichText(
                  text: pw.TextSpan(
                    style: pw.TextStyle(fontSize: 10),
                    children: [
                      pw.TextSpan(text: _sanitize(lang.name), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: ' (${_sanitize(lang.level)})'),
                    ],
                  ),
                )).toList(),
              ),
            ],
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${resume.personalInfo.fullName.replaceAll(" ", "_")}_Resume.pdf',
    );
  }

  static pw.Widget _contactItem(String label, String value, {bool isLink = false, PdfColor? color}) {
    if (value.isEmpty) return pw.SizedBox.shrink();
    
    final cleanValue = value.trim();
    final destination = cleanValue.startsWith('http') ? cleanValue : 'https://$cleanValue';
    final displayText = cleanValue.replaceFirst('https://', '').replaceFirst('http://', '').replaceFirst('www.', '');

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text('$label ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        if (isLink)
          pw.UrlLink(
            destination: destination,
            child: pw.Text(
              displayText,
              style: pw.TextStyle(
                fontSize: 10,
                color: color,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          )
        else
          pw.Text(displayText, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _sep() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6),
      child: pw.Text('-', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
    );
  }

  static pw.Widget _sectionHeader(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12, bottom: 6),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Divider(thickness: 2, color: color)),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 16),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1,
                color: color,
              ),
            ),
          ),
          pw.Expanded(child: pw.Divider(thickness: 2, color: color)),
        ],
      ),
    );
  }
}
