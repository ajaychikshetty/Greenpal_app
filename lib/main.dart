import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_state_provider.dart';
import 'core/utils/page_router.dart';
import 'pages/home_page.dart';
import 'pages/signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase

  runApp(const ProviderScope(child: MyApp()));  // Wrap in ProviderScope for Riverpod
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);  // Watch authentication state

    return MaterialApp(
      title: 'Ecosathi',
      theme: ThemeData.dark(),
      onGenerateRoute: PageRouter.generateRoute,  // Use route generator

      // Define a Home Widget that reacts to authState changes
      home: authState.when(
        data: (user) {
          // If user is signed in, navigate to Home page; else, go to Sign In page
          if (user != null) {
            return const HomePage();  // Navigate to Home
          } else {
            return const SignInPage();  // Navigate to Sign In
          }
        },
        loading: () => const LoadingScreen(),  // Display loading screen while checking auth state
        error: (err, stack) {
          print("Error: $err");
          return const SignInPage();  // Fallback to Sign In on error
        },
      ),
    );
  }
}
