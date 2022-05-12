import 'package:sshtm/Executor/object_Job.dart';

abstract class ExecutionEvent {
  final Job _job;
  final int? _exitCode;
  final String? _shortMessage;

  Job get job => _job;

  ExecutionEvent(this._job, this._exitCode, this._shortMessage);
}

class JobReturned_ExecutionEvent extends ExecutionEvent{
  
  int get exitCode => _exitCode!;
  String get shortMessage => _shortMessage!;

  JobReturned_ExecutionEvent(Job job, int exitCode, String shortMessage) : super(job, exitCode, shortMessage);
}

class JobEnqueued_ExecutionEvent extends ExecutionEvent{

  JobEnqueued_ExecutionEvent(Job job) : super(job, null, null);
}