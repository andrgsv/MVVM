import 'package:mvvm_elementary_app/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();

  Future<void> addTask(String title);

  Future<void> toggleTask(int id);

  Future<void> deleteTask(int id);
}
