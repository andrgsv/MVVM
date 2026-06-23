import 'package:mvvm_elementary_app/features/tasks/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  const AddTask(this.repository);

  Future<void> call(String title) {
    return repository.addTask(title);
  }
}
