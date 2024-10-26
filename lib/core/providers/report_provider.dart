import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/report_services.dart';
import '../models/report.dart';

class ReportNotifier extends StateNotifier<List<Report>> {
  ReportNotifier() : super(const []);

  Future<bool> addReport(Report report) async {
    try {
      // Validate report data
      if (report.uploaderId == null || 
          report.uploaderEmail == null || 
          report.uploaderName == null) {
        print("Report validation failed: Missing user information");
        return false;
      }

      // Debug logging
      print("Report Notifier - Sending report with data:");
      print("UploaderId: ${report.uploaderId}");
      print("UploaderEmail: ${report.uploaderEmail}");
      print("UploaderName: ${report.uploaderName}");
      print("Description: ${report.description}");
      print("Location: ${report.location?.formattedAddress}");
      print("Attachment: ${report.reportAttachment}");

      // Send the report
      final response = await ReportService.addReport(report);
      
      print("Report Service Response: $response");

      if (response == "ok") {
        // Update local state
        state = [...state, report];
        return true;
      } else {
        print("Report submission failed: Response was not 'ok'");
        return false;
      }
    } catch (e, stackTrace) {
      print("Error in addReport: $e");
      print("Stack trace: $stackTrace");
      throw Exception("Failed to Add report: $e");
    }
  }

  Future<List<Report>> getAllUserReports(String userId, String filter) async {
    try {
      if (userId.isEmpty) {
        throw Exception("User ID cannot be empty");
      }

      final response = await ReportService.getAllUserReports(userId, filter);
      
      // Update state with fetched reports
      state = response;
      return response;
    } catch (e, stackTrace) {
      print("Error in getAllUserReports: $e");
      print("Stack trace: $stackTrace");
      throw Exception("Failed to fetch user reports: $e");
    }
  }

  Future<List<Report>> getSearchReport(String query) async {
    try {
      if (query.isEmpty) {
        return state;
      }

      final response = await ReportService.getSearchReport(query);
      
      // Update state with search results
      state = response;
      return response;
    } catch (e, stackTrace) {
      print("Error in getSearchReport: $e");
      print("Stack trace: $stackTrace");
      throw Exception("Failed to search reports: $e");
    }
  }

  Future<int> getCountOfAllUserReports(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception("User ID cannot be empty");
      }

      return await ReportService.getCountOfUserReports(userId);
    } catch (e, stackTrace) {
      print("Error in getCountOfAllUserReports: $e");
      print("Stack trace: $stackTrace");
      throw Exception("Failed to get report count: $e");
    }
  }
}

// Provider definition
final reportNotifier = StateNotifierProvider<ReportNotifier, List<Report>>(
  (ref) => ReportNotifier(),
);