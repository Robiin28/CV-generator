import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume_model.dart';

class PdfService {
  static String _sanitize(String text) {
    if (text.isEmpty) return text;
    // Replace problematic unicode characters with standard ASCII
    return text
      .replaceAll(RegExp(r'[\u2018\u2019]'), "'") // Smart single quotes
      .replaceAll(RegExp(r'[\u201C\u201D]'), '"') // Smart double quotes
      .replaceAll(RegExp(r'[\u2013\u2014]'), '-') // En and Em dashes
      .replaceAll('\u2022', '-') // Bullet
      .replaceAll('•', '-')
      .replaceAll('–', '-')
      .replaceAll('—', '-')
      .replaceAll('‘', "'")
      .replaceAll('’', "'")
      .replaceAll('“', '"')
      .replaceAll('”', '"');
  }

  static Future<void> generateAndDownload(Resume resume) async {
    final pdf = pw.Document();
    final linkColor = PdfColor.fromHex('#2563EB');
    final primaryNavy = PdfColor.fromHex('#0A2540');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    _sanitize(resume.personalInfo.fullName.toUpperCase()),
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  if (resume.personalInfo.jobTitle != null)
                    pw.Text(
                      _sanitize(resume.personalInfo.jobTitle!.toUpperCase()),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryNavy,
                      ),
                    ),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      _contactItem('Phone:', _sanitize(resume.personalInfo.phone)),
                      _sep(),
                      _contactItem('Email:', _sanitize(resume.personalInfo.email)),
                      _sep(),
                      _contactItem('Location:', _sanitize(resume.personalInfo.location)),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      if (resume.personalInfo.linkedin != null && resume.personalInfo.linkedin!.isNotEmpty) ...[
                        _contactItem('LinkedIn:', _sanitize(resume.personalInfo.linkedin!), isLink: true, color: linkColor),
                        if (resume.personalInfo.website != null && resume.personalInfo.website!.isNotEmpty) _sep(),
                      ],
                      if (resume.personalInfo.website != null && resume.personalInfo.website!.isNotEmpty)
                        _contactItem('Portfolio:', _sanitize(resume.personalInfo.website!), isLink: true, color: linkColor),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Divider(thickness: 2, color: primaryNavy),
            pw.SizedBox(height: 12),

            // Summary
            if (resume.summary.isNotEmpty) ...[
              pw.Text(
                _sanitize(resume.summary),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 2),
              ),
              pw.SizedBox(height: 20),
            ],

            // Experience
            if (resume.experience.isNotEmpty) ...[
              _sectionHeader('PROFESSIONAL EXPERIENCE', primaryNavy),
              pw.SizedBox(height: 10),
              ...resume.experience.map((exp) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      _sanitize(exp.jobTitle.toUpperCase()),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                    ),
                    pw.Text(
                      _sanitize('${exp.company} | ${exp.startDate} - ${exp.current ? "Present" : exp.endDate}'),
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10.5, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
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
              pw.SizedBox(height: 10),
              ...resume.education.map((edu) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      _sanitize('${edu.degree} ${edu.fieldOfStudy}'.toUpperCase()),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                    ),
                    pw.Text(
                      _sanitize('${edu.school} | ${edu.startDate} - ${edu.endDate}'),
                      style: const pw.TextStyle(fontSize: 10.5),
                    ),
                  ],
                ),
              )),
            ],

            // Skills
            if (resume.skills.isNotEmpty) ...[
              _sectionHeader('SKILLS AND LANGUAGES', primaryNavy),
              pw.SizedBox(height: 10),
              ...resume.skills.map((cat) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 10.5),
                    children: [
                      pw.TextSpan(text: '- ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: primaryNavy)),
                      pw.TextSpan(text: _sanitize('${cat.category.toUpperCase()}: '), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: _sanitize(cat.skills.join(', '))),
                    ],
                  ),
                ),
              )),
            ],

            // Projects
            if (resume.projects != null && resume.projects!.isNotEmpty) ...[
              _sectionHeader('PROJECTS & PUBLICATIONS', primaryNavy),
              pw.SizedBox(height: 10),
              ...resume.projects!.map((proj) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 10.5),
                    children: [
                      pw.TextSpan(text: _sanitize('${proj.name}: '), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: _sanitize(proj.description)),
                      pw.TextSpan(
                        text: ' View profile',
                        style: pw.TextStyle(color: linkColor, decoration: pw.TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              )),
            ],

            // Certifications
            if (resume.certifications != null && resume.certifications!.isNotEmpty) ...[
              _sectionHeader('CERTIFICATIONS', primaryNavy),
              pw.SizedBox(height: 8),
              ...resume.certifications!.map((cert) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(_sanitize(cert.name.toUpperCase()), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10.5)),
                    pw.Text(_sanitize('${cert.issuer} | ${cert.date}'), style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              )),
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
    return pw.RichText(
      text: pw.TextSpan(
        style: const pw.TextStyle(fontSize: 10),
        children: [
          pw.TextSpan(text: '$label ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.TextSpan(
            text: value.replaceFirst('https://', '').replaceFirst('www.', ''),
            style: pw.TextStyle(
              color: isLink ? color : PdfColors.black,
              decoration: isLink ? pw.TextDecoration.underline : pw.TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _sep() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6),
      child: pw.Text('|', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
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
