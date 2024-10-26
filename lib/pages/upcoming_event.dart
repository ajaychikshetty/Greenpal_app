// event_info_page.dart
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import 'event_participants.dart';

class UpcomingEvent extends StatefulWidget {
  // Constants for styling
  static const double _borderRadius = 28.0;
  static const double _padding = 24.0;
  static const double _iconSize = 24.0;
  static const double _spacing = 16.0;

  // Colors
  static const Color _primaryColor = Color(0xFF4CAF50); // Green
  static const Color _backgroundColor = Colors.black;
  static const Color _cardColor = Color(0xFFE8F5E9);
  static const Color _textColor = Color(0xFF212121);
  static const Color _secondaryTextColor = Color(0xFF757575);

  @override
  State<UpcomingEvent> createState() => _UpcomingEventState();
}

class _UpcomingEventState extends State<UpcomingEvent> {
  double _dragPosition = 0;

// Method to send RSVP data to Firestore
Future<void> _sendRSVPDataToFirestore(String qrCodeData) async {
  await FirebaseFirestore.instance.collection('rsvps').add({
    'event_id': 'Ft62u2d5NL0ZudarnCKM', // Replace with actual event ID
    'user_id': '1PLueGFYndaf4iXxTHa5eFL9fCD3', // Replace with actual user ID
    'timestamp': FieldValue.serverTimestamp(),
    'status': 'ongoing',
    'qr_code_data': qrCodeData, // Store QR code data for lookup
  });
}

// Method to generate a QR code and save it as an image in Firestore
Future<String?> _generateAndSaveQRCode(String data) async {
  try {
    // Create a QrPainter with the provided data
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
      color: Colors.black,
      gapless: false,
    );

    // Convert to image
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    qrPainter.paint(canvas, Size(200, 200)); // Adjust size as needed
    final img = await pictureRecorder.endRecording().toImage(200, 200);
    ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Upload the image to Firestore storage
    String filePath = 'qr_codes/${DateTime.now().millisecondsSinceEpoch}.png';
    final storageRef = FirebaseStorage.instance.ref().child(filePath);
    await storageRef.putData(pngBytes);

    // Get the download URL
    String downloadUrl = await storageRef.getDownloadURL();
    
    // Save the link to Firestore if needed
    await FirebaseFirestore.instance.collection('qr_codes').add({
      'url': downloadUrl,
      'data': data,
      'timestamp': FieldValue.serverTimestamp(),
    });
    return downloadUrl; // Return the QR code image URL
  } catch (e) {
    print('Error generating QR code: $e');
  }
  return null; // Return null if failed
}

// Method to update RSVP status when QR code is scanned
Future<void> updateRSVPStatus(String qrCodeData) async {
  try {
    // Query Firestore for the RSVP document with the matching QR code data
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rsvps')
        .where('qr_code_data', isEqualTo: qrCodeData) // Match with the data
        .get();

    // Check if a document exists
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming only one document is returned, update the first one
      DocumentSnapshot doc = querySnapshot.docs.first;
      await FirebaseFirestore.instance.collection('rsvps').doc(doc.id).update({
        'status': 'completed',
        'timestamp': FieldValue.serverTimestamp(), // Optional: update timestamp
      });
      print('RSVP status updated to completed.');
    } else {
      print('No RSVP found for this QR code.');
    }
  } catch (e) {
    print('Error updating RSVP status: $e');
  }
}

// Example method to handle the RSVP process
void _animateAndNavigate() async {
  // Add haptic feedback
  await HapticFeedback.heavyImpact();

  // Show dialog for confirmation
  bool isConfirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Join Event"),
        content: Text("Do you really want to join the event?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User cancelled
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User confirmed
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );

  if (isConfirmed) {
    // Generate QR code data (you can customize this data)
    String qrCodeData = 'unique_identifier_for_event'; // Replace with actual data

    // Send RSVP data to Firestore
    await _sendRSVPDataToFirestore(qrCodeData);

    // Generate QR code and save it
    String? qrImageUrl = await _generateAndSaveQRCode(qrCodeData);

    if (qrImageUrl != null) {
      // Show a toast notification that the event has been booked
      Fluttertoast.showToast(
        msg: "Event has been booked! QR Code generated.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );

      // Navigate to the home page
      Navigator.of(context).pushNamed('/home');

      // Reset position after navigation
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _dragPosition = 0;
        });
      });
    } else {
      Fluttertoast.showToast(
        msg: "Failed to generate QR code.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  } else {
    // Reset drag position if user cancels the dialog
    setState(() {
      _dragPosition = 0;
    });
  }
}

// Example QR code scanning method
void onQRCodeScanned(String scannedData) {
  // Call the method to update the RSVP status
  updateRSVPStatus(scannedData);
}

