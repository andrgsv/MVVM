# КТ №9 — MVVM на Elementary

Простое приложение для управления задачами с использованием чистой архитектуры и MVVM-библиотеки Elementary.

## Возможности

- просмотр задач;
- добавление задачи;
- отметка задачи как выполненной;
- удаление задачи;
- подсчёт всех и выполненных задач;
- состояние экрана управляется через WidgetModel.

## Архитектура

```text
lib/
├── main.dart
└── features/tasks/
    ├── data/
    │   └── repositories/
    │       └── task_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   └── task_entity.dart
    │   ├── repositories/
    │   │   └── task_repository.dart
    │   └── usecases/
    │       ├── add_task.dart
    │       ├── delete_task.dart
    │       ├── get_tasks.dart
    │       └── toggle_task.dart
    └── presentation/
        ├── models/
        │   └── tasks_model.dart
        ├── pages/
        │   └── tasks_page.dart
        └── widget_models/
            └── tasks_widget_model.dart
```

## MVVM в проекте

- **View** — `TasksPage`, отображает интерфейс.
- **ViewModel** — `TasksWidgetModel`, хранит состояние и обрабатывает действия пользователя.
- **Model** — `TasksModel`, вызывает сценарии использования.
- **Domain** — сущность, интерфейс репозитория и use cases.
- **Data** — реализация репозитория.

Данные хранятся в памяти и сбрасываются после полного закрытия приложения.
