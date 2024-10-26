import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/event_provider.dart';
import '../core/providers/user_event_provider.dart';
import '../ui/widgets/bottom_navbar.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventProvider);
    final userEvents = ref.watch(userEventProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Animated background gradient
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
                            "EVENTS",
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
                            'https://firebasestorage.googleapis.com/v0/b/safaisathi-febc9.appspot.com/o/banners%2F25d85e78-facd-4574-b40c-fa6fea89bda8-OIP.jpeg?alt=media&token=7ac88226-75de-4506-8703-357e558aa7ed',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        // Stats container with glassmorphism
                        Container(
                          height: screenHeight * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    // Left side with counter
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF66CA7F),
                                              Color(0xFF45B95C),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF66CA7F)
                                                  .withOpacity(0.3),
                                              blurRadius: 20,
                                              spreadRadius: -5,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${events.length}',
                                              style: GoogleFonts.rajdhani(
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'UPCOMING',
                                              style: GoogleFonts.spaceMono(
                                                fontSize: 14,
                                                letterSpacing: 2,
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    // Right side with title
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'YOUR',
                                            style: GoogleFonts.rajdhani(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                          ),
                                          Text(
                                            'JOURNEY',
                                            style: GoogleFonts.rajdhani(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF66CA7F),
                                              height: 1,
                                            ),
                                          ),
                                          Text(
                                            'BEGINS HERE',
                                            style: GoogleFonts.rajdhani(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1,
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
                        ),
                        SizedBox(height: 20),

                        Text(
                          'THIS MONTH',
                          style: GoogleFonts.spaceMono(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.6),
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: screenHeight * 0.31,
                          child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('events')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text("Error loading data"));
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text(
                                        "No recommended content available"));
                              }

                              final recommendedContent =
                                  snapshot.data!.docs.map((doc) {
                                return {
                                  'id': doc.id,
                                  'title': doc['name'] ?? 'Untitled',
                                  'imageUrl': doc['bannerUrl'] ?? '',
                                  'category':
                                      'Event', // default category or customize as needed
                                };
                              }).toList();

                              return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: recommendedContent.length,
                                itemBuilder: (context, index) {
                                  final content = recommendedContent[index];
                                  return GestureDetector(
                                    onTap: () {
                                      print(content['id']);
                                      print("--------------------------");
                                      Navigator.pushNamed(
                                        context,
                                        '/rsvp',
                                        arguments: content['id'],
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Container(
                                        width: screenWidth * 0.6,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.1),
                                              Colors.white.withOpacity(0.05),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF66CA7F)
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 20,
                                                  right: 20,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xFF66CA7F),
                                                          Color(0xFF45B95C),
                                                        ],
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                                  0xFF66CA7F)
                                                              .withOpacity(0.3),
                                                          blurRadius: 10,
                                                          spreadRadius: 0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                      Icons.star_rounded,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image.network(
                                                          content['imageUrl'],
                                                          height: screenHeight *
                                                              0.12,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        content['title'],
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                                  0xFF66CA7F)
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Text(
                                                          content['category'],
                                                          style: GoogleFonts
                                                              .spaceMono(
                                                            fontSize: 12,
                                                            color: const Color(
                                                                0xFF66CA7F),
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 40),

                        // New "YOUR EVENTS" section
                        Text(
                          'YOUR EVENTS',
                          style: GoogleFonts.spaceMono(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.6),
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: SizedBox(
                              height: screenHeight * 0.3,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: userEvents.length,
                                itemBuilder: (context, index) {
                                  final event = userEvents[index];
                                  final isCompleted = event.status == 'completed';
                          
                                  return GestureDetector(
                                    onTap: () {
                                      if (isCompleted) {
                                        Navigator.pushNamed(
                                            context, '/completedeventinfo',
                                            arguments: event);
                                      } else {
                                        Navigator.pushNamed(context, '/EventInfo',
                                            arguments: event);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Container(
                                        width: screenWidth * 0.6,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.1),
                                              Colors.white.withOpacity(0.05),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          border: Border.all(
                                            color: Color(0xFF66CA7F)
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Stack(
                                              children: [
                                                // Status badge
                                                Positioned(
                                                  top: 20,
                                                  right: 20,
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: LinearGradient(
                                                        colors: isCompleted
                                                            ? [
                                                                Color(0xFF66CA7F),
                                                                Color(0xFF45B95C),
                                                              ]
                                                            : [
                                                                Colors.orange,
                                                                Colors.deepOrange,
                                                              ],
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: isCompleted
                                                              ? Color(0xFF66CA7F)
                                                                  .withOpacity(
                                                                      0.3)
                                                              : Colors.orange
                                                                  .withOpacity(
                                                                      0.3),
                                                          blurRadius: 10,
                                                          spreadRadius: 0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(
                                                      isCompleted
                                                          ? Icons.check_circle
                                                          : Icons.pending,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                // Content
                                                Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        child: Image.network(
                                                          event.imageUrl,
                                                          height:
                                                              screenHeight * 0.12,
                                                          width: double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        event.name,
                                                        style:
                                                            GoogleFonts.rajdhani(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: isCompleted
                                                              ? Color(0xFF66CA7F)
                                                                  .withOpacity(
                                                                      0.2)
                                                              : Colors.orange
                                                                  .withOpacity(
                                                                      0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Text(
                                                          event.status
                                                              .toUpperCase(),
                                                          style: GoogleFonts
                                                              .spaceMono(
                                                            fontSize: 12,
                                                            color: isCompleted
                                                                ? Color(
                                                                    0xFF66CA7F)
                                                                : Colors.orange,
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
                                    ),
                                  );
                                },
                              )),
                        ),

                        SizedBox(height: 40),
                        // Events grid

                        SizedBox(height: 30),
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
