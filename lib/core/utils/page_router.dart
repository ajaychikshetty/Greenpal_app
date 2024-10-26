import 'package:eventapp_frontend/pages/completed_event_info.dart';
import 'package:eventapp_frontend/pages/home_page.dart';
import 'package:eventapp_frontend/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '../../pages/EventInfo.dart';
import '../../pages/Homepage_game.dart';
import '../../pages/event_page.dart';
import '../../pages/report_homepage.dart';
import '../../pages/show_ticket.dart';
import '../../pages/signin_page.dart';
import '../../pages/signup_page.dart';
import '../../pages/upcoming_event.dart';

class PageRouter {
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String signIn = '/signin';  
  static const String eventpage = '/event';
  static const String eventinfo = '/EventInfo';
  static const String showtickets = '/showtickets';
  static const String profile = '/profile';
  static const String report = '/report';
  static const String game = '/gamify';
  static const String completedeventinfo = '/completedeventinfo';
  static const String upcomingevent = '/rsvp';
  static const String loading = '/loading';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loading:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case eventpage:
        return MaterialPageRoute(builder: (_) => EventPage());
      case eventinfo:
        return MaterialPageRoute(builder: (_) => EventInfoPage());
      case completedeventinfo:
        return MaterialPageRoute(builder: (_) => CompletedEventInfo());
      case showtickets:
        return MaterialPageRoute(builder: (_) => ShowTickets());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case report:
        return MaterialPageRoute(builder: (_) => ReportPage());
      case game:
        return MaterialPageRoute(builder: (_) => GamificationHomePage());
      case upcomingevent:
        return MaterialPageRoute(builder: (_) => UpcomingEvent());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading, please wait...'),  // Add a loading message
          ],
        ),
      ),
    );
  }
}
