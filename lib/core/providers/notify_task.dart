import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/task_services.dart';
import '../models/tasks.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(const []);

  Future<bool> validateTask(
      String title, String imagePath, String userId, String taskId) async {
    bool response =
        await TaskServices.validateTask(title, imagePath, userId, taskId);

    return response;
  }

  Future<List<Task>> getRandomTask() async {
    final response = await TaskServices.getRandomTask();

    return response;
  }

  Future<List<Task>> getUserCompletedTasks(String userId) async {
    final response = await TaskServices.getUserCompletedTasks(userId);

    return response;
  }
}

final taskNotifier = StateNotifierProvider<TaskNotifier, List<Task>>(
  (ref) => TaskNotifier(),
);
