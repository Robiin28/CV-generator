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
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      if (resume.personalInfo.phone.isNotEmpty) ...[
                        pw.Text('Phone: ${resume.personalInfo.phone}', style: const pw.TextStyle(fontSize: 10)),
                        _separator(),
                      ],
                      if (resume.personalInfo.email.isNotEmpty) ...[
                        pw.Text('Email: ${resume.personalInfo.email}', style: const pw.TextStyle(fontSize: 10)),
                        _separator(),
                      ],
                      if (resume.personalInfo.location.isNotEmpty)
                        pw.Text('Location: ${resume.personalInfo.location}', style: const pw.TextStyle(fontSize: 10)),
                    ],
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
                      '${exp.company} | ${exp.startDate} – ${exp.endDate}',
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      exp.description,
                      textAlign: pw.TextAlign.justify,
                      style: const pw.TextStyle(fontSize: 11),
                    ),
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
                      '${edu.degree} ${edu.fieldOfStudy ?? ""}'.toUpperCase(),
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
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${resume.personalInfo.fullName}_Resume.pdf',
    );
  }

  static pw.Widget _separator() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8),
      child: pw.Text('|', style: const pw.TextStyle(fontSize: 10)),
    );
  }

  static pw.Widget _sectionHeader(String title) {
    return pw.Row(
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
    );
  }
}
