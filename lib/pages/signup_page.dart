import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../core/utils/page_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool isLoadingLocation = false;
  Position? currentPosition;

  // Define theme colors
  static const Color primaryGreen = Color(0xFF00FF00);
  static const Color darkGreen = Color(0xFF008000);
  static const Color backgroundBlack = Color(0xFF121212);
  static const Color surfaceBlack = Color(0xFF1E1E1E);

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
          return;
        }
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services')),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      currentPosition = position;

      // Convert coordinates to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '';
        
        // Build address string with available components
        if (place.street?.isNotEmpty ?? false) {
          address += '${place.street}, ';
        }
        if (place.subLocality?.isNotEmpty ?? false) {
          address += '${place.subLocality}, ';
        }
        if (place.locality?.isNotEmpty ?? false) {
          address += '${place.locality}, ';
        }
        if (place.administrativeArea?.isNotEmpty ?? false) {
          address += '${place.administrativeArea}, ';
        }
        if (place.country?.isNotEmpty ?? false) {
          address += place.country!;
        }

        // Remove trailing comma and space if present
        if (address.endsWith(', ')) {
          address = address.substring(0, address.length - 2);
        }

        setState(() {
          locationController.text = address;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  Future<void> _handleSignUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'location': locationController.text.trim(),
        'latitude': currentPosition?.latitude,
        'longitude': currentPosition?.longitude,
        'joinDate': DateTime.now().toLocal().toString(),
      });

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool isPassword = false,
    bool isLocation = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        readOnly: isLocation, // Make location field read-only
        style: const TextStyle(color: Colors.white),
        onTap: isLocation ? _getCurrentLocation : null, // Fetch location when tapped
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey[400],
            size: 20,
          ),
          suffixIcon: isLocation && isLoadingLocation
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey[400],
                    ),
                  ),
                )
              : isLocation
                  ? Icon(
                      Icons.my_location,
                      color: Colors.grey[400],
                      size: 20,
                    )
                  : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey[850]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: primaryGreen,
              width: 1,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[900],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlack,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Enter your details to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Form Container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceBlack,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[850]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInputField(
                        controller: nameController,
                        icon: Icons.person_outline,
                        label: 'Full Name',
                      ),
                      _buildInputField(
                        controller: emailController,
                        icon: Icons.email_outlined,
                        label: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildInputField(
                        controller: phoneController,
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                      _buildInputField(
                        controller: locationController,
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        isLocation: true, // Enable location fetching
                      ),
                      _buildInputField(
                        controller: passwordController,
                        icon: Icons.lock_outline,
                        label: 'Password',
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Sign Up Button
                ElevatedButton(
                  onPressed: _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Terms and Sign In
                Center(
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'By continuing, you agree to our ',
                          style: TextStyle(color: Colors.grey[400]),
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageRouter.signIn);
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.grey[400]),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}