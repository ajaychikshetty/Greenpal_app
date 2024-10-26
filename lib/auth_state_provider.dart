import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  print("Listening to auth state changes");
  return FirebaseAuth.instance.authStateChanges().map((user) {
    print("Auth state changed: ${user != null ? "Signed In" : "Signed Out"}");
    return user;
  });
});
