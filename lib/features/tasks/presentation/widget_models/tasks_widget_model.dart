import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_elementary_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/entities/task_entity.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/usecases/add_task.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/usecases/get_tasks.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/usecases/toggle_task.dart';
import 'package:mvvm_elementary_app/features/tasks/presentation/models/tasks_model.dart';
import 'package:mvvm_elementary_app/features/tasks/presentation/pages/tasks_page.dart';

TasksWidgetModel tasksWidgetModelFactory(BuildContext context) {
  final repository = TaskRepositoryImpl();

  return TasksWidgetModel(
    TasksModel(
      getTasks: GetTasks(repository),
      addTask: AddTask(repository),
      toggleTask: ToggleTask(repository),
      deleteTask: DeleteTask(repository),
    ),
  );
}

class TasksWidgetModel extends WidgetModel<TasksPage, TasksModel> {
  final ValueNotifier<List<TaskEntity>> _tasksNotifier =
      ValueNotifier<List<TaskEntity>>(<TaskEntity>[]);
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _errorNotifier = ValueNotifier<String?>(null);

  ValueListenable<List<TaskEntity>> get tasksListenable => _tasksNotifier;
  ValueListenable<bool> get loadingListenable => _loadingNotifier;
  ValueListenable<String?> get errorListenable => _errorNotifier;

  TasksWidgetModel(TasksModel model) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    loadTasks();
  }

  Future<void> loadTasks() async {
    _loadingNotifier.value = true;
    _errorNotifier.value = null;

    try {
      _tasksNotifier.value = await model.loadTasks();
    } catch (_) {
      _errorNotifier.value = 'Не удалось загрузить задачи';
    } finally {
      _loadingNotifier.value = false;
    }
  }

  Future<void> addTask(String title) async {
    final String preparedTitle = title.trim();

    if (preparedTitle.isEmpty) {
      return;
    }

    await model.addTask(preparedTitle);
    _tasksNotifier.value = await model.loadTasks();
  }

  Future<void> toggleTask(int id) async {
    await model.toggleTask(id);
    _tasksNotifier.value = await model.loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await model.deleteTask(id);
    _tasksNotifier.value = await model.loadTasks();
  }

  @override
  void dispose() {
    _tasksNotifier.dispose();
    _loadingNotifier.dispose();
    _errorNotifier.dispose();
    super.dispose();
  }
}
