import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class EventParticipantsPage extends StatelessWidget {
  final String eventName;
  final List<Map<String, String>> participants;

  // Custom colors and gradients
  static const primaryGreen = Color(0xFF66CA7F);
  static const darkGreen = Color(0xFF2D5A27);
  static const backgroundBlack = Color(0xFF121212);
  static const surfaceBlack = Color(0xFF1E1E1E);

  const EventParticipantsPage({
    Key? key,
    required this.eventName,
    required this.participants,
  }) : super(key: key);

  void _showParticipantDetails(BuildContext context, Map<String, String> participant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: backgroundBlack,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Profile Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            surfaceBlack,
                            surfaceBlack.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Profile Image
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  primaryGreen.withOpacity(0.5),
                                  primaryGreen,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryGreen.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(participant['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            participant['name'] ?? "Participant Name",
                            style: GoogleFonts.spaceMono(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            participant['email'] ?? "No email",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Stats Section
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STATISTICS',
                            style: GoogleFonts.spaceMono(
                              color: Colors.white70,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              _buildStatCard(
                                'Events\nAttended',
                                '12',
                                primaryGreen,
                              ),
                              SizedBox(width: 16),
                              _buildStatCard(
                                'Current\nStatus',
                                participant['status'] ?? 'N/A',
                                participant['status'] == 'Confirmed'
                                    ? primaryGreen
                                    : Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Additional Info
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ADDITIONAL INFO',
                            style: GoogleFonts.spaceMono(
                              color: Colors.white70,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildInfoTile('Phone', participant['phone'] ?? 'N/A'),
                          _buildInfoTile('Location', participant['location'] ?? 'N/A'),
                          _buildInfoTile('Department', participant['department'] ?? 'N/A'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.spaceMono(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: backgroundBlack,
      body: Stack(
        children: [
          // Background effects
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  surfaceBlack,
                  backgroundBlack,
                  Color(0xFF1A1A1A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              blendMode: BlendMode.overlay,
              child: Container(color: backgroundBlack),
            ),
          ),
          
          // Main content
          SafeArea(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                // Modern AppBar
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
                              backgroundBlack.withOpacity(0.7),
                              backgroundBlack.withOpacity(0.3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: FlexibleSpaceBar(
                          title: Text(
                            eventName.toUpperCase(),
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
                ),
                
                // Participants List
                SliverPadding(
                  padding: EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final participant = participants[index];
                        return GestureDetector(
                          onTap: () => _showParticipantDetails(context, participant),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  surfaceBlack,
                                  surfaceBlack.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: primaryGreen.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryGreen.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: -5,
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryGreen.withOpacity(0.5),
                                      primaryGreen,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(participant['image']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                participant['name'] ?? "Participant Name",
                                style: GoogleFonts.spaceMono(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                participant['email'] ?? "No email",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: participant['status'] == "Confirmed"
                                      ? primaryGreen.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: participant['status'] == "Confirmed"
                                        ? primaryGreen.withOpacity(0.2)
                                        : Colors.red.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  participant['status'] ?? "Status",
                                  style: TextStyle(
                                    color: participant['status'] == "Confirmed"
                                        ? primaryGreen
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: participants.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Empty State
          if (participants.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryGreen.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.group_outlined,
                      size: 48,
                      color: primaryGreen,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No participants yet',
                    style: GoogleFonts.spaceMono(
                      color: Colors.white70,
                      fontSize: 18,
                      letterSpacing: 1,
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