void _animateAndexplore() async {
  // Add haptic feedback
  await HapticFeedback.heavyImpact();
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventParticipantsPage(
      eventName: "Community Clean-up Day",
      participants: [
        {
          'name': 'Alice Johnson',
          'email': 'alice@example.com',
          'status': 'Confirmed',
          'image': 'https://example.com/image1.jpg',
        },
        {
          'name': 'Bob Smith',
          'email': 'bob@example.com',
          'status': 'Pending',
          'image': 'https://example.com/image2.jpg',
        },
        // Add more participants here
      ],
    ),
  ),
);

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UpcomingEvent._backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      title: Text(
        'Clean Marine Drive',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderImage(context),
          _buildEventDetailsCard(context),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://firebasestorage.googleapis.com/v0/b/safaisathi-febc9.appspot.com/o/banners%2F25d85e78-facd-4574-b40c-fa6fea89bda8-OIP.jpeg?alt=media&token=7ac88226-75de-4506-8703-357e558aa7ed',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEventDetailsCard(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -80),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: UpcomingEvent._padding),
        decoration: BoxDecoration(
          color: UpcomingEvent._cardColor,
          borderRadius: BorderRadius.circular(UpcomingEvent._borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(UpcomingEvent._padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventHeader(),
              SizedBox(height: UpcomingEvent._spacing * 1.5),
              _buildEventInfo(),
              SizedBox(height: UpcomingEvent._spacing * 1.5),
              _buildDescription(),
              SizedBox(height: UpcomingEvent._spacing * 1.5),
              _buildTicketButton(),
              SizedBox(height: UpcomingEvent._spacing * 1.5),
              _exploreButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Clean Marine Drive',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: UpcomingEvent._textColor,
            ),
          ),
        ),
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: UpcomingEvent._primaryColor,
            boxShadow: [
              BoxShadow(
                color: UpcomingEvent._primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'EVENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfo() {
    return Column(
      children: [
        _buildInfoRow(Icons.location_on, "Mumbai, Marine drive"),
        SizedBox(height: UpcomingEvent._spacing),
        _buildInfoRow(Icons.calendar_today, '1 April, 2024'),
        SizedBox(height: UpcomingEvent._spacing),
        _buildInfoRow(Icons.access_time, '09:16 AM'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon,
            size: UpcomingEvent._iconSize, color: UpcomingEvent._primaryColor),
        SizedBox(width: UpcomingEvent._spacing),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: UpcomingEvent._secondaryTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.all(UpcomingEvent._spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UpcomingEvent._borderRadius / 2),
      ),
      child: Text(
        "Recycles Plastic bottles and plastic waste, clean the environment",
        style: TextStyle(
          fontSize: 16,
          color: UpcomingEvent._secondaryTextColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTicketButton() {
    final double buttonWidth =
        MediaQuery.of(context).size.width - (UpcomingEvent._padding * 2);
    final double buttonHeight = 56.0;

    return StatefulBuilder(builder: (context, setState) {
      return Container(
        width: buttonWidth,
        height: buttonHeight,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              double newPosition = _dragPosition + details.delta.dx;
              _dragPosition = newPosition.clamp(0, buttonWidth - 48);

              // Add light haptic feedback during drag
              if (_dragPosition % 20 == 0) {
                HapticFeedback.lightImpact();
              }
            });
          },
          onHorizontalDragEnd: (details) {
            if (_dragPosition > buttonWidth * 0.6) {
              setState(() {
                _dragPosition = buttonWidth - 48;
                _animateAndNavigate();
              });
            } else {
              setState(() {
                _dragPosition = 0;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: UpcomingEvent._textColor,
              borderRadius: BorderRadius.circular(UpcomingEvent._borderRadius),
            ),
            child: Stack(
              children: [
                // Progress indicator
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: _dragPosition + 48,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(UpcomingEvent._borderRadius),
                  ),
                ),
                // Text
                Center(
                  child: Text(
                    'RSVP Event',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Draggable arrow
                AnimatedPositioned(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeOutCubic,
                  left: _dragPosition,
                  top: 4,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _exploreButton() {
    final double buttonWidth =
        MediaQuery.of(context).size.width - (UpcomingEvent._padding * 2);
    final double buttonHeight = 56.0;

    return StatefulBuilder(builder: (context, setState) {
      return Container(
        width: buttonWidth,
        height: buttonHeight,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              double newPosition = _dragPosition + details.delta.dx;
              _dragPosition = newPosition.clamp(0, buttonWidth - 48);

              // Add light haptic feedback during drag
              if (_dragPosition % 20 == 0) {
                HapticFeedback.lightImpact();
              }
            });
          },
          onHorizontalDragEnd: (details) {
            if (_dragPosition > buttonWidth * 0.6) {
              setState(() {
                _dragPosition = buttonWidth - 48;
                _animateAndexplore();
              });
            } else {
              setState(() {
                _dragPosition = 0;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: UpcomingEvent._textColor,
              borderRadius: BorderRadius.circular(UpcomingEvent._borderRadius),
            ),
            child: Stack(
              children: [
                // Progress indicator
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: _dragPosition + 48,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(UpcomingEvent._borderRadius),
                  ),
                ),
                // Text
                Center(
                  child: Text(
                    'Explore participants',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Draggable arrow
                AnimatedPositioned(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeOutCubic,
                  left: _dragPosition,
                  top: 4,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
