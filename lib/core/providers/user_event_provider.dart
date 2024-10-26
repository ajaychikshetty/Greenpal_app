import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_events.dart';

// Provider state notifier
class UserEventNotifier extends StateNotifier<List<UserEvent>> {
  UserEventNotifier() : super([]) {
    loadUserEvents();
  }

  Future<void> loadUserEvents() async {
    // Clear the existing state
    state = [];

    // Reference to your Firestore collection
    CollectionReference userEventsCollection =
        FirebaseFirestore.instance.collection('rsvps');

    try {
      // Fetch the documents from the collection
      QuerySnapshot querySnapshot = await userEventsCollection.get();

      // Iterate through the documents and map them to UserEvent objects
      for (var doc in querySnapshot.docs) {
        state.add(
          UserEvent(
            id: doc.id, // Assuming the document ID is the event ID
            name: doc['name'], // Adjust according to your document structure
            imageUrl:
                doc['bannerUrl'], // Adjust according to your document structure
            status:
                doc['status'], // Adjust according to your document structure
          ),
        );
      }
    } catch (e) {
      print('Error loading user events: $e');
    }
  }

  // Add a new event
  void addEvent(UserEvent event) {
    state = [...state, event];
  }

  // Remove an event
  void removeEvent(String eventId) {
    state = state.where((event) => event.id != eventId).toList();
  }

  // Update event status
  void updateEventStatus(String eventId, String newStatus) {
    state = state.map((event) {
      if (event.id == eventId) {
        return UserEvent(
          id: event.id,
          name: event.name,
          imageUrl: event.imageUrl,
          status: newStatus,
        );
      }
      return event;
    }).toList();
  }

  // Get completed events
  List<UserEvent> getCompletedEvents() {
    return state.where((event) => event.status == 'completed').toList();
  }

  // Get ongoing events
  List<UserEvent> getOngoingEvents() {
    return state.where((event) => event.status == 'ongoing').toList();
  }
}

// Main provider
final userEventProvider =
    StateNotifierProvider<UserEventNotifier, List<UserEvent>>((ref) {
  return UserEventNotifier();
});

// Providers for filtered lists
final completedEventsProvider = Provider<List<UserEvent>>((ref) {
  final userEventNotifier = ref.watch(userEventProvider.notifier);
  return userEventNotifier.getCompletedEvents();
});

final ongoingEventsProvider = Provider<List<UserEvent>>((ref) {
  final userEventNotifier = ref.watch(userEventProvider.notifier);
  return userEventNotifier.getOngoingEvents();
});

// Repository class for API calls
class UserEventRepository {
  Future<List<UserEvent>> fetchUserEvents() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      UserEvent(
        id: 'ue1',
        name: 'Flutter Workshop',
        imageUrl: 'https://your-image-url.com/flutter-workshop',
        status: 'completed',
      ),
    ];
  }

  Future<void> saveUserEvent(UserEvent event) async {
    await Future.delayed(Duration(milliseconds: 500));
  }
}

// Repository provider
final userEventRepositoryProvider = Provider<UserEventRepository>((ref) {
  return UserEventRepository();
});

// Async provider for handling loading states
class AsyncUserEventNotifier extends AsyncNotifier<List<UserEvent>> {
  @override
  Future<List<UserEvent>> build() async {
    final repository = ref.read(userEventRepositoryProvider);
    return await repository.fetchUserEvents();
  }

  Future<void> addEvent(UserEvent event) async {
    final repository = ref.read(userEventRepositoryProvider);
    state = AsyncValue.data([...state.value!, event]);
    await repository.saveUserEvent(event);
  }
}

final asyncUserEventProvider =
    AsyncNotifierProvider<AsyncUserEventNotifier, List<UserEvent>>(() {
  return AsyncUserEventNotifier();
});
