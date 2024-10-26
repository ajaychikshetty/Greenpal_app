import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;  // Import HTTP package for making API requests
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for database interaction
import '../core/models/report.dart';
import '../core/providers/report_provider.dart';
import '../core/utils/app_colors.dart';
import '../ui/widgets/bottom_navbar.dart';
import '../ui/widgets/image_input.dart';
import '../ui/widgets/loaction.dart'; // Fixed spelling from 'loaction' to 'location'
import 'reports.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  Location? location;

  String? _id;
  String? _name;
  String? _email;
  String? userImage_;
  bool isLoading = false;
  List<Map<String, dynamic>> _reports = []; // List to hold fetched reports

  Future<void> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
      _name = prefs.getString("name");
      _email = prefs.getString("email");
      userImage_ = prefs.getString("image");
    });
  }

  @override
  void initState() {
    super.initState();
    _id = "";
    _name = "";
    _email = "";
    userImage_ = "";
    getSession();
    _fetchReports(); // Fetch reports when the page is initialized
  }

  void _showReportForm() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Create New Report",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TColors.black,
                        ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Please provide description";
                      }
                      return null;
                    },
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.all(16),
                      hintText: "Describe the issue...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      color: TColors.black,
                      fontSize: 16,
                    ),
                    maxLength: 50,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle("📷 Add Photo"),
                  const SizedBox(height: 10),
                  ImageInput(
                    image: (image) {
                      _selectedImage = image;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle("📍 Location"),
                  const SizedBox(height: 10),
                  LocationInput(
                    onSelectLocation: (pickedLocation) {
                      location = pickedLocation;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Submit Report",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: TColors.black,
          ),
    );
  }

  Future<void> _fetchReports() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('reports').get();
      final List<Map<String, dynamic>> loadedReports = [];

      for (var doc in querySnapshot.docs) {
        loadedReports.add({
          'id': doc.id,
          ...doc.data(),
        });
      }

      setState(() {
        _reports = loadedReports;
      });
    } catch (error) {
      print('Error fetching reports: $error');
    }
  }

  Future<void> _addReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      if (_selectedImage == null || location == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      try {
        final enteredDescription = _descriptionController.text;
        final newReport = {
          'uploaderId': _id,
          'uploaderEmail': _email,
          'uploaderName': _name,
          'description': enteredDescription,
          'location': {
            'lat': location?.lat,
            'lon': location?.lon,
            'formattedAddress': location?.formattedAddress,
          },
          'reportAttachment': _selectedImage!.path,
          'status': 'pending', // Set initial status to pending
        };

        // Send data to Firebase
        final res = await FirebaseFirestore.instance.collection('reports').add(newReport);

        if (res.id.isNotEmpty) {
          print('Report added with ID: ${res.id}');

          // Clear the form fields
          _descriptionController.clear();
          setState(() {
            _selectedImage = null;
            location = null;
          });

          // Optionally, refresh the UI to show the new report
          _showSuccessDialog();
          _fetchReports(); // Fetch updated reports after adding a new one
        }
      } catch (error) {
        print('Error in _addReport: $error');
        _showErrorDialog('Error', 'Failed to submit report. Please try again.');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Report Submitted"),
        content: const Text("Your report has been submitted and is pending review."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(29, 29, 29, 1),
                    Color.fromRGBO(0, 0, 0, 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
               Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Waste Management",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _showReportForm,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _reports.length,
                    itemBuilder: (context, index) {
                      final report = _reports[index];
                      return Card(
                        color: Colors.grey[800],
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(
                            report['description'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            report['status'] ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
