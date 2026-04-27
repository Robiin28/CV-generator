import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume_model.dart';

class PdfService {
  static Future<void> generateAndDownload(Resume resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    resume.personalInfo.fullName.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  if (resume.personalInfo.jobTitle != null)
                    pw.Text(
                      resume.personalInfo.jobTitle!.toUpperCase(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    '${resume.personalInfo.phone}  |  ${resume.personalInfo.email}  |  ${resume.personalInfo.location}  |  ${resume.personalInfo.linkedin ?? ""}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Divider(thickness: 2, color: PdfColors.black),
            pw.SizedBox(height: 12),

            // Summary
            if (resume.summary.isNotEmpty) ...[
              pw.Text(
                resume.summary,
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 2),
              ),
              pw.SizedBox(height: 24),
            ],

            // Experience
            if (resume.experience.isNotEmpty) ...[
              _sectionHeader('PROFESSIONAL EXPERIENCE'),
              pw.SizedBox(height: 10),
              ...resume.experience.map((exp) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      exp.jobTitle.toUpperCase(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
                    ),
                    pw.Text(
                      '${exp.company} | ${exp.location} | ${exp.startDate} – ${exp.endDate}',
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11),
                    ),
                    pw.SizedBox(height: 4),
                    ...exp.description.split('\n').map((bullet) {
                      final text = bullet.trim();
                      if (text.isEmpty) return pw.SizedBox.shrink();
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('• ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Expanded(
                              child: pw.Text(
                                text.replaceFirst('•', '').trim(),
                                textAlign: pw.TextAlign.justify,
                                style: const pw.TextStyle(fontSize: 11),
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
              _sectionHeader('EDUCATION'),
              pw.SizedBox(height: 10),
              ...resume.education.map((edu) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${edu.degree} ${edu.fieldOfStudy}'.toUpperCase(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
                    ),
                    pw.Text(
                      '${edu.school} | ${edu.startDate} – ${edu.endDate}',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              )),
            ],

            // Skills
            if (resume.skills.isNotEmpty) ...[
              _sectionHeader('SKILLS AND LANGUAGES'),
              pw.SizedBox(height: 10),
              ...resume.skills.map((cat) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 11),
                    children: [
                      pw.TextSpan(text: '${cat.category}: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: cat.skills.join(', ')),
                    ],
                  ),
                ),
              )),
            ],

            // Projects
            if (resume.projects != null && resume.projects!.isNotEmpty) ...[
              _sectionHeader('PROJECTS & PUBLICATIONS'),
              pw.SizedBox(height: 10),
              ...resume.projects!.map((proj) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.RichText(
                      text: pw.TextSpan(
                        style: const pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(text: '${proj.name.toUpperCase()}: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.TextSpan(text: proj.description),
                        ],
                      ),
                    ),
                    pw.Text(
                      '${proj.technologies} | View profile',
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                    ),
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
      name: '${resume.personalInfo.fullName}_Resume.pdf',
    );
  }

  static pw.Widget _sectionHeader(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16, bottom: 8),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Divider(thickness: 2, color: PdfColors.black)),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 16),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          pw.Expanded(child: pw.Divider(thickness: 2, color: PdfColors.black)),
        ],
      ),
    );
  }
}
