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
import 'package:serverpod/serverpod.dart' as _is;
import '../endpoints/project_endpoint.dart' as _iemg8ri2;
import '../endpoints/task_endpoint.dart' as _idmllfay;
import '../greetings/greeting_endpoint.dart' as _il624ik7;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'project': _iemg8ri2.ProjectEndpoint()
        ..initialize(
          server,
          'project',
          null,
        ),
      'task': _idmllfay.TaskEndpoint()
        ..initialize(
          server,
          'task',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['project'] = _is.EndpointConnector(
      name: 'project',
      endpoint: endpoints['project']!,
      methodConnectors: {
        'getProjects': _is.MethodConnector(
          name: 'getProjects',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['project'] as _iemg8ri2.ProjectEndpoint)
                  .getProjects(session),
        ),
        'createProject': _is.MethodConnector(
          name: 'createProject',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['project'] as _iemg8ri2.ProjectEndpoint)
                  .createProject(
                    session,
                    params['name'],
                    params['description'],
                  ),
        ),
        'updateProject': _is.MethodConnector(
          name: 'updateProject',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['project'] as _iemg8ri2.ProjectEndpoint)
                  .updateProject(
                    session,
                    params['projectId'],
                    params['name'],
                    params['description'],
                  ),
        ),
        'deleteProject': _is.MethodConnector(
          name: 'deleteProject',
          params: {
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['project'] as _iemg8ri2.ProjectEndpoint)
                  .deleteProject(
                    session,
                    params['projectId'],
                  ),
        ),
      },
    );
    connectors['task'] = _is.EndpointConnector(
      name: 'task',
      endpoint: endpoints['task']!,
      methodConnectors: {
        'createTask': _is.MethodConnector(
          name: 'createTask',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['task'] as _idmllfay.TaskEndpoint).createTask(
                    session,
                    params['title'],
                  ),
        ),
        'getTasks': _is.MethodConnector(
          name: 'getTasks',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _idmllfay.TaskEndpoint).getTasks(
                session,
              ),
        ),
        'getTask': _is.MethodConnector(
          name: 'getTask',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _idmllfay.TaskEndpoint).getTask(
                session,
                params['taskId'],
              ),
        ),
        'setCompleted': _is.MethodConnector(
          name: 'setCompleted',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'completed': _is.ParameterDescription(
              name: 'completed',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['task'] as _idmllfay.TaskEndpoint).setCompleted(
                    session,
                    params['taskId'],
                    params['completed'],
                  ),
        ),
        'updateTask': _is.MethodConnector(
          name: 'updateTask',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'priority': _is.ParameterDescription(
              name: 'priority',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'dueDate': _is.ParameterDescription(
              name: 'dueDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['task'] as _idmllfay.TaskEndpoint).updateTask(
                    session,
                    params['taskId'],
                    params['title'],
                    params['description'],
                    params['priority'],
                    params['dueDate'],
                  ),
        ),
        'deleteTask': _is.MethodConnector(
          name: 'deleteTask',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['task'] as _idmllfay.TaskEndpoint).deleteTask(
                    session,
                    params['taskId'],
                  ),
        ),
        'assignTaskToProject': _is.MethodConnector(
          name: 'assignTaskToProject',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'projectId': _is.ParameterDescription(
              name: 'projectId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _idmllfay.TaskEndpoint)
                  .assignTaskToProject(
                    session,
                    params['taskId'],
                    params['projectId'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
  }
}
