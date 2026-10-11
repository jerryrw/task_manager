class TaskEntity {
  final int id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final int? projectId;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    this.projectId,
  });
}
