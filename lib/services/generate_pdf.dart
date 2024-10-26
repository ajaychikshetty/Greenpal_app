import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class CertificatePdfGenerator {
  static Future generateCertificate(String participantName, String eventName, String date) async {
    final pdf = pw.Document();
    
    // Define colors
    final primaryBlue = PdfColor.fromHex('#1E88E5');
    final lightBlue = PdfColor.fromHex('#90CAF9');
    final darkGrey = PdfColor.fromHex('#333333');
    final green = PdfColor.fromHex('#4CAF50');

    // Create custom border decoration
    final borderDecoration = pw.BoxDecoration(
      border: pw.Border.all(color: primaryBlue, width: 3),
      color: PdfColors.white,
    );

    final innerBorderDecoration = pw.BoxDecoration(
      border: pw.Border.all(color: lightBlue, width: 1),
      color: PdfColors.white,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: borderDecoration,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: innerBorderDecoration,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // Decorative header line
                  pw.Container(
                    height: 5,
                    width: 400,
                    decoration: pw.BoxDecoration(
                      color: lightBlue,
                      borderRadius: pw.BorderRadius.circular(2.5),
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  
                  // Certificate title
                  pw.Text(
                    'Certificate of Achievement',
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  
                  // Decorative line
                  pw.Container(
                    margin: const pw.EdgeInsets.symmetric(vertical: 20),
                    height: 1,
                    width: 300,
                    color: lightBlue,
                  ),
                  
                  pw.Text(
                    'This is to certify that',
                    style: pw.TextStyle(fontSize: 18, color: darkGrey),
                  ),
                  pw.SizedBox(height: 20),
                  
                  // Participant name with decorative underline
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(color: lightBlue, width: 1),
                      ),
                    ),
                    child: pw.Text(
                      participantName,
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: darkGrey,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  
                  pw.Text(
                    'has successfully participated in',
                    style: pw.TextStyle(fontSize: 18, color: darkGrey),
                  ),
                  pw.SizedBox(height: 15),
                  
                  // Event name with background highlight
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: pw.BoxDecoration(
                      color: lightBlue,
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Text(
                      eventName,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  
                  pw.Text(
                    'on $date',
                    style: pw.TextStyle(fontSize: 18, color: darkGrey),
                  ),
                  pw.SizedBox(height: 40),
                  
                  // Environmental icon (simplified leaf shape)
                  pw.Container(
                    height: 60,
                    width: 60,
                    decoration: pw.BoxDecoration(
                      color: green,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  
                  // Signature section
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Column(
                        children: [
                          pw.Container(
                            width: 150,
                            height: 1,
                            color: darkGrey,
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Event Organizer',
                            style: pw.TextStyle(fontSize: 14, color: darkGrey),
                          ),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Container(
                            width: 150,
                            height: 1,
                            color: darkGrey,
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Organization Head',
                            style: pw.TextStyle(fontSize: 14, color: darkGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    // Save the PDF
    final outputDir = await getApplicationDocumentsDirectory();
    final outputFile = File('${outputDir.path}/certificate.pdf');
    await outputFile.writeAsBytes(await pdf.save());

    return outputFile;
  }
}