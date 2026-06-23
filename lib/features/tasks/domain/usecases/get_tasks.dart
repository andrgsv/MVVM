import 'package:mvvm_elementary_app/features/tasks/domain/entities/task_entity.dart';
import 'package:mvvm_elementary_app/features/tasks/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  const GetTasks(this.repository);

  Future<List<TaskEntity>> call() {
    return repository.getTasks();
  }
}
