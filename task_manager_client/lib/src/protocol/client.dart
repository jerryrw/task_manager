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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:task_manager_client/src/protocol/greetings/greeting.dart'
    as _i0lu24jz;
import 'package:task_manager_client/src/protocol/project.dart' as _it4lz4s6;
import 'package:task_manager_client/src/protocol/task.dart' as _icduhfh6;
import 'protocol.dart' as _il2as5qe;

/// {@category Endpoint}
class EndpointProject extends _isc.EndpointRef {
  EndpointProject(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'project';

  _ida.Future<List<_it4lz4s6.Project>> getProjects() =>
      caller.callServerEndpoint<List<_it4lz4s6.Project>>(
        'project',
        'getProjects',
        {},
      );

  _ida.Future<_it4lz4s6.Project> createProject(
    String name,
    String? description,
  ) => caller.callServerEndpoint<_it4lz4s6.Project>(
    'project',
    'createProject',
    {
      'name': name,
      'description': description,
    },
  );

  _ida.Future<_it4lz4s6.Project?> updateProject(
    int projectId,
    String name,
    String? description,
  ) => caller.callServerEndpoint<_it4lz4s6.Project?>(
    'project',
    'updateProject',
    {
      'projectId': projectId,
      'name': name,
      'description': description,
    },
  );

  _ida.Future<bool> deleteProject(int projectId) =>
      caller.callServerEndpoint<bool>(
        'project',
        'deleteProject',
        {'projectId': projectId},
      );
}

/// {@category Endpoint}
class EndpointTask extends _isc.EndpointRef {
  EndpointTask(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'task';

  _ida.Future<_icduhfh6.Task> createTask(String title) =>
      caller.callServerEndpoint<_icduhfh6.Task>(
        'task',
        'createTask',
        {'title': title},
      );

  _ida.Future<List<_icduhfh6.Task>> getTasks() =>
      caller.callServerEndpoint<List<_icduhfh6.Task>>(
        'task',
        'getTasks',
        {},
      );

  _ida.Future<_icduhfh6.Task?> getTask(int taskId) =>
      caller.callServerEndpoint<_icduhfh6.Task?>(
        'task',
        'getTask',
        {'taskId': taskId},
      );

  _ida.Future<_icduhfh6.Task?> setCompleted(
    int taskId,
    bool completed,
  ) => caller.callServerEndpoint<_icduhfh6.Task?>(
    'task',
    'setCompleted',
    {
      'taskId': taskId,
      'completed': completed,
    },
  );

  _ida.Future<_icduhfh6.Task?> updateTask(
    int taskId,
    String title,
    String? description,
    int priority,
    DateTime? dueDate,
  ) => caller.callServerEndpoint<_icduhfh6.Task?>(
    'task',
    'updateTask',
    {
      'taskId': taskId,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
    },
  );

  _ida.Future<bool> deleteTask(int taskId) => caller.callServerEndpoint<bool>(
    'task',
    'deleteTask',
    {'taskId': taskId},
  );

  _ida.Future<_icduhfh6.Task?> assignTaskToProject(
    int taskId,
    int? projectId,
  ) => caller.callServerEndpoint<_icduhfh6.Task?>(
    'task',
    'assignTaskToProject',
    {
      'taskId': taskId,
      'projectId': projectId,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_i0lu24jz.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i0lu24jz.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    project = EndpointProject(this);
    task = EndpointTask(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointProject project;

  late final EndpointTask task;

  late final EndpointGreeting greeting;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'project': project,
    'task': task,
    'greeting': greeting,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
