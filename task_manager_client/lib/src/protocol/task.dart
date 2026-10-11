/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Task
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Task._({
    this.id,
    required this.title,
    this.description,
    bool? isCompleted,
    int? priority,
    this.dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.projectId,
  }) : isCompleted = isCompleted ?? false,
       priority = priority ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Task({
    int? id,
    required String title,
    String? description,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? projectId,
  }) = _TaskImpl;

  factory Task.fromJson(Map<String, dynamic> jsonSerialization) {
    return Task(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      isCompleted: jsonSerialization['isCompleted'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isCompleted']),
      priority: jsonSerialization['priority'] as int?,
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      projectId: jsonSerialization['projectId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String? description;

  bool isCompleted;

  int priority;

  DateTime? dueDate;

  DateTime createdAt;

  DateTime updatedAt;

  int? projectId;

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? projectId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'isCompleted': isCompleted,
      'priority': priority,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (projectId != null) 'projectId': projectId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'isCompleted': isCompleted,
      'priority': priority,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (projectId != null) 'projectId': projectId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskImpl extends Task {
  _TaskImpl({
    int? id,
    required String title,
    String? description,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? projectId,
  }) : super._(
         id: id,
         title: title,
         description: description,
         isCompleted: isCompleted,
         priority: priority,
         dueDate: dueDate,
         createdAt: createdAt,
         updatedAt: updatedAt,
         projectId: projectId,
       );

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Task copyWith({
    Object? id = _Undefined,
    String? title,
    Object? description = _Undefined,
    bool? isCompleted,
    int? priority,
    Object? dueDate = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? projectId = _Undefined,
  }) {
    return Task(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectId: projectId is int? ? projectId : this.projectId,
    );
  }
}
