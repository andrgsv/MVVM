import 'package:mvvm_elementary_app/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  const DeleteTask(this.repository);

  Future<void> call(int id) {
    return repository.deleteTask(id);
  }
}
