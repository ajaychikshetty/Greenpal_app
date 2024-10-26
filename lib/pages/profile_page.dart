import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/widgets/bottom_navbar.dart';

class ProfilePage extends StatefulWidget {
  // Constants
  static const double _padding = 16.0;
  static const double _avatarSize = 120.0;
  static const double _spacing = 20.0;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample user data - Replace with actual user model
  final Map<String, dynamic> userData = {
    'name': 'Ajay Chikshetty',
    'email': 'ajay@gmail.com',
    'phone': '+91 9967643351',
    'location': 'Mumbai, India',
    'joinDate': 'March 2024',
    'eventsAttended': 12,
    'upcomingEvents': 3,
    'interests': ['Beach Cleanup', 'Tree Plantation', 'Wildlife Conservation'],
    'achievements': [
      {'title': 'Super Volunteer', 'description': 'Attended 10+ events'},
      {'title': 'Early Bird', 'description': 'Joined within first month'},
      {'title': 'Team Leader', 'description': 'Led 5 successful events'}
    ],
  };
 Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();  // Log out the user
      Navigator.of(context).pushReplacementNamed('/signin');  // Navigate to Sign In page
    } catch (e) {
      // Handle any logout errors here
      print("Logout failed: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background effects
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Glowing orbs for ambient effect
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
          SafeArea(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                // Ultra-modern app bar
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
                            "Profile",
                            style: GoogleFonts.spaceMono(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          titlePadding: EdgeInsets.only(left: 20, bottom: 16),
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
                // Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      _buildProfileContent(),
                      TextButton.icon(
      onPressed: () => _logout(context),
      icon: const Icon(Icons.logout, color: Colors.red),  // Red logout icon
      label: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.red,  // Red text
        ),
      ),
      style: TextButton.styleFrom(
        side: const BorderSide(color: Colors.red),  // Red border
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),  // Add padding for better look
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),  // Rounded corners
        ),
      ),
    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,
      backgroundColor: Colors.black,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.white),
          onPressed: () {},
        ),
       
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(ProfilePage._padding),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Background decoration
              Container(
                width: ProfilePage._avatarSize + 8,
                height: ProfilePage._avatarSize + 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.green.withOpacity(0.5), Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Profile image
              Container(
                width: ProfilePage._avatarSize,
                height: ProfilePage._avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                  image: DecorationImage(
                    image: NetworkImage('https://example.com/profile.jpg'),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) =>
                        Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
              ),
              // Online status indicator
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ProfilePage._spacing),
          Text(
            userData['name'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            userData['email'],
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Container(
      padding: EdgeInsets.all(ProfilePage._padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsSection(),
          SizedBox(height: ProfilePage._spacing),
          _buildPersonalInfo(),
          SizedBox(height: ProfilePage._spacing),
          _buildInterestsSection(),
          SizedBox(height: ProfilePage._spacing),
          _buildAchievementsSection(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ProfilePage._padding),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
              'Events\nAttended', userData['eventsAttended'].toString()),
          Container(height: 40, width: 1, color: Colors.green.withOpacity(0.3)),
          _buildStatItem(
              'Upcoming\nEvents', userData['upcomingEvents'].toString()),
          Container(height: 40, width: 1, color: Colors.green.withOpacity(0.3)),
          _buildStatItem('Member\nSince', userData['joinDate']),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Card(
      color: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(ProfilePage._padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ProfilePage._spacing),
            _buildInfoRow(Icons.phone, 'Phone', userData['phone']),
            _buildInfoRow(Icons.location_on, 'Location', userData['location']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Card(
      
      color: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(ProfilePage._padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interests',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 65,
              runSpacing: 8,
              children: userData['interests'].map<Widget>((interest) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Card(
      color: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(ProfilePage._padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ProfilePage._spacing),
            ...userData['achievements'].map<Widget>((achievement) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            achievement['description'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
