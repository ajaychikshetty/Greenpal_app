import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/events_model.dart';

class EventNotifier extends StateNotifier<List<Event>> {
  EventNotifier()
      : super([
          Event(
            id: "1",
            name: "Eco Awareness Workshop",
            date: "October 30, 2024",
            imageUrl: "https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter",
          ),
          Event(
            id: "2",
            name: "Community Clean-Up",
            date: "November 5, 2024",
            imageUrl: 'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
          ),
          Event(
            id: "3",
            name: "Sustainability Conference",
            date: "November 10, 2024",
            imageUrl: 'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
          ),
        ]);

  // Method to add a new event
  void addEvent(Event event) {
    state = [...state, event];
  }
}

// Riverpod provider for the events
final eventProvider = StateNotifierProvider<EventNotifier, List<Event>>((ref) {
  return EventNotifier();
});
