import 'package:mvvm_elementary_app/features/tasks/domain/entities/task_entity.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final List<TaskEntity> _tasks = [
    const TaskEntity(
      id: 1,
      title: 'Изучить MVVM',
      isCompleted: true,
    ),
    const TaskEntity(
      id: 2,
      title: 'Проверить Elementary',
    ),
  ];

  int _nextId = 3;

  @override
  Future<List<TaskEntity>> getTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<TaskEntity>.unmodifiable(_tasks);
  }

  @override
  Future<void> addTask(String title) async {
    _tasks.add(
      TaskEntity(
        id: _nextId,
        title: title,
      ),
    );
    _nextId++;
  }

  @override
  Future<void> toggleTask(int id) async {
    final int index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      return;
    }

    final TaskEntity task = _tasks[index];
    _tasks[index] = task.copyWith(
      isCompleted: !task.isCompleted,
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
}
