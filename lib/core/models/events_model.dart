import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the Event model
class Event {
  final String id;
  final String name;
  final String date;
  final String imageUrl;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.imageUrl,
  });
}

// Define a provider using Riverpod
final eventProvider = StateNotifierProvider<EventNotifier, List<Event>>((ref) {
  return EventNotifier();
});

// Notifier class to manage events
class EventNotifier extends StateNotifier<List<Event>> {
  EventNotifier() : super([]);

  void addEvent(Event event) {
    state = [...state, event];
  }
}
