import 'package:mvvm_elementary_app/features/tasks/domain/repositories/task_repository.dart';

class ToggleTask {
  final TaskRepository repository;

  const ToggleTask(this.repository);

  Future<void> call(int id) {
    return repository.toggleTask(id);
  }
}
