import 'package:eventapp_frontend/ui/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

import '../core/models/tasks.dart';
import 'validation_gamify.dart';

class GamificationHomePage extends StatefulWidget {
  const GamificationHomePage({super.key});

  @override
  State<GamificationHomePage> createState() => _GamificationHomePageState();
}

class _GamificationHomePageState extends State<GamificationHomePage> {
  final String id = "user123";
  final String userImage = "assets/images/profile.jpg";

  // Updated mock data to match your Task model
  List<Task> mockDailyTasks = [
    Task(
      id: "1",
      taskTitle: "Plant a Tree",
      taskDescription: "Find a suitable location in your community and plant a tree to contribute to environmental sustainability.",
      taskPoints: 10,
    ),
    Task(
      id: "2",
      taskTitle: "Reduce Plastic Usage",
      taskDescription: "Use reusable bags and containers instead of single-use plastic items throughout the day.",
      taskPoints: 50,
    ),
    Task(
      id: "3",
      taskTitle: "Energy Conservation",
      taskDescription: "Turn off unnecessary lights and unplug electronic devices when not in use.",
      taskPoints: 75,
    ),
  ];

  List<Task> mockCompletedTasks = [
    Task(
      id: "4",
      taskTitle: "Recycling Challenge",
      taskDescription: "Properly sorted and recycled household waste",
      taskPoints: 80,
    ),
    Task(
      id: "5",
      taskTitle: "Water Conservation",
      taskDescription: "Reduced water usage during daily activities",
      taskPoints: 60,
    ),
  ];

  Future<List<Task>> getRandomTask() async {
    await Future.delayed(const Duration(seconds: 1));
    return mockDailyTasks;
  }

  Future<List<Task>> getUserCompletedTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    return mockCompletedTasks;
  }

  late Future<List<Task>> completedTasks;

  @override
  void initState() {
    super.initState();
    completedTasks = getUserCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Task>> tasks = getRandomTask();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
      body: Stack(
        children: [
          _buildBackground(),
          _buildGlowingOrb(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(screenHeight),
                _buildStatsSection(),
                _buildTasksList(tasks),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFC5EBAA).withOpacity(0.95),
                const Color(0xFFD7F4C4).withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF66CA7F).withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Progress",
                      style: GoogleFonts.spaceMono(
                        fontSize: 22,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _buildStatItem(
                          icon: Icons.star,
                          value: "2,145",
                          label: "Points",
                        ),
                        const SizedBox(width: 20),
                        _buildStatItem(
                          icon: Icons.task_alt,
                          value: "28",
                          label: "Tasks",
                        ),
                        const SizedBox(width: 20),
                        _buildStatItem(
                          icon: Icons.local_fire_department,
                          value: "7",
                          label: "Streak",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFFFD700),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Level 5",
                      style: GoogleFonts.spaceMono(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(0xFF66CA7F),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFC5EBAA).withOpacity(0.95),
              const Color(0xFFD7F4C4).withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF66CA7F).withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskTitle ?? 'Untitled Task',
                      style: GoogleFonts.spaceMono(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      task.taskDescription ?? 'No description available',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceMono(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.white.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ValidateTask(task: task),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.play_arrow,
                                  size: 20,
                                  color: Color(0xFF66CA7F),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Do Now",
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Color(0xFFFFD700),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${task.taskPoints ?? 0}",
                                style: GoogleFonts.spaceMono(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF66CA7F).withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/task.jpg",
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
}
  Widget _buildBackground() {
    return Positioned.fill(
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
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
          decoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildGlowingOrb() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF66CA7F).withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(double screenHeight) {
    return SliverAppBar(
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
                "Daily Task",
                style: GoogleFonts.spaceMono(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
          ),
        ),
      ),
      actions: [_buildProfileAvatar()],
    );
  }
  Widget _buildProfileAvatar() {
    return Padding(
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
        child: const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage("assets/images/villager.png"),
        ),
      ),
    );
  }

  Widget _buildTasksList(Future<List<Task>> tasks) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Today's Tasks",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 550,
              child: FutureBuilder<List<Task>>(
                future: tasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return _buildErrorWidget();
                    }
                    if (snapshot.hasData) {
                      return _buildTaskItems(snapshot.data!);
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  Widget _buildErrorWidget() {
    return Center(
      child: Text(
        'Error loading tasks',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildTaskItems(List<Task> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          "No daily tasks assigned!",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => _buildTaskCard(data[index]),
    );
  }
}