import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage; // Use alias here
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/models/tasks.dart'; // This is your Task model
import '../core/providers/notify_task.dart';
import '../core/utils/app_colors.dart';

class ValidateTask extends ConsumerStatefulWidget {
  const ValidateTask({super.key, required this.task});
  final Task task;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ValidateTaskState();
}

class _ValidateTaskState extends ConsumerState<ValidateTask> {
  String? _id;
  String? userImage_;
  File? _selectedImage;

  Future<void> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
      userImage_ = prefs.getString("image");
    });
  }

  @override
  void initState() {
    _id = "";
    userImage_ = "";
    getSession();
    super.initState();
  }

  void _takePicture() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
    );

    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    // Reference to Firebase Storage
    final firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final firebase_storage.Reference imageRef = storageRef.child(fileName);

    // Upload the image
    await imageRef.putFile(_selectedImage!);
    
    // Get the download URL
    final String downloadUrl = await imageRef.getDownloadURL();

    // Now save the task with the image URL to Firestore
    await FirebaseFirestore.instance.collection('tasks').add({
      'title': widget.task.taskTitle,
      'image_url': downloadUrl,
      'user_id': _id,
      'task_id': widget.task.id,
    });

    Fluttertoast.showToast(
      msg: "Task submitted successfully!",
      backgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Task task = widget.task;
    final double screenHeight = MediaQuery.of(context).size.height;

    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(
        Icons.camera,
        color: TColors.primaryGreen,
      ),
      label: Text(
        "Take Image",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: TColors.primaryGreen),
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient overlay
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color(0xFF1E1E1E),
                  Color(0xFF0A0A0A),
                  Color(0xFF1A1A1A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              blendMode: BlendMode.overlay,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Glowing orb effect
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF66CA7F).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Modern app bar
                SliverAppBar(
                  expandedHeight: screenHeight * 0.15,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: FlexibleSpaceBar(
                          title: Text(
                            task.taskTitle.toString().toUpperCase(),
                            style: GoogleFonts.spaceMono(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF66CA7F).withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Main content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Capture a picture to complete your task",
                          style: GoogleFonts.spaceMono(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF66CA7F),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF66CA7F).withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          height: 250,
                          width: double.infinity,
                          child: content,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF66CA7F),
                                const Color(0xFF66CA7F).withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF66CA7F).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (_selectedImage == null) {
                                Fluttertoast.showToast(
                                  msg: "Please take a picture first",
                                  backgroundColor: Colors.red,
                                );
                                return;
                              }
                              
                              await _uploadImage();
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                            child: Text(
                              "Submit your task",
                              style: GoogleFonts.spaceMono(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
