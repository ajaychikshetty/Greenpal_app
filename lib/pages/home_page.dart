import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ui/widgets/bottom_navbar.dart';
import '../ui/widgets/service_category.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chatbot.dart';
import 'recycler_chatbot.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<ServiceCategory> serviceCategories = [
    ServiceCategory(
      title: "WasteBot",
      iconPath: "assets/images/bot.png",
      onTap: (context) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const ChatBot(),
          ),
        );
      },
      description: "Your AI companion for waste management",
      gradientColors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
    ),
    ServiceCategory(
      title: "Reuse",
      iconPath: "assets/images/recycle.png",
      onTap: (context) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const RecyclerChatbot(),
          ),
        );
      },
      description: "Smart recycling solutions",
      gradientColors: [Color(0xFF00796B), Color(0xFF004D40)],
    ),
  ];

  final List<Map<String, dynamic>> recommendedContent = [
    {
      'id': '1',
      'title': 'Sustainable Living Tips',
      'description': 'Learn how to reduce your carbon footprint',
      'imageUrl':
          'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
      'category': 'Article',
      'backgroundColor': Color(0xFF1B5E20),
    },
    {
      'id': '2',
      'title': 'Waste Management Guide',
      'description': 'Essential tips for proper waste segregation',
      'imageUrl':
          'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
      'category': 'Guide',
      'backgroundColor': Color(0xFF004D40),
    },
    {
      'id': '3',
      'title': 'Green Technology',
      'description': 'Latest innovations in eco-friendly tech',
      'imageUrl':
          'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
      'category': 'News',
      'backgroundColor': Color(0xFF1B5E20),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: Stack(
        children: [
          // Background shader
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
                            "GreenPal",
                            style: GoogleFonts.spaceMono(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          titlePadding:
                              const EdgeInsets.only(left: 20, bottom: 16),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF66CA7F).withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/villager.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Rest of the content
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _buildServiceCategories(context, isSmallScreen),
                        _buildRecommendedSection(context, screenSize),
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

  Widget _buildServiceCategories(BuildContext context, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Services Categories",
            style: GoogleFonts.spaceMono(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSmallScreen ? 1 : 2,
              childAspectRatio: isSmallScreen ? 1.5 : 1.2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: serviceCategories.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(serviceCategories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(ServiceCategory category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: category.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: category.gradientColors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => category.onTap(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    category.iconPath,
                    height: 48,
                    width: 48,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  category.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildRecommendedSection(BuildContext context, Size screenSize) {
  final screenHeight = screenSize.height;
  final screenWidth = screenSize.width;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(
          "Recommended For You",
          style: GoogleFonts.spaceMono(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
      ),
      SizedBox(
        height: screenHeight * 0.31,
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('events').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading data"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No recommended content available"));
            }

            final recommendedContent = snapshot.data!.docs.map((doc) {
              return {
                'id': doc.id,
                'title': doc['name'] ?? 'Untitled',
                'imageUrl': doc['bannerUrl'] ?? '',
                'category': 'Event', // default category or customize as needed
              };
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: recommendedContent.length,
              itemBuilder: (context, index) {
                final content = recommendedContent[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/rsvp',
                    arguments: content['id'],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
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
                          color: const Color(0xFF66CA7F).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF66CA7F),
                                        Color(0xFF45B95C),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF66CA7F).withOpacity(0.3),
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
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        content['imageUrl'],
                                        height: screenHeight * 0.12,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      content['title'],
                                      style: GoogleFonts.rajdhani(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF66CA7F).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        content['category'],
                                        style: GoogleFonts.spaceMono(
                                          fontSize: 12,
                                          color: const Color(0xFF66CA7F),
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
      const SizedBox(height: 16),
    ],
  );
}
}
