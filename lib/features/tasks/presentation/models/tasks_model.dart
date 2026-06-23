import 'package:elementary/elementary.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/entities/task_entity.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/usecases/add_task.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/usecases/get_tasks.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/usecases/toggle_task.dart';

class TasksModel extends ElementaryModel {
  final GetTasks _getTasks;
  final AddTask _addTask;
  final ToggleTask _toggleTask;
  final DeleteTask _deleteTask;

  TasksModel({
    required GetTasks getTasks,
    required AddTask addTask,
    required ToggleTask toggleTask,
    required DeleteTask deleteTask,
  })  : _getTasks = getTasks,
        _addTask = addTask,
        _toggleTask = toggleTask,
        _deleteTask = deleteTask;

  Future<List<TaskEntity>> loadTasks() {
    return _getTasks();
  }

  Future<void> addTask(String title) {
    return _addTask(title);
  }

  Future<void> toggleTask(int id) {
    return _toggleTask(id);
  }

  Future<void> deleteTask(int id) {
    return _deleteTask(id);
  }
}
