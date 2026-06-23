import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/entities/task_entity.dart';
import 'package:mvvm_elementary_app/features/tasks/presentation/widget_models/tasks_widget_model.dart';

class TasksPage extends ElementaryWidget<TasksWidgetModel> {
  const TasksPage({
    Key? key,
    WidgetModelFactory wmFactory = tasksWidgetModelFactory,
  }) : super(wmFactory, key: key);

  Future<void> _showAddDialog(
    BuildContext context,
    TasksWidgetModel wm,
  ) async {
    final String? title = await showDialog<String>(
      context: context,
      builder: (_) => const _AddTaskDialog(),
    );

    if (title != null) {
      await wm.addTask(title);
    }
  }

  @override
  Widget build(TasksWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи — MVVM'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: wm.loadTasks,
            tooltip: 'Обновить',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: wm.loadingListenable,
        builder: (_, isLoading, __) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ValueListenableBuilder<String?>(
            valueListenable: wm.errorListenable,
            builder: (_, error, __) {
              if (error != null) {
                return Center(
                  child: Text(error),
                );
              }

              return ValueListenableBuilder<List<TaskEntity>>(
                valueListenable: wm.tasksListenable,
                builder: (_, tasks, __) {
                  return _TasksList(
                    tasks: tasks,
                    onToggle: wm.toggleTask,
                    onDelete: wm.deleteTask,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () => _showAddDialog(context, wm),
            icon: const Icon(Icons.add),
            label: const Text('Добавить'),
          );
        },
      ),
    );
  }
}

class _TasksList extends StatelessWidget {
  final List<TaskEntity> tasks;
  final Future<void> Function(int id) onToggle;
  final Future<void> Function(int id) onDelete;

  const _TasksList({
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'Задач пока нет',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    final int completed =
        tasks.where((task) => task.isCompleted).length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.view_module_outlined),
              title: Text('Всего задач: ${tasks.length}'),
              subtitle: Text('Выполнено: $completed'),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final TaskEntity task = tasks[index];

              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => onToggle(task.id),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text('ID: ${task.id}'),
                  trailing: IconButton(
                    onPressed: () => onDelete(task.id),
                    tooltip: 'Удалить',
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(context, _title.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая задача'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Название задачи',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _title = value;
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Введите название';
            }

            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